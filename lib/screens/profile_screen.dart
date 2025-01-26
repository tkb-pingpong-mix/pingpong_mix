import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingpong_mix/viewmodels/user_viewmodel.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userViewModelProvider);

    return Scaffold(
      body: userState.when(
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text('No user data available'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Profile Picture
                CircleAvatar(
                  radius: 60,
                  backgroundImage: user.profilePicture.isNotEmpty
                      ? NetworkImage(user.profilePicture)
                      : const AssetImage(
                              'assets/images/profile_placeholder.png')
                          as ImageProvider,
                ),
                const SizedBox(height: 16),
                // Display Name
                Text(
                  user.displayName.isNotEmpty ? user.displayName : 'Guest User',
                ),
                const SizedBox(height: 8),
                // Email
                Text(
                  user.email.isNotEmpty ? user.email : 'guest@example.com',
                ),
                const SizedBox(height: 16),
                // Card with Profile Details
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileDetailRow(
                          icon: Icons.star,
                          label: 'Skill Level',
                          value: user.skillLevel.isNotEmpty
                              ? user.skillLevel
                              : 'Unknown',
                        ),
                        ProfileDetailRow(
                          icon: Icons.location_on,
                          label: 'Region',
                          value: user.region.isNotEmpty
                              ? user.region
                              : 'Not Specified',
                        ),
                        ProfileDetailRow(
                          icon: Icons.sports_tennis,
                          label: 'Play Style',
                          value: user.playStyle.isNotEmpty
                              ? user.playStyle
                              : 'Unspecified',
                        ),
                        ProfileDetailRow(
                          icon: Icons.bar_chart,
                          label: 'Win Rate',
                          value:
                              '${user.winRate > 0 ? user.winRate.toStringAsFixed(2) : '0.0'}%',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Recent Matches
                ProfileListSection(
                  title: 'Recent Matches',
                  items: user.recentMatches.isNotEmpty
                      ? user.recentMatches
                      : ['No matches played yet'],
                ),
                const SizedBox(height: 16),
                // Clans
                ProfileListSection(
                  title: 'Clans',
                  items: user.clans.isNotEmpty
                      ? user.clans
                      : ['Not part of any clans'],
                ),
                const SizedBox(height: 16),
                // Events
                ProfileListSection(
                  title: 'Events',
                  items: user.events.isNotEmpty
                      ? user.events
                      : ['No events joined'],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileDetailRow({
    required this.icon,
    required this.label,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}

class ProfileListSection extends StatelessWidget {
  final String title;
  final List<String> items;

  const ProfileListSection({
    required this.title,
    required this.items,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
            ),
            const SizedBox(height: 8),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text('- $item'),
                )),
          ],
        ),
      ),
    );
  }
}
