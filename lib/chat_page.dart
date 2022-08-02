import 'package:chat_app/message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_service.dart';
import 'chat_bubble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _formKey = GlobalKey<FormState>();
  final _msgController = TextEditingController();

  Future<void> _submit(AppService appService) async {
    final text = _msgController.text;

    if (text.isEmpty) {
      return;
    }

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await appService.saveMessage(text);

      _msgController.text = '';
    }
  }

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appService = context.read<AppService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: StreamBuilder<List<Message>>(
        stream: appService.getMessages(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];

                        return ChatBubble(message: message);
                      },
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _msgController,
                          decoration: InputDecoration(
                              labelText: 'Message',
                              suffixIcon: IconButton(
                                onPressed: () => _submit(appService),
                                icon: const Icon(
                                  Icons.send_rounded,
                                  color: Colors.grey,
                                ),
                              )),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40.0)
                ],
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
