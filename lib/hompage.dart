import 'package:flutter/material.dart';

import 'callpage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String userName = "";
  String roomID = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Text("Enter cred to call"),
      ),
      body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration:
                  InputDecoration(hintText: "Enter Your Name",),
                  onChanged: (value) {
                    setState(() {
                      userName = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(hintText: "Enter Room Id"),
                  onChanged: (value) {
                    setState(() {
                      roomID = value;
                    });
                  },
                ),
              ),
              TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.cyan),

                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                            CallPage(callID: roomID, userName: userName)));
                  },
                  child: Text("Join"))
            ],
          )),
    );
  }
}
