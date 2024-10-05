import 'dart:convert';  // Import jsonDecode for payload decoding
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  Map<String, dynamic> payloadContent = {};  // Use Map<String, dynamic> for better typing

  @override
  Widget build(BuildContext context) {
    // Retrieve the arguments from the route
    final data = ModalRoute.of(context)?.settings.arguments;

    // Decode the data based on its type (RemoteMessage or NotificationResponse)
    if (data is RemoteMessage) {
      payloadContent = data.data;
    } else if (data is NotificationResponse) {
      payloadContent = jsonDecode(data.payload!);
    }

    // Get the first key from the payload
    String firstKey = payloadContent.keys.first;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Message"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 100,
                child: Card(
                  color: Colors.blueGrey,
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Book Name: $firstKey"),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 100,
                child: Card(
                  color: Colors.blueGrey,
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Price: ${payloadContent[firstKey]}"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
