import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2_nara/core/constants/app_constants.dart';
import 'package:o2_nara/core/theme/app_colors.dart';
import 'package:o2_nara/core/theme/app_typography.dart';
import 'package:o2_nara/providers/auth_provider.dart';
import 'package:o2_nara/utils/auth_validator.dart';
import 'package:o2_nara/screens/auth/widgets/auth_text_field.dart';
import 'package:o2_nara/screens/widgets/custom_elevated_button.dart';
import 'package:o2_nara/screens/auth/widgets/social_login_button.dart';

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
      if (mounted) context.push('/products');
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

  Future<void> _handleSocialLogin(String provider) async {
    setState(() => _isLoading = true);

    try {
      switch (provider) {
        case 'google':
          await ref.read(authProvider.notifier).signInWithGoogle();
          break;
        case 'facebook':
          await ref.read(authProvider.notifier).signInWithFacebook();
          break;
        // case 'naver':
        //   await ref.read(authProvider.notifier).signInWithNaver();
        //   break;
        case 'kakao':
          await ref.read(authProvider.notifier).signInWithKakao();
          break;
      }
      if (mounted) context.push('/products');
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
                const SizedBox(height: AppConstants.defaultSpacing),
                Container(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '소셜 계정으로 로그인',
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.textInverse,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: AppConstants.smallSpacing),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SocialLoginButton(
                            svgPath: 'assets/icons/google.svg',
                            onPressed: () => _handleSocialLogin('google'),
                          ),
                          SocialLoginButton(
                            svgPath: 'assets/icons/facebook.svg',
                            onPressed: () => _handleSocialLogin('facebook'),
                          ),
                          SocialLoginButton(
                            svgPath: 'assets/icons/naver.svg',
                            onPressed: () => _handleSocialLogin('naver'),
                          ),
                          SocialLoginButton(
                            svgPath: 'assets/icons/kakao.svg',
                            onPressed: () => _handleSocialLogin('kakao'),
                          ),
                        ],
                      ),
                    ],
                  ),
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
