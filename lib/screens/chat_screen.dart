import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/custom_widgets.dart';
import 'package:flash_chat/data/hive.dart';
import 'package:flash_chat/logic/cubit/ShowSpinner/showspinner_cubit.dart';
import 'package:flash_chat/main.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  const ChatScreen({Key? key}) : super(key: key);
  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User loggedinUser;
  String? messageText;
  DateTime? dateTime;
  String? date;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedinUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void dateString(DateTime dateTime) {
    if (dateTime.hour < 10) {
      if (dateTime.minute < 10) {
        date = '0${dateTime.hour}:0${dateTime.minute}';
      } else {
        date = '0${dateTime.hour}:${dateTime.minute}';
      }
    } else {
      if (dateTime.minute < 10) {
        date = '${dateTime.hour}:0${dateTime.minute}';
      } else {
        date = '${dateTime.hour}:${dateTime.minute}';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(FocusScope.of(context).hasFocus);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                _auth.signOut();
                Hive.box<StoreIndex>(storeIndexBox)
                    .putAt(0, StoreIndex(isLoggedIn: false));
                Navigator.pushNamedAndRemoveUntil(
                    context, WelcomeScreen.id, (route) => false);
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
                child: StreamBuilder<QuerySnapshot>(
              stream: _fireStore
                  .collection('messages')
                  .orderBy('timeStamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data!.docs.reversed;
                  List<Text> messageWidgets = [];
                  List<Text> senderWidgets = [];
                  List<Text> dateWidgets = [];
                  for (var message in messages) {
                    final messageText = message.get('text');
                    final messageSender = message.get('sender');
                    final messageDate = message.get('time');

                    final messageWidget = Text(
                      messageText,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    );
                    final senderWidget = Text(
                      messageSender,
                      style: TextStyle(color: Colors.grey[400]),
                    );
                    final dateWidget = Text(
                      messageDate,
                      style: TextStyle(color: Colors.green[100]),
                    );
                    messageWidgets.add(messageWidget);
                    senderWidgets.add(senderWidget);
                    dateWidgets.add(dateWidget);
                  }
                  return messageWidgets.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          reverse: true,
                          itemCount: messageWidgets.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomPaint(
                                painter: ChatBubble(
                                    color: loggedinUser.email ==
                                            senderWidgets[index].data
                                        ? Colors.blue
                                        : Colors.deepPurple,
                                    alignment: loggedinUser.email ==
                                            senderWidgets[index].data
                                        ? Alignment.topRight
                                        : Alignment.topLeft),
                                child: ListTile(
                                  title: messageWidgets[index],
                                  subtitle: senderWidgets[index],
                                  trailing: dateWidgets[index],
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text('Awake the group with your chat 😉'),
                        );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  BlocBuilder<ShowspinnerCubit, ShowspinnerState>(
                    builder: (context, state) {
                      return Expanded(
                        child: SizedBox(
                          width: 300,
                          height: 60,
                          child: TextField(
                            controller: textController,
                            onChanged: (value) {
                              messageText = value;
                            },
                            decoration: kMessageTextFieldDecoration,
                          ),
                        ),
                      );
                    },
                  ),
                  TextButton(
                    onPressed: () async {
                      dateTime = DateTime.now();
                      dateString(dateTime!);
                      _fireStore.collection('messages').add({
                        'sender': loggedinUser.email,
                        'text': messageText,
                        'time': date,
                        'timeStamp': dateTime
                      });

                      context
                          .read<ShowspinnerCubit>()
                          .clearTextField(textController);
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
