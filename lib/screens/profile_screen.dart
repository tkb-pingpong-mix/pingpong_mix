import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingpong_mix/viewmodels/user_viewmodel.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    // プロフィール画像
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: user.profilePicture.isNotEmpty
                          ? NetworkImage(user.profilePicture)
                          : const AssetImage(
                                  'assets/images/profile_placeholder.png')
                              as ImageProvider,
                    ),
                    const SizedBox(height: 16),

                    // 表示名
                    Text(
                      user.displayName.isNotEmpty
                          ? user.displayName
                          : 'Guest User',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 8),

                    // メールアドレス
                    Text(
                      user.email.isNotEmpty ? user.email : 'guest@example.com',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                          ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              '${user.followers ?? 0}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Followers',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '${user.following ?? 0}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Following',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                // 区切り線
                Divider(color: Theme.of(context).colorScheme.outlineVariant),
                const SizedBox(height: 16),

                // プロフィール詳細カード
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
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
                          icon: Icons.sports_tennis,
                          label: 'Racket',
                          value: user.racket?.isNotEmpty == true
                              ? user.racket!
                              : 'Unspecified',
                        ),
                        ProfileDetailRow(
                          icon: Icons.sports_tennis,
                          label: 'Forehand Rubber',
                          value: user.forehandRubber?.isNotEmpty == true
                              ? user.forehandRubber!
                              : 'Unspecified',
                        ),
                        ProfileDetailRow(
                          icon: Icons.sports_tennis,
                          label: 'Backhand Rubber',
                          value: user.backhandRubber?.isNotEmpty == true
                              ? user.backhandRubber!
                              : 'Unspecified',
                        ),
                        ProfileDetailRow(
                          icon: Icons.directions_run,
                          label: 'Shoes',
                          value: user.shoes?.isNotEmpty == true
                              ? user.shoes!
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
                const SizedBox(height: 24),

                // リストセクション
                ProfileListSection(
                  title: 'Recent Matches',
                  items: user.recentMatches.isNotEmpty
                      ? user.recentMatches
                      : ['No matches played yet'],
                ),
                ProfileListSection(
                  title: 'Clans',
                  items: user.clans.isNotEmpty
                      ? user.clans
                      : ['Not part of any clans'],
                ),
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
            style: TextStyle(color: Theme.of(context).colorScheme.error),
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
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
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
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    '- $item',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
