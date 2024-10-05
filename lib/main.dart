import 'dart:convert';

import 'package:books_stashh/auth/ui/login_screen.dart';
import 'package:books_stashh/auth/ui/sign_up.dart';
import 'package:books_stashh/pages/home.dart';
import 'package:books_stashh/services/auth_service.dart';
import 'package:books_stashh/services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:books_stashh/firebase_options.dart';
import 'package:books_stashh/pages/message_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> _fireBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("Notification in background");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Firebase messaging
  await PushNotificationHelper.init();

  // Initialize local notifications
  await PushNotificationHelper.localNotificationInitialization();

  FirebaseMessaging.onBackgroundMessage(_fireBackgroundMessage);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      print("Background notification tapped!");
      navigatorKey.currentState?.pushNamed("/message", arguments: message);
    }
  });

  // For handling foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payloadContent = jsonEncode(message.data);
    print("Message found in foreground");
    if (message.notification != null) {
     String title= message.notification!.title ?? "No title";
     String body= message.notification!.body ?? "No Body";
      PushNotificationHelper.showLocalNotification(
       title: title,
        body: body,
        payload: payloadContent,
      );
    }
  });

  // For handling terminated state
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    print("From terminated state");
    Future.delayed(Duration(seconds: 3), () {
      navigatorKey.currentState?.pushNamed("/message", arguments: initialMessage);
    });
  }


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Stash',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 4, 59, 71)),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey, // Added navigator key
      routes: {
        "/": (context) => const CheckUserBookStash(),
        "/login": (context) => const LoginScreen(),
        "/signup": (context) => const SignupScreen(),
        "/home": (context) => const Home(),
        "/message": (context) => const MessageScreen(), // Fixed duplicate route
      },
    );
  }
}

class CheckUserBookStash extends StatefulWidget {
  const CheckUserBookStash({super.key});

  @override
  State<CheckUserBookStash> createState() => _CheckUserBookStashState();
}

class _CheckUserBookStashState extends State<CheckUserBookStash> {
  @override
  void initState() {
    super.initState();

    AuthServiceHelper.isUserLoggedIn().then((isLoggedIn) {
      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
