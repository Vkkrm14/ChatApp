// ignore_for_file: prefer_const_constructors

import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../components/my_drawer.dart';
import '../components/user_tile.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //ChatService _chatService = ChatService();
  AuthService _authService = AuthService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 50.0),
            child: Text(
              "Home",
              style: TextStyle(color: Theme
                  .of(context)
                  .colorScheme
                  .inversePrimary,
                  fontWeight: FontWeight.bold),



            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: MyDrawer(),


      //to display the list of users (except current User)
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context,snapshot){
          if(snapshot.hasError){
            return Text("Error");
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return Text("Loading");
          }
          if(snapshot.data==null){
            return Text("null");
          }
          final users=snapshot.data!.docs;
          return ListView.builder(itemCount: users.length,
              itemBuilder: (context,index) {
                final user=users[index];
                if(user['E-mail']!=_authService.getUser()!.email){
                  return UserTile(onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>ChatPage(
                          recieverEmail:user['E-mail'] ,
                          //recieverID: user['uid'],
                        )));
                  }, text: user['E-mail']);
                }
                else{
                  return Container();
                }


              }
              );
        },
      ),

    );
  }

}
