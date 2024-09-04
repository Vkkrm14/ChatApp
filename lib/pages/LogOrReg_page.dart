import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:flutter/material.dart';
class LogOrReg extends StatefulWidget {
  LogOrReg({super.key});

  @override
  State<LogOrReg> createState() => _LogOrRegState();
}

class _LogOrRegState extends State<LogOrReg> {
  bool showLoginPage=true;

  //toggle page
  void TogglePage(){
    setState(() {
      showLoginPage=!showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginPage==true){
      return LoginPage(onTap: TogglePage,);
    }
    else{
      return RegisterPage(onTap: TogglePage,);
    }
  }
}
