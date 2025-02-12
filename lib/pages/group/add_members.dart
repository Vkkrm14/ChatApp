import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/pages/group/Add_group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddMembersPage extends StatefulWidget {
  const AddMembersPage({super.key});

  @override
  State<AddMembersPage> createState() => _AddMembersPageState();
}

class _AddMembersPageState extends State<AddMembersPage> {
  final TextEditingController _search = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> memList = [];
  bool isLoading = false;
  Map<String, dynamic>? userMap;
  @override
  void initState(){
    super.initState();
    getCurrentuserDetails();
}
  void getCurrentuserDetails() async {
    await _firestore.collection("users").doc(_auth.currentUser!.email)
        .get().
    then((map){
      setState(() {
        memList.add({
          "name": map["Name"],
          "email":_auth.currentUser!.email,
          "uid":map["Uid"],
          "isAdmin":true,

        });
      });
    });
  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("Name", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });
  }
  void onResultTap(){
    bool ifExist=false;
    for(int i=0;i<memList.length;i++){
      if(memList[i]["uid"]==userMap!["Uid"]){
        ifExist=true;
      }
    }
    if(!ifExist) {
      setState(() {
        memList.add({
          "name": userMap!["Name"],
          "email": userMap!["E-mail"],
          "uid": userMap!["Uid"],
          "isAdmin": false,
        });
        userMap = null;
      });
    }
  }
  void onRemove(int index){
    if(memList[index]["isAdmin"]!=true) {
      setState(() {
        memList.removeAt(index);
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
            ListView.builder(
                itemCount: memList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(memList[index]["name"]),
                    subtitle: Text(memList[index]["email"]),
                    onTap: (){onRemove(index);},
                    leading: Icon(Icons.person),
                    trailing: Icon(Icons.close),
                  );
                }),
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
              onTap: onResultTap,
              leading: Icon(Icons.person),
              trailing: Icon(Icons.add),
            ) : SizedBox()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddGroupPage(memList: memList,)));
        },
        child: Icon(Icons.forward),
      ),
    );
  }
}
