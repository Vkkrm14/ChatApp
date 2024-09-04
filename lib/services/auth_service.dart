import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  //initialise firebase authentication
  final FirebaseAuth _auth =FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  //ger user account
  User? getUser(){
    return _auth.currentUser;
  }
  //sign in
  Future<UserCredential> signInWithEmailPassword(String email,password)async{
    try{
      UserCredential userCredential= await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    }on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }

  //sign up
  Future signUpWithEmailPassword(String email,password)async{
    try{
       UserCredential userCredential=await _auth.createUserWithEmailAndPassword(email: email, password: password);
       // Create user doc and add to firestore
       _firestore.collection("users").doc(userCredential.user!.email)
           .set({'E-mail': userCredential.user!.email});
        return userCredential;



    }on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }

  //sign out
  Future<void> signOut()async{
   return await _auth.signOut();
  }
}

