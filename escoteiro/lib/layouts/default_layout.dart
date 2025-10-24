import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  
  const DefaultLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("GETS"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu),
          ),
        ],
      ),
      body: SafeArea(child: child),
    );
  }

}