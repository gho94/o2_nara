import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialLoginButton extends StatelessWidget {
  final String svgPath;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.svgPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: SvgPicture.asset(
        svgPath,
        width: 48,
        height: 48,
      ),
    );
  }
}
