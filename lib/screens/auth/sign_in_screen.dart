import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2_nara/core/constants/app_constants.dart';
import 'package:o2_nara/providers/auth_provider.dart';
import 'package:o2_nara/utils/auth_validator.dart';
import 'package:o2_nara/screens/auth/widgets/auth_text_field.dart';
import 'package:o2_nara/screens/widgets/custom_elevated_button.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authProvider.notifier).signIn(
            email: _emailController.text,
            password: _passwordController.text,
          );
      if (mounted) context.go('/products');
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.translucent,
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                AuthTextField(
                  controller: _emailController,
                  type: AuthFieldType.email,
                  textInputAction: TextInputAction.next,
                  validator: AuthValidator.email,
                ),
                const SizedBox(height: AppConstants.defaultSpacing),
                AuthTextField(
                  controller: _passwordController,
                  type: AuthFieldType.password,
                  textInputAction: TextInputAction.done,
                  validator: AuthValidator.password,
                  onFieldSubmitted: (_) => _signIn(),
                ),
                const SizedBox(height: AppConstants.defaultSpacing),
                CustomElevatedButton(
                  onPressed: _signIn,
                  isLoading: _isLoading,
                  child: const Text('로그인'),
                ),
                const Spacer(),
                CustomElevatedButton(
                  onPressed: () => context.push('/sign-up'),
                  child: const Text('회원가입'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
