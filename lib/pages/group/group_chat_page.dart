import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/pages/group/add_members.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/my_drawer.dart';
import 'Add_group.dart';
import 'Group_room_page.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  List groupList = [];
  bool isLoading = true;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    getGroupList();
  }
  void getGroupList() async {
     var email = _auth.currentUser!.email;
    await _firestore
        .collection("users")
        .doc(email)
        .collection("groups").get()
        .then((value) {
      setState(() {
        groupList = value.docs;
        isLoading = false;
      });
    });
    print(groupList);
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
              "Groups",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: //isLoading ? Center(child: Container(child: CircularProgressIndicator(),)):
      ListView.builder(
          itemCount: groupList.length,
          itemBuilder: (context, index) {
            return UserTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => GroupRoomPage(groupName:groupList[index]["name"],groupId: groupList[index]["id"],)));
                },
                icon: Icons.group,
                text: groupList[index]["name"],
                text2: " ");
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddMembersPage()));
          print(groupList.length);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
