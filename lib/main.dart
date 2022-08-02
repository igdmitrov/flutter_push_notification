import 'package:chat_app/app_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart' as provider;

import 'chat_page.dart';
import 'home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'supabase_url',
    anonKey: 'anonKey',
  );

  await Firebase.initializeApp();
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (kDebugMode) {
      print(message.toString());
    }
  });

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    if (kDebugMode) {
      print('User granted permission');
    }
    String? token = await messaging.getToken();
    if (token != null) {
      await supabase.rpc('update_fcm_key', params: {'key': token}).execute();
    }
  } else {
    if (kDebugMode) {
      print('User declined or has not accepted permission');
    }
  }

  runApp(
    provider.MultiProvider(
      providers: [
        provider.ChangeNotifierProvider<AppService>(
          create: (_) => AppService(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const HomePage(),
      routes: {
        '/chat': (_) => const ChatPage(),
      },
    );
  }
}
