import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class AddMembersToGroup extends StatefulWidget {
  final String groupId, name;
  final List membersList;
  const AddMembersToGroup( {required this.name,
    required this.membersList,
    required this.groupId,
    Key? key})
      : super(key: key);

  @override
  State<AddMembersToGroup> createState() => _AddMembersToGroupState();
}

class _AddMembersToGroupState extends State<AddMembersToGroup> {

  final TextEditingController _search = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  List membersList = [];
  bool isLoading = false;
  Map<String, dynamic>? userMap;
  @override
  @override
  void initState() {

    super.initState();
    membersList = widget.membersList;
  }


  void onSearch() async {
    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot result = await _firestore
          .collection('users')
          .where("Name", isEqualTo: _search.text)
          .get();

      if (result.docs.isNotEmpty) {
        setState(() {
          userMap = result.docs[0].data() as Map<String, dynamic>;
          isLoading = false;
        });
        print(userMap);
      } else {
        setState(() {
          userMap = null;
          isLoading = false;
        });
        // Optionally, show a message if no user is found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No user found with that name")),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error during search: $e");
    }
  }
  String getName(){

    for (int i = 0; i < widget.membersList.length; i++) {

      if(widget.membersList[i]["isAdmin"]==true){
        return widget.membersList[i]["name"].toString();
      }
    }
    return " ";}
  void onAddMembers() async {
    if (membersList.any((member) => member["uid"] == userMap!["Uid"].toString())) {
      // If the user is already in the group, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User is already a member of this group")),
      );
      return;
    }

    membersList.add({
      "email": userMap!["E-mail"].toString(),
      "isAdmin": false,
      "name": userMap!["Name"].toString(),
      "uid": userMap!["Uid"].toString(),
    });

    await _firestore.collection('groups').doc(widget.groupId).update({
      "members": membersList,
    });

    await _firestore
        .collection('users')
        .doc(userMap!['E-mail'])
        .collection('groups')
        .doc(widget.groupId)
        .set({"name": widget.name, "id": widget.groupId});
    final String name = getName();
    await _firestore.collection("groups").doc(widget.groupId).collection("chats").add({
      "message": "${name} added this ${userMap!["Name"].toString()}",
      "type":"notify",
      "time": Timestamp.now(),
    });

    // Optional: show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Member added successfully")),
    );
    Navigator.pop(context);
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
              "Add Members",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),

            Container(
              height: size.height / 14,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 14,
                width: size.width / 1.15,
                child: TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    hintText: "Search",
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
            isLoading ?
            Container(child: CircularProgressIndicator(),):
            ElevatedButton(
              onPressed: onSearch,
              child: Text("Search"),
            ),
            userMap !=null ? ListTile(
              title: Text(userMap?["Name"]),
              subtitle: Text(userMap?["E-mail"]),
              onTap: onAddMembers,
              leading: Icon(Icons.person),
              trailing: Icon(Icons.add),
            ) : SizedBox()
          ],
        ),
      ),

    );
  }
}
