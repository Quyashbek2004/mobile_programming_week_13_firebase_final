
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const AddDocumentApp());
}

class AddDocumentApp extends StatefulWidget {
  const AddDocumentApp({super.key});

  @override
  State<AddDocumentApp> createState() => _AddDocumentAppState();
}

class _AddDocumentAppState extends State<AddDocumentApp> {
  final TextEditingController _controller = TextEditingController();
  final CollectionReference messages = FirebaseFirestore.instance.collection('messages');

  Future<void> _addMessage() async {
    final String messageText = _controller.text.trim();
    if (messageText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message cannot be empty')),
      );
      return;
    }

    try {
      await messages.add({
        'text': messageText,
        'createdAt': Timestamp.now(), // Use Timestamp.now()
      });
      _controller.clear();
      print("Document added successfully! Check Firestore console.");
    } catch (e) {
      print("Error adding document: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add Document Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Add Firestore Document')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Enter Message',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _addMessage,
                icon: const Icon(Icons.send),
                label: const Text('Submit Message'),
              ),
              const SizedBox(height: 30),
              const Text(
                'After submission, verify the new document with "text" and "createdAt" fields appears in the Firebase Console.',
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.blueGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
