import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const UpdateApp());
}

class UpdateApp extends StatelessWidget {
  const UpdateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Update Document Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Update Firestore Documents')),
        body: const EditableMessageList(),
      ),
    );
  }
}

class EditableMessageList extends StatelessWidget {
  final CollectionReference messages = FirebaseFirestore.instance.collection('messages');

  EditableMessageList({super.key});

  // Dialog to handle the update
  void _showEditDialog(BuildContext context, String docId, String currentText) {
    final TextEditingController controller = TextEditingController(text: currentText);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Message'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'New Message Text'),
            maxLines: 3,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                _updateMessage(docId, controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Update logic using .update()
  Future<void> _updateMessage(String docId, String newText) async {
    if (newText.trim().isEmpty) return;

    try {
      await messages.doc(docId).update({
        'text': newText,
        'updatedAt': Timestamp.now(), // Optional: track updates
      });
      print('Document $docId updated successfully.');
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text('Error loading data.'));
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            String docId = document.id;
            String messageText = data['text'] ?? 'No Text';

            return ListTile(
              title: Text(messageText),
              subtitle: Text('ID: $docId'),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _showEditDialog(context, docId, messageText),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
