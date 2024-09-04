// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_app/components/My_button.dart';
import 'package:chat_app/components/mytextfield.dart';
import 'package:chat_app/pages/LogOrReg_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  void Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _conpasswordcontroller = TextEditingController();

  void register(BuildContext context) {
    final _auth = AuthService();


    //if passwords match
    if (_passwordcontroller.text == _conpasswordcontroller.text) {
      try {
        _auth.signUpWithEmailPassword(
            _emailcontroller.text, _passwordcontroller.text);

        // Create user doc and add to firestore

      } catch (e) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(e.toString()),
                ));
      }
    }
    //if passwords don't match
    else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Passwords don't match!"),
              ));
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
                "Let's Create an Account",
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

              //confirm pass
              MyTextField(
                textcontroller: _conpasswordcontroller,
                text: "Confirm Password",
                obscuretext: true,
              ),
              SizedBox(
                height: 20,
              ),
              //login
              MyButton(onTap: () => register(context), text: "Sign In"),
              SizedBox(
                height: 20,
              ),
              //register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already a member?",
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
                      "Login",
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
