import 'package:chat_app/components/mytextfield.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String recieverEmail;
  //final String recieverID;
  ChatPage({super.key, required this.recieverEmail});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //text controller
  final TextEditingController _messagecontroller = TextEditingController();

  //chat and auth services
  final ChatService _chatService = ChatService();
  final AuthService _authservice = AuthService();
  //for textfield focus
  FocusNode myFocusNode=FocusNode();

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if(myFocusNode.hasFocus){
        Future.delayed(Duration(milliseconds: 500),
                ()=>ScrollDown());
      }
    });
  }

    @override
  void dispose() {
    myFocusNode.dispose();
    _messagecontroller.dispose();
    super.dispose();
  }

  //scroll controller
  ScrollController _scrollController=ScrollController();
  void ScrollDown(){
  _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }
  //send message
  void sendMessages() async {
    if (_messagecontroller.text.isNotEmpty) {
      await _chatService.sendMessage(widget.recieverEmail, _messagecontroller.text);

      _messagecontroller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        title: Text(widget.recieverEmail,style:TextStyle(color: Theme.of(context).colorScheme.inversePrimary,
          fontWeight: FontWeight.bold,)),
        backgroundColor: Colors.transparent,
        foregroundColor:Theme.of(context).colorScheme.inversePrimary ,

        centerTitle: true,
      ),
      body:
      Column(
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
    String senderEmail = _authservice.getUser()!.email!;
    return StreamBuilder(
        stream: _chatService.getMessages(widget.recieverEmail, senderEmail),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("loading");
          }
          final datas = snapshot.data!.docs;
          return ListView.builder(
            controller: _scrollController,
              itemCount: datas.length,
              itemBuilder: (context, index) {
                final data = datas[index];
                bool isCurrentUser =
                    data['senderID'] == _authservice.getUser()!.uid;
                var alignment = isCurrentUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft;
                return Column(
                  mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end:MainAxisAlignment.start,
                  crossAxisAlignment:isCurrentUser ? CrossAxisAlignment.end:CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(color:isCurrentUser ? Colors.green:Colors.blue,
                      borderRadius: BorderRadius.circular(20),),
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                        //alignment: alignment,
                        child: Text(data['message'],style: TextStyle(fontSize: 18,color: Theme.of(context).colorScheme.inversePrimary),)),
                  ],
                );
              });
        });
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
                  onPressed: sendMessages,
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Theme.of(context).colorScheme.tertiary,
                  )))
        ],
      ),
    );
  }
}
