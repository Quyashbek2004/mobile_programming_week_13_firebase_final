

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'firebase_options.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FirestoreSetupApp());
}

class FirestoreSetupApp extends StatelessWidget {
  const FirestoreSetupApp({super.key});


  void _checkFirestoreInstance() {
    try {
      FirebaseFirestore.instance;
      print("Firestore instance obtained successfully. Dependency is working.");
    } catch (e) {
      print("Error getting Firestore instance: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkFirestoreInstance(); 

    return MaterialApp(
      title: 'Firestore Dependency Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Firestore Setup Demo')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Firestore Dependency Check Complete.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
              
                  print("ACTION REQUIRED: Go to Firebase Console -> Firestore -> Create Collection 'messages'");
                },
                child: const Text("Verify 'messages' Collection is Created"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

