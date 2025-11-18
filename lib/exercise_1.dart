
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// Replace with your actual firebase_options file path
import 'firebase_options.dart'; 

void main() async {
  // Initialize Flutter Widgets first
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase using the generated options
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully!");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }

  runApp(const FirebaseSetupApp());
}

class FirebaseSetupApp extends StatelessWidget {
  const FirebaseSetupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Setup Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Firebase Init Demo')),
        body: Center(
          child: FutureBuilder(
            // Use Firebase.initializeApp() as a future for a clean check
            future: Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Text('Initialization Error! Check console.');
                }
                return const Text(
                  'Firebase is Initialized and Running!',
                  style: TextStyle(fontSize: 18, color: Colors.green),
                );
              }
              // Show a loading spinner while waiting
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

