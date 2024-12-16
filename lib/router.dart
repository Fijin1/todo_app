import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/category_detail_screen.dart';
import 'providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoginRoute = state.uri.path == '/login';
      final isRegisterRoute = state.uri.path == '/register';

      if (!authState && !isLoginRoute && !isRegisterRoute) {
        return '/login';
      }
      if (authState && (isLoginRoute || isRegisterRoute)) {
        return '/categories';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        redirect: (_, __) => '/login',
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/categories',
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/category/:id',
        builder: (context, state) => CategoryDetailScreen(
          categoryId: state.pathParameters['id']!,
        ),
      ),
    ],
  );
});
