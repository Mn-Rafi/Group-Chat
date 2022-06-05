import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/custom_widgets.dart';
import 'package:flash_chat/data/hive.dart';
import 'package:flash_chat/logic/cubit/ShowSpinner/showspinner_cubit.dart';
import 'package:flash_chat/main.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String? email;
  String? password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<ShowspinnerCubit, ShowspinnerState>(
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                  const SizedBox(
                    height: 48.0,
                  ),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      email = value;
                    },
                    style: const TextStyle(color: Colors.black, fontSize: 13),
                    decoration: inputDecoration.copyWith(
                      hintText: 'Enter the email',
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      password = value;
                    },
                    style: const TextStyle(color: Colors.black, fontSize: 13),
                    decoration: inputDecoration.copyWith(
                        hintText: 'Enter the password'),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  CustomButton(
                      customButtonArgs: CustomButtonArgs(
                    buttonColor: Colors.lightBlueAccent,
                    buttonText: 'Log In',
                    onPressed: () async {
                      showSpinner =
                          context.read<ShowspinnerCubit>().showSpinner(true);
                      try {
                        final user = await _auth.signInWithEmailAndPassword(
                            email: email ?? 'moideenrafihpa@gmail.com',
                            password: password ?? '123456');
                        await Hive.box<StoreIndex>(storeIndexBox).put(
                            Hive.box<StoreIndex>(storeIndexBox)
                                .values
                                .toList()[0]
                                .key,
                            StoreIndex(isLoggedIn: true));

                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          ChatScreen.id,
                          (route) => false,
                        );
                      } catch (e) {
                        print("EXCEPTIONNNNNNNNNNNNNNNNNNNNNN $e");
                        showSpinner =
                            context.read<ShowspinnerCubit>().showSpinner(false);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                duration: Duration(milliseconds: 1000),
                                content: Text(
                                    'email or password entered is wrong!!')));
                      }
                    },
                  )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
