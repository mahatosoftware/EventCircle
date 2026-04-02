import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String eventId;
  const ChatScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Chat')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Event: $eventId', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            const Text(
              'Chat is coming soon.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'This placeholder page is wired so templates with COMMUNICATION MODULE can navigate from the dashboard.',
            ),
          ],
        ),
      ),
    );
  }
}

