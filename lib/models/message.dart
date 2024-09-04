import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  final String senderId;
  final String senderEmail;
  final String recieverEmail;
  final String message;
  final Timestamp timestamp;

  Message({required this.senderId,required this.senderEmail ,required this.recieverEmail,required this.message,required this.timestamp});
  //convert to a map
  Map<String,dynamic> toMap(){
    return {
      'senderID': senderId,
      'senderEmail':senderEmail,
      'recieverID':recieverEmail,
      'message':message,
      'timestamp':timestamp

    };
  }
}