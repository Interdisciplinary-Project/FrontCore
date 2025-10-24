// lib/main.dart ou lib/app/escoteiro.dart
import 'package:flutter/material.dart';
import 'package:escoteiro/app/router.dart';

class Escoteiro extends StatelessWidget {
  const Escoteiro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Grupo Escoteiro Terra da Saudade",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF059A00)),
        useMaterial3: true,
        typography: Typography.material2021(),
      ),
      routerConfig: router,
    );
  }
}