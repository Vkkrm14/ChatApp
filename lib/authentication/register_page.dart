// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:chat_app/components/My_button.dart';
import 'package:chat_app/components/mytextfield.dart';
import 'package:chat_app/pages/emailverify_page.dart';
import 'package:chat_app/services/auth_gate.dart';

import 'package:chat_app/services/auth_service.dart';

import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  void Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _conPasswordController = TextEditingController();
  final AuthService _auth = AuthService();
  Timer? _emailCheckTimer;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _conPasswordController.dispose();
    _emailCheckTimer?.cancel();
    super.dispose();
  }

  void _register(BuildContext context) async {
    if (_passwordController.text != _conPasswordController.text) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Passwords don't match!"),
        ),
      );
      return;
    }

    try {
      await _auth.signUpWithEmailPassword(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Ok"),
            )
          ],
          title: Text("Verify email"),
        ),
      );

      _emailCheckTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
        await AuthService.user?.reload();
        if (AuthService.isEmailVerified) {
          timer.cancel();
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AuthGate()),
            );
          }
        }
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text(e.toString()),
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
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
                //name
                MyTextField(
                  textcontroller: _nameController,
                  text: "Username",
                  obscuretext: false,
                ),
                SizedBox(
                  height: 20,
                ),
                //email
                MyTextField(
                  textcontroller: _emailController,
                  text: "E-Mail",
                  obscuretext: false,
                ),
                SizedBox(
                  height: 20,
                ),
                //pass
                MyTextField(
                  textcontroller: _passwordController,
                  text: "Password",
                  obscuretext: true,
                ),
                SizedBox(
                  height: 20,
                ),
          
                //confirm pass
                MyTextField(
                  textcontroller: _conPasswordController,
                  text: "Confirm Password",
                  obscuretext: true,
                ),
                SizedBox(
                  height: 20,
                ),
                //login
                MyButton(onTap: () => _register(context), text: "Sign Up"),
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
      ),
    );
  }
}
