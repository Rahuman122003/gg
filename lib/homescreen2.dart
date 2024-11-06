import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gg/main.dart';
import 'package:intl/intl.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import 'hompage.dart';

class Homescreen2 extends StatefulWidget {
  const Homescreen2({super.key});

  @override
  State<Homescreen2> createState() => _Homescreen2State();
}

class _Homescreen2State extends State<Homescreen2> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User _user = FirebaseAuth.instance.currentUser!;
  bool _isEmojiVisible = false;

  // Method to send a message to Firestore
  void _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      await _firestore.collection('chats').add({
        'text': _messageController.text.trim(),
        'time': Timestamp.now(),
        'senderId': _user.uid,
        'isSender': true,
      });
      _messageController.clear();
    }
  }

  // Method to fetch messages
  Stream<QuerySnapshot> _fetchMessages() {
    return _firestore.collection('chats').orderBy('time').snapshots();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyHomePage(title: "GG")));
        }, icon: Icon(Icons.call)),
        title: const Text("Chat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _fetchMessages(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    bool isSender = doc['senderId'] == _user.uid;
                    return Align(
                      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSender ? Colors.blue[200] : Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doc['text'],
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              DateFormat('hh:mm a')
                                  .format((doc['time'] as Timestamp).toDate()),
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          _buildMessageInputField(),
          if (_isEmojiVisible) _buildEmojiPicker(),
        ],
      ),
    );
  }

  // Input field with emoji toggle and send button
  Widget _buildMessageInputField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          IconButton(
            onPressed: _toggleEmojiKeyboard,
            icon: const Icon(Icons.emoji_emotions),
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              onTap: () {
                if (_isEmojiVisible) setState(() => _isEmojiVisible = false);
              },
              decoration: InputDecoration(
                hintText: "Type a message",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            ),
          ),
          IconButton(
            onPressed: _sendMessage,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  // Toggle for the emoji keyboard
  void _toggleEmojiKeyboard() {
    setState(() {
      _isEmojiVisible = !_isEmojiVisible;
    });
  }

  // Emoji picker
  Widget _buildEmojiPicker() {
    return SizedBox(
      height: 250,
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) {
          _messageController.text += emoji.emoji;
        },
      ),
    );
  }
}
