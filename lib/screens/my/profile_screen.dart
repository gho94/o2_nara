import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
      ),
      body: userAsyncValue.when(
        data: (user) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(user?.name ?? ''),
              Text(user?.email ?? ''),
              ElevatedButton(
                onPressed: () {
                  ref.read(authProvider.notifier).signOut();
                  context.go('/sign-in');
                },
                child: const Text('로그아웃'),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
      ),
    );
  }
}
