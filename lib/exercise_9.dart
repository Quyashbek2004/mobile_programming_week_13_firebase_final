
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; 
import 'firebase_options.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FcmTokenApp());
}

class FcmTokenApp extends StatefulWidget {
  const FcmTokenApp({super.key});

  @override
  State<FcmTokenApp> createState() => _FcmTokenAppState();
}

class _FcmTokenAppState extends State<FcmTokenApp> {
  String _fcmToken = 'Token not yet retrieved...';

  @override
  void initState() {
    super.initState();
    _setupFCM();
  }

  Future<void> _setupFCM() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    
    print('User granted permission: ${settings.authorizationStatus}');

    String? token = await FirebaseMessaging.instance.getToken();

    setState(() {
      _fcmToken = token ?? 'Failed to get token.';
    });

    if (token != null) {
      print("\n--- FCM TOKEN ---");
      print(token);
      print("-----------------\n");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FCM Token Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('FCM Token Retrieval')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Your Device FCM Token:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SelectableText(
                  _fcmToken,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.blue),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Copy this token and use it to send a test notification from the Firebase Console (Cloud Messaging -> Send your first message).',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
