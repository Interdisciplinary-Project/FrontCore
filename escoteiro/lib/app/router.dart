// lib/app/router.dart
import 'package:go_router/go_router.dart';
import 'package:escoteiro/app/homescreen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    // Adicione outras rotas aqui
  ],
);