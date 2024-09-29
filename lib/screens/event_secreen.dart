import 'package:flutter/material.dart';

class EventListScreen extends StatelessWidget {
  const EventListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event List Screen'),
      ),
      body: const Center(
        child: Text('This is the Event List Screen'),
      ),
    );
  }
}
