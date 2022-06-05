import 'package:flash_chat/constants.dart';
import 'package:flash_chat/custom_widgets.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
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
              decoration:
                  inputDecoration.copyWith(hintText: 'Enter the password'),
            ),
            const SizedBox(
              height: 24.0,
            ),
            CustomButton(
                customButtonArgs: CustomButtonArgs(
                    buttonColor: Colors.blueAccent,
                    buttonText: 'Register',
                    onPressed: () async {

                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email ?? 'moideenrafihpa@gmail.com',
                                password: password ?? '12345678');
                        Navigator.pushReplacementNamed(
                          context,
                          LoginScreen.id,
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(milliseconds: 1000),
                      content: Text(
                          'email or password format is incorrect')));
                      }
                    })),
          ],
        ),
      ),
    );
  }
}
