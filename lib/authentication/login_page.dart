// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_app/components/My_button.dart';
import 'package:chat_app/components/mytextfield.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  void Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  void signIn(BuildContext context) async {
    //auth service
    final authService = AuthService();
    //try sign in
    try {
      await authService.signInWithEmailPassword(
          _emailcontroller.text, _passwordcontroller.text);
    }
    //catch error
    catch (e) {
      showDialog(
          context: context,
          builder: (context) {return AlertDialog(
                title: Text(e.toString()),
              );});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              Icon(
                Icons.message,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(
                height: 50,
              ),

              //welcome message
              Text(
                "Welcome back!",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 20,
              ),

              //email
              MyTextField(
                textcontroller: _emailcontroller,
                text: "E-Mail",
                obscuretext: false,
              ),
              SizedBox(
                height: 20,
              ),
              //pass
              MyTextField(
                textcontroller: _passwordcontroller,
                text: "Password",
                obscuretext: true,
              ),
              SizedBox(
                height: 20,
              ),
              //login
              MyButton(onTap:()=> signIn(context), text: "Sign In"),
              SizedBox(
                height: 20,
              ),
              //register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member?",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: 18),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Register Now",
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
