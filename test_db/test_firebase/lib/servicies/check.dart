import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test_firebase/main.dart';
import 'package:test_firebase/screens/screen_login.dart';

class MainCheck extends StatelessWidget {
  const MainCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MainWidget();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
