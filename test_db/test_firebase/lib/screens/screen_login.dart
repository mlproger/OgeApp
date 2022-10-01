import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwodController = TextEditingController();

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwodController.text);
    } catch (e) {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          title: 'Неверный логин или пароль');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwodController.dispose();
    super.dispose();
  }

  bool isObsurve = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(23, 28, 38, 1),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 4),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.white),
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.white),
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 4),
                    child: TextField(
                      controller: _passwodController,
                      obscureText: !isObsurve,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Пароль',
                        hintStyle: TextStyle(color: Colors.white),
                        suffixIcon: IconButton(
                            onPressed: () {
                              isObsurve = !isObsurve;
                              setState(() {});
                            },
                            icon: Icon(
                              isObsurve
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 30,
                              color: Colors.white,
                            )),
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 4),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            minimumSize: Size(300, 50)),
                        onPressed: () {
                          signIn();
                        },
                        child: const Text('Войти')),
                  ),
                  TextButton(
                      onPressed: () {}, child: const Text('Создать аккаунт'))
                ]),
          ),
        ));
  }
}
