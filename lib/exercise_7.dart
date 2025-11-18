import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const HttpFunctionApp());
}

class HttpFunctionApp extends StatefulWidget {
  const HttpFunctionApp({super.key});

  @override
  State<HttpFunctionApp> createState() => _HttpFunctionAppState();
}

class _HttpFunctionAppState extends State<HttpFunctionApp> {
  static const String _functionUrl = 'YOUR_CLOUD_FUNCTION_URL_HERE';
  String _responseMessage = 'Waiting for function call...';
  bool _isLoading = false;

  Future<void> _callHttpFunction() async {
    if (_functionUrl.contains('YOUR_CLOUD_FUNCTION_URL')) {
      setState(() => _responseMessage = 'Please update _functionUrl with your actual deployed function URL.');
      return;
    }

    setState(() {
      _isLoading = true;
      _responseMessage = 'Calling function...';
    });

    try {
      final response = await http.get(Uri.parse(_functionUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _responseMessage = 'Function Response (200 OK):\n${data['message']}\nTime: ${data['timestamp']}';
        });
      } else {
        setState(() {
          _responseMessage = 'Function call failed with status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _responseMessage = 'Error connecting: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTTP Function Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Call HTTP Cloud Function')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _callHttpFunction,
                  icon: _isLoading ? const SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.cloud_upload),
                  label: Text(_isLoading ? 'Calling...' : 'Call Cloud Function'),
                ),
                const SizedBox(height: 30),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _responseMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
