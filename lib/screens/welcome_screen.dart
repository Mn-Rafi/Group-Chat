import 'package:flash_chat/custom_widgets.dart';
import 'package:flash_chat/data/hive.dart';
import 'package:flash_chat/main.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welocme_screen';

  const WelcomeScreen({Key? key}) : super(key: key);
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  child: Image.asset('images/logo.png'),
                  height: 60.0,
                ),
                const Text(
                  'Flash Chat',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            CustomButton(
                customButtonArgs: CustomButtonArgs(
                    buttonColor: Colors.lightBlueAccent,
                    buttonText: 'Log In',
                    onPressed: () async {
                      
                      Navigator.pushNamed(
                        context,
                        LoginScreen.id,
                      );
                    })),
            CustomButton(
                customButtonArgs: CustomButtonArgs(
                    buttonColor: Colors.blueAccent,
                    buttonText: 'Register',
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        RegistrationScreen.id,
                      );
                    })),
          ],
        ),
      ),
    );
  }
}
