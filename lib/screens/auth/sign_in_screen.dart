import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:o2_nara/core/constants/app_constants.dart';
import 'package:o2_nara/core/theme/app_colors.dart';
import 'package:o2_nara/screens/design/design_test_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => context.go('/products'),
              child: const Text('로그인'),
            ),
            const SizedBox(height: AppConstants.defaultSpacing),
            OutlinedButton(
              onPressed: () => context.push('/sign-up'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
              ),
              child: const Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
