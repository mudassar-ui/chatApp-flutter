import 'package:chatapp/widget/chats/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser as Future,
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chat')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (BuildContext ctx, AsyncSnapshot chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final chatDocs = chatSnapshot.data.docs;

              return ListView.builder(
                  reverse: true,
                  itemCount: 1,
                  itemBuilder: (ctx, index) {
                    return MessageBubble(
                      chatDocs[index]['text'],
                      chatDocs[index]['userId'] == snapshot.data.uid,
                    );
                  });
            },
          );
        });
  }
}
