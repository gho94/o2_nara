import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2_nara/core/constants/app_constants.dart';
import 'package:o2_nara/providers/auth_provider.dart';
import 'package:o2_nara/screens/auth/widgets/auth_text_field.dart';
import 'package:o2_nara/screens/widgets/custom_elevated_button.dart';
import 'package:o2_nara/utils/auth_validator.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (await ref.read(authProvider.notifier).isEmailRegistered(
            email: _emailController.text,
          )) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이미 사용중인 이메일입니다')),
        );
        setState(() => _isLoading = false);
        return;
      }

      await ref.read(authProvider.notifier).signUp(
            email: _emailController.text,
            password: _passwordController.text,
            name: _nameController.text,
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
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
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
                AuthTextField(
                  controller: _emailController,
                  type: AuthFieldType.email,
                  textInputAction: TextInputAction.next,
                  validator: AuthValidator.email,
                ),
                const SizedBox(height: AppConstants.defaultSpacing),
                AuthTextField(
                  controller: _nameController,
                  type: AuthFieldType.name,
                  textInputAction: TextInputAction.next,
                  validator: AuthValidator.name,
                ),
                const SizedBox(height: AppConstants.defaultSpacing),
                AuthTextField(
                  controller: _passwordController,
                  type: AuthFieldType.password,
                  textInputAction: TextInputAction.next,
                  validator: AuthValidator.password,
                ),
                const SizedBox(height: AppConstants.defaultSpacing),
                AuthTextField(
                  controller: _passwordConfirmController,
                  type: AuthFieldType.passwordConfirm,
                  textInputAction: TextInputAction.done,
                  validator: (value) => AuthValidator.passwordConfirm(
                    value,
                    _passwordController.text,
                  ),
                  onFieldSubmitted: (_) => _signUp(),
                ),
                const Spacer(),
                CustomElevatedButton(
                  onPressed: _isLoading ? null : _signUp,
                  isLoading: _isLoading,
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
