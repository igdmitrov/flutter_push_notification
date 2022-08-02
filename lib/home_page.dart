import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _loginUser(AppService appService, int i) async {
    await appService.signIn(i);

    String? token = await messaging.getToken();
    if (token != null) {
      await supabase.rpc('update_fcm_key', params: {'key': token}).execute();
    }

    setState(() {});
  }

  Future<void> _signOut(AppService appService) async {
    await appService.signOut();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final appService = context.read<AppService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(appService.isAuthentificated()
            ? appService.getCurrentUserEmail()
            : 'Chat'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: appService.createUsers,
              child: const Text('Create users'),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () => _loginUser(appService, 1),
              child: const Text('Login User 1'),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () => _loginUser(appService, 2),
              child: const Text('Login User 2'),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () => _signOut(appService),
              child: const Text('Sign out'),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/chat'),
              child: const Text('Go To Chat'),
            ),
          ],
        ),
      ),
    );
  }
}
