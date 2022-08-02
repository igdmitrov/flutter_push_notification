import 'package:chat_app/message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;
final messaging = FirebaseMessaging.instance;

class AppService extends ChangeNotifier {
  final _password = 'PfNNpwyL6infYBz';

  Future<void> _createUser(int i) async {
    final response = await supabase.auth.signUp('test_$i@test.com', _password);

    await supabase
        .from('contact')
        .insert({'id': response.user!.id, 'username': 'User $i'}).execute();
  }

  Future<void> createUsers() async {
    await _createUser(1);
    await _createUser(2);
  }

  Future<void> signIn(int i) async {
    await supabase.auth.signIn(email: 'test_$i@test.com', password: _password);
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  Future<String> _getUserTo() async {
    final response = await supabase
        .from('contact')
        .select('id')
        .not('id', 'eq', getCurrentUserId())
        .execute();

    return response.data[0]['id'];
  }

  Stream<List<Message>> getMessages() {
    return supabase
        .from('message')
        .stream(['id'])
        .order('created_at')
        .execute()
        .map((maps) => maps
            .map((item) => Message.fromJson(item, getCurrentUserId()))
            .toList());
  }

  Future<void> saveMessage(String content) async {
    final userTo = await _getUserTo();

    final message = Message.create(
        content: content, userFrom: getCurrentUserId(), userTo: userTo);

    await supabase.from('message').insert(message.toMap()).execute();
  }

  Future<void> markAsRead(String messageId) async {
    await supabase
        .from('message')
        .update({'mark_as_read': true})
        .eq('id', messageId)
        .execute();
  }

  bool isAuthentificated() => supabase.auth.currentUser != null;

  String getCurrentUserId() =>
      isAuthentificated() ? supabase.auth.currentUser!.id : '';

  String getCurrentUserEmail() =>
      isAuthentificated() ? supabase.auth.currentUser!.email ?? '' : '';
}
