import 'package:flutter/material.dart';

enum AuthFieldType {
  email,
  password,
  passwordConfirm,
  name,
}

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.type,
    this.focusNode,
    this.hintText,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final AuthFieldType type;
  final FocusNode? focusNode;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscureText = true;

  IconData _getPrefixIcon() {
    switch (widget.type) {
      case AuthFieldType.email:
        return Icons.email_outlined;
      case AuthFieldType.password:
      case AuthFieldType.passwordConfirm:
        return Icons.lock_outlined;
      case AuthFieldType.name:
        return Icons.person_outlined;
    }
  }

  String _getLabel() {
    switch (widget.type) {
      case AuthFieldType.email:
        return '이메일';
      case AuthFieldType.password:
        return '비밀번호';
      case AuthFieldType.passwordConfirm:
        return '비밀번호 확인';
      case AuthFieldType.name:
        return '닉네임';
    }
  }

  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case AuthFieldType.email:
        return TextInputType.emailAddress;
      case AuthFieldType.password:
      case AuthFieldType.passwordConfirm:
      case AuthFieldType.name:
        return TextInputType.text;
    }
  }

  bool _isPassword() {
    return widget.type == AuthFieldType.password || widget.type == AuthFieldType.passwordConfirm;
  }

  String _getHint() {
    switch (widget.type) {
      case AuthFieldType.email:
        return 'example@email.com';
      case AuthFieldType.password:
        return '6자 이상 입력해주세요';
      case AuthFieldType.passwordConfirm:
        return '비밀번호를 한번 더 입력해주세요';
      case AuthFieldType.name:
        return '다른 사용자에게 보여질 이름입니다';
    }
  }

  String? _getErrorText(String? value) {
    if (value == null || value.isEmpty) {
      switch (widget.type) {
        case AuthFieldType.email:
          return '이메일을 입력해주세요';
        case AuthFieldType.password:
          return '비밀번호를 입력해주세요';
        case AuthFieldType.passwordConfirm:
          return '비밀번호를 한번 더 입력해주세요';
        case AuthFieldType.name:
          return '닉네임을 입력해주세요';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      decoration: InputDecoration(
        labelText: _getLabel(),
        hintText: _getHint(),
        hintStyle: TextStyle(color: Colors.grey),
        prefixIcon: Icon(_getPrefixIcon()),
        suffixIcon: _isPassword()
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
      obscureText: _isPassword() ? _obscureText : false,
      keyboardType: _getKeyboardType(),
      textInputAction: widget.textInputAction,
      validator: (value) {
        final errorText = _getErrorText(value);
        if (errorText != null) return errorText;
        return widget.validator?.call(value);
      },
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }
}
