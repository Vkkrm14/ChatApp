import 'dart:async';

import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/authentication/login_page.dart';
import 'package:chat_app/services/auth_gate.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _auth =AuthService();
  late Timer timer;
  @override
  void initState(){
    super.initState();
    _auth.sendEmailVerificationLink();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      FirebaseAuth.instance.currentUser?.reload();
      if(FirebaseAuth.instance.currentUser!.emailVerified){
        timer.cancel();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AuthGate()));

      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(

        actions: [IconButton(onPressed:(){Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage()));}, icon: Icon(Icons.close))
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            Image(height:360,image: AssetImage("assets/images/sammy-line-man-receives-a-mail.png")),
            SizedBox(height: 10,),
            Text("Verify your email address!",style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,fontSize: 20,fontWeight: FontWeight.bold)),
            SizedBox(height: 10.0,),
            Text("Congratulations! Your Account Awaits: Verify Your Email to Start Chatting.",style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,fontSize: 16,),textAlign: TextAlign.center,),
            SizedBox(height: 20.0,),
            SizedBox(width:double.infinity ,child: ElevatedButton(onPressed:(){}, child: Text("Continue",style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,),))),

            SizedBox(height: 20.0,),
            TextButton(onPressed: ()async{_auth.sendEmailVerificationLink();}, child: Text("Resend Email",style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,),),)

          ],
        ),
      ),
    );
  }
}