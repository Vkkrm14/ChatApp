import 'package:chat_app/pages/group/group_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/mytextfield.dart';

class GroupRoomPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  GroupRoomPage({required this.groupName, required this.groupId, super.key});

  @override
  State<GroupRoomPage> createState() => _GroupRoomPageState();
}

class _GroupRoomPageState extends State<GroupRoomPage> {
  FocusNode myFocusNode = FocusNode();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messagecontroller = TextEditingController();
  List<Map<String, dynamic>> chatData = [];
  Future<Map<String, dynamic>?> getCurrentUserDetails() async {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(email).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
    }
    return null;
  }

  void onSendMessage() async {
    final userDetails = await getCurrentUserDetails();
    final String name = userDetails!["Name"];
    if (_messagecontroller.text.isNotEmpty) {
      Map<String, dynamic> chatData = {
        "sendBy": name,
        "message": _messagecontroller.text,
        "type": "text",
        "email": _auth.currentUser!.email,
        "time": Timestamp.now(),
      };
      // print(name);
      // print(chatData["sendBy"]);
      // print(chatData["email"]);
      _messagecontroller.clear();

      await _firestore
          .collection('groups')
          .doc(widget.groupId)
          .collection('chats')
          .add(chatData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 50.0),
            child: Text(
              "${widget.groupName.toString()}",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => GroupInfo(
                        groupName: widget.groupName,
                        groupId: widget.groupId,
                      ),
                    ),
                  ),
              icon: Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: [
          //display all messages
          Expanded(
            child: _buildMessageList(),
          ),
          //input field
          _buildUserInput(context)
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String current = _auth.currentUser!.email.toString();

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection("groups")
          .doc(widget.groupId.toString())
          .collection("chats")
          .orderBy("time")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              var data =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              bool isCurrentUser = current == data["email"];
              Timestamp now = data['time'];
              DateTime dateTime =now.toDate();
              if (data["type"] == "notify") {
                final Size size = MediaQuery.of(context).size;
                return Container(
                  width: size.width,
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Column(
                      children: [

                        Text(
                          data['message'],
                          style: TextStyle(
                              fontSize: 13,

                              color:
                              Theme.of(context).colorScheme.inversePrimary),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (data["type"] == "text") {
                return Column(
                  mainAxisAlignment: isCurrentUser
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  crossAxisAlignment: isCurrentUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: isCurrentUser ? Colors.green : Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(15),
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['sendBy'],
                            style: TextStyle(
                                fontSize: 15,

                                color:
                                Theme.of(context).colorScheme.inversePrimary),
                          ),
                          Text(
                            data['message'],
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color:
                                Theme.of(context).colorScheme.inversePrimary),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: isCurrentUser ? EdgeInsets.only(right: 30):EdgeInsets.only(left: 30),
                      child: Text(DateFormat.MMMEd().format(dateTime).toString(),style: TextStyle(fontSize: 12,color: Theme.of(context).colorScheme.inversePrimary),),
                    ),
                    Padding(
                      padding: isCurrentUser ? EdgeInsets.only(right: 30):EdgeInsets.only(left: 30),
                      child: Text(DateFormat.jm().format(dateTime).toString(),style: TextStyle(fontSize: 12,color: Theme.of(context).colorScheme.inversePrimary),),
                    )
                  ],
                );
              }
            },
          );
        } else {
          return Center(child: Text("No messages yet"));
        }
      },
    );
  }

  Widget _buildUserInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Row(
        children: [
          //input field
          Expanded(
              child: MyTextField(
                  focusNode: myFocusNode,
                  textcontroller: _messagecontroller,
                  text: "Type a message",
                  obscuretext: false)),
          //send button
          Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                shape: BoxShape.circle,
              ),
              margin: EdgeInsets.only(right: 10),
              child: IconButton(
                  onPressed: onSendMessage,
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Theme.of(context).colorScheme.tertiary,
                  )))
        ],
      ),
    );
  }
}
