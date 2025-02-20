import 'package:flutter/material.dart';
import 'package:o2_nara/screens/widgets/loading_indicator.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.width = double.infinity,
    this.height = 48,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading ? const LoadingIndicator() : child,
      ),
    );
  }
}
