import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; 
import 'firebase_options.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const RealtimeApp());
}

class RealtimeApp extends StatelessWidget {
  const RealtimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Real-time Snapshots Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Real-time Message Stream')),
        body: MessageListStream(),
      ),
    );
  }
}

class MessageListStream extends StatelessWidget {
  final Stream<QuerySnapshot> _messagesStream = FirebaseFirestore.instance
      .collection('messages')
      .orderBy('createdAt', descending: true)
      .snapshots();

  MessageListStream({super.key});


  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'No Date';
    final DateTime dateTime = timestamp.toDate();
    return DateFormat('MMM d, hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _messagesStream, 
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

       
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

      
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            
            return ListTile(
              title: Text(data['text'] ?? 'No Message Text'),
              subtitle: Text(_formatTimestamp(data['createdAt'] as Timestamp?)),
              leading: const Icon(Icons.message),
              trailing: Text('ID: ${document.id}'),
            );
          }).toList(),
        );
      },
    );
  }
}

