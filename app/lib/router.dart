import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:o2_nara/screens/auth/sign_in_screen.dart';
import 'package:o2_nara/screens/auth/sign_up_screen.dart';
import 'package:o2_nara/screens/chat/chat_screen.dart';
import 'package:o2_nara/screens/my/profile_screen.dart';
import 'package:o2_nara/screens/product/product_screen.dart';
import 'package:o2_nara/screens/home_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter get router => _router;

final _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/sign-in',
  routes: [
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/sign-up',
      builder: (context, state) => const SignUpScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => HomeScreen(child: child),
      routes: [
        GoRoute(
          path: '/products',
          builder: (context, state) => const ProductScreen(),
        ),
        GoRoute(
          path: '/chat',
          builder: (context, state) => const ChatScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
