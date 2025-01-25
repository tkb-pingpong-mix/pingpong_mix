import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pingpong_mix/viewmodels/user_vewmodel.dart';


class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: userState == null
          ? const Center(
              child: Text('No user data available'),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: userState.profilePicture.isNotEmpty
                        ? NetworkImage(userState.profilePicture)
                        : const AssetImage(
                            'assets/images/profile_placeholder.png',
                          ) as ImageProvider,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userState.displayName.isNotEmpty
                        ? userState.displayName
                        : 'User Name',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userState.email.isNotEmpty
                        ? userState.email
                        : 'user@example.com',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/home/profile/edit');
                    },
                    child: const Text('Edit Profile'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(userViewModelProvider.notifier).resetUser();
                      context.go('/auth');
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),
    );
  }
}
