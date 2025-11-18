
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const DeleteApp());
}

class DeleteApp extends StatelessWidget {
  const DeleteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delete Document Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Delete Firestore Documents')),
        body: const DeletableMessageList(),
      ),
    );
  }
}

class DeletableMessageList extends StatelessWidget {
  final CollectionReference messages = FirebaseFirestore.instance.collection('messages');

  DeletableMessageList({super.key});

  Future<void> _deleteMessage(BuildContext context, String docId) async {
    final bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    ) ?? false;

    if (!confirm) return;

    try {
      await messages.doc(docId).delete();
      print('Document $docId deleted successfully.');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text('Error loading data.'));
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

        if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No messages. Add a document using Task 3 to test deletion.'));
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            String docId = document.id;
            String messageText = data['text'] ?? 'No Text';

            return ListTile(
              title: Text(messageText),
              subtitle: Text('ID: $docId'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteMessage(context, docId),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
