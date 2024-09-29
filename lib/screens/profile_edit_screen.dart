import 'package:flutter/material.dart';

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Edit Screen'),
      ),
      body: const Center(
        child: Text('This is the Profile Edit Screen'),
      ),
    );
  }
}
