import 'package:chat_app/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddGroupPage extends StatefulWidget {
  final List<Map<String,dynamic>> memList;
   AddGroupPage({required this.memList,super.key});

  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  final TextEditingController _name = TextEditingController();
  FirebaseFirestore _firestore =FirebaseFirestore.instance;
  FirebaseAuth _auth =FirebaseAuth.instance;
  bool isLoading =false;
  String getName(){

    for (int i = 0; i < widget.memList.length; i++) {

      if(widget.memList[i]["isAdmin"]==true){
       return widget.memList[i]["name"].toString();
      }
    }
    return " ";}
  void creategroup() async {
    setState(() {
      isLoading = true;
    });
    var uuid = Uuid();
    String groupId = uuid.v4();

    try {
      await _firestore.collection("groups").doc(groupId).set({
        "members": widget.memList,
        "id": groupId,
      });

      for (int i = 0; i < widget.memList.length; i++) {
        String email = widget.memList[i]["email"];
        await _firestore.collection("users").doc(email).collection("groups").doc(groupId).set({
          "name": _name.text,
          "id": groupId,
        });

      }
      final String name = getName();
      await _firestore.collection("groups").doc(groupId).collection("chats").add({
        "message": "${name} Created this group",
        "type":"notify",
        "time": Timestamp.now(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Group created Successfully")),
      );
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => HomePage()),
              (route) => false
      );
    } catch (e) {
      print("Error creating group: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
              "Add Group",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body:
      isLoading ? Center(child: Container(child: CircularProgressIndicator(),)):
      Column(
        children: [
          SizedBox(height: 100,),
          Container(
          height: size.height / 14,
          width: size.width,
          alignment: Alignment.center,
          child: Container(
            height: size.height / 14,
            width: size.width / 1.15,
            child: TextField(
              controller: _name,
              decoration: InputDecoration(
                hintText: "Create Group",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
          SizedBox(
            height: size.height / 50,
          ),
          ElevatedButton(
            onPressed: creategroup,
            child: Text("Create Group"),
          ),],
      ),
    );
  }
}
