import 'package:flutter/material.dart';

class MatchingScreen extends StatelessWidget {
  const MatchingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matching Screen'),
      ),
      body: const Center(
        child: Text('This is the Matching Screen'),
      ),
    );
  }
}
