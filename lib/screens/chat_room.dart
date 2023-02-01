import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatelessWidget {
  ChatRoom(this.roomId, this.userMap);
  late final String roomId;
  Map<String, dynamic>? userMap;
  final _message = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  void sendMessage() async {
    Map<String, dynamic> message = {
      "sendby": _auth.currentUser!.displayName,
      "message": _message.text,
      "time": FieldValue.serverTimestamp()
    };

    if (_message.text.isNotEmpty) {
      await _firestore
          .collection('chatroom')
          .doc(roomId)
          .collection('chats')
          .add(message);
      _message.clear();
    } else {
      print('enter message');
    }
  }

  Widget messages(Size size, Map<String, dynamic> map) {
    return Container(
      alignment: map['sendby'] == _auth.currentUser!.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      decoration: BoxDecoration(border: Border.all()),
      child: Container(
          width: size.width,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Text(map['message'])),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(userMap!['name']),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              height: size.height,
              width: size.width,
              child: StreamBuilder(
                  stream: _firestore
                      .collection('chatroom')
                      .doc(roomId)
                      .collection('chats')
                      .orderBy("time", descending: false)
                      .snapshots(),
                  builder: (contex, snapshot) {
                    if (snapshot.data != null) {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (ctx, index) {
                            Map<String, dynamic> map =
                                snapshot.data!.docs[index].data();
                            return messages(size, map);
                          });
                    }
                    return Container();
                  }),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: size.height / 8,
        // width: size.width / 0.8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: size.width * 0.8,
              child: TextField(
                controller: _message,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            IconButton(
                onPressed: () {
                  sendMessage();
                },
                icon: const Icon(Icons.send))
          ],
        ),
      ),
    );
  }
}
