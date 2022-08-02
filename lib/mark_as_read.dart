import 'package:chat_app/message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_service.dart';

class MarkAsRead extends StatelessWidget {
  final Message message;
  const MarkAsRead({Key? key, required this.message}) : super(key: key);

  final _markRead = const Icon(
    Icons.mark_chat_read,
    color: Colors.indigo,
    size: 18.0,
  );

  final _markUnRead = const Icon(
    Icons.mark_chat_unread,
    color: Colors.grey,
    size: 18.0,
  );

  Future<Widget> _getMark(BuildContext context) async {
    if (message.isMine == false) {
      if (message.markAsRead == false) {
        final appService = context.read<AppService>();
        await appService.markAsRead(message.id);
      }

      return const SizedBox.shrink();
    }

    if (message.isMine == true) {
      if (message.markAsRead == true) {
        return _markRead;
      } else {
        return _markUnRead;
      }
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getMark(context),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data as Widget;
        }

        return const SizedBox.shrink();
      },
    );
  }
}
