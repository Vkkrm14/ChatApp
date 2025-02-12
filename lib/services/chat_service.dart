import 'dart:io';

import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class ChatService{
  //initialise firestore
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  FirebaseAuth _auth=FirebaseAuth.instance;



  //send messages
  Future<void> sendMessage(String recieverEmail,message)async{
    //get current user info
    final String currentUserID=_auth.currentUser!.uid;
    final String currentUseremail=_auth.currentUser!.email!;
    final Timestamp timestamp=Timestamp.now();

    //create new message
    Message newmesssage =Message(
        senderId: currentUserID,
        senderEmail: currentUseremail,
        recieverEmail: recieverEmail,
        message: message,
        type: "text",
        timestamp: timestamp
    );

    //create chat room ID for the two users
    List<String> ids=[currentUseremail,recieverEmail];
    ids.sort();//sort the ids(this ensures chat room id is same for the two people
    String chatroomID=ids.join('_');

    //add new message to database
    _firestore.collection("chat_rooms").doc(chatroomID).collection("messages").add(newmesssage.toMap());

  }
  Future uploadImage(File imageFile,String recieverEmail) async {
    final String currentUserID=_auth.currentUser!.uid;
    final String currentUseremail=_auth.currentUser!.email!;
    final Timestamp timestamp=Timestamp.now();

    //create new message
    Message newmesssage =Message(
        senderId: currentUserID,
        senderEmail: currentUseremail,
        recieverEmail: recieverEmail,
        message: "",
        type: "img",
        timestamp: timestamp
    );

    //create chat room ID for the two users
    List<String> ids=[currentUseremail,recieverEmail];
    ids.sort();//sort the ids(this ensures chat room id is same for the two people
    String chatroomID=ids.join('_');

    //add new message to database
    _firestore.collection("chat_rooms").doc(chatroomID).collection("messages").add(newmesssage.toMap());
    String fileName = Uuid().v1();




    var ref =
    FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    try {
      var uploadTask = await ref.putFile(imageFile);
      String imageUrl = await uploadTask.ref.getDownloadURL();

      // Store the image URL in Firestore
      await _firestore
          .collection("chat_rooms")
          .doc(chatroomID)
          .collection("messages")
          .doc(fileName)
          .update({"message": imageUrl});

      print("Image uploaded successfully: $imageUrl");
    } catch (e) {
      print("Error uploading image: $e");

      // Clean up Firestore entry if upload failed
      await _firestore
          .collection('chat_rooms')
          .doc(chatroomID)
          .collection("messages")
          .doc(fileName)
          .delete();
    }
  }
  //get messages
  Stream<QuerySnapshot> getMessages(String UserID,otherUserID) {
    List<String> ids=[UserID,otherUserID];
    ids.sort();
    String chatroomID=ids.join("_");
    return _firestore.collection("chat_rooms").doc(chatroomID).collection("messages").orderBy("timestamp",descending: false).snapshots();

  }


}