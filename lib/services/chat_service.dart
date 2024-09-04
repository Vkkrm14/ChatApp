import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        timestamp: timestamp
    );

    //create chat room ID for the two users
    List<String> ids=[currentUseremail,recieverEmail];
    ids.sort();//sort the ids(this ensures chat room id is same for the two people
    String chatroomID=ids.join('_');
    
    //add new message to database
    _firestore.collection("chat_rooms").doc(chatroomID).collection("messages").add(newmesssage.toMap());

  }

  //get messages
 Stream<QuerySnapshot> getMessages(String UserID,otherUserID) {
    List<String> ids=[UserID,otherUserID];
    ids.sort();
    String chatroomID=ids.join("_");
    return _firestore.collection("chat_rooms").doc(chatroomID).collection("messages").orderBy("timestamp",descending: false).snapshots();

}


}