import 'package:chat_app/mark_as_read.dart';
import 'package:flutter/material.dart';

import 'message.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  const ChatBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var chatContents = [
      const SizedBox(width: 12.0),
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: message.isMine ? Colors.grey[600] : Colors.indigo[400],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            message.content,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      const SizedBox(width: 12),
      Text(message.createAt.toString(),
          style: const TextStyle(color: Colors.grey, fontSize: 12.0)),
      MarkAsRead(message: message),
      const SizedBox(width: 60),
    ];

    if (message.isMine) {
      chatContents = chatContents.reversed.toList();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment:
            message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}
