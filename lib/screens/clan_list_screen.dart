// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClanListScreen extends StatelessWidget {
  const ClanListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clan Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to the Clan Screen',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Text(
              'Here you can manage clan details and members.',
            ),
            ElevatedButton(
              onPressed: () {
                // Add your navigation or functionality here
                context.go('/clan-edit');
              },
              child: const Text('Go to Clan Edit'),
            ),
          ],
        ),
      ),
    );
  }
}
