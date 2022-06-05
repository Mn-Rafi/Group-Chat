import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/data/hive.dart';
import 'package:flash_chat/logic/cubit/ShowSpinner/showspinner_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

const String storeIndexBox = 'storeIndex';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter<StoreIndex>(StoreIndexAdapter());
  await Hive.openBox<StoreIndex>('storeIndex');
  await Hive.box<StoreIndex>(storeIndexBox)
      .add(StoreIndex(isLoggedIn: false));
  runApp(const FlashChat());
}

class FlashChat extends StatelessWidget {
  const FlashChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong!!'),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return BlocProvider(
            create: (context) => ShowspinnerCubit(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: Hive.box<StoreIndex>(storeIndexBox)
                      .values
                      .toList()[0]
                      .isLoggedIn
                  ? ChatScreen.id
                  : WelcomeScreen.id,
              routes: {
                WelcomeScreen.id: (context) => WelcomeScreen(),
                LoginScreen.id: (context) => LoginScreen(),
                RegistrationScreen.id: (context) => RegistrationScreen(),
                ChatScreen.id: (context) => ChatScreen(),
              },
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const CircularProgressIndicator();
      },
    );
  }
}
