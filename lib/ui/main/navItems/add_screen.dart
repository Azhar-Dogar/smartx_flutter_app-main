import 'package:flutter/material.dart';

class AddScreen extends StatelessWidget {
  static const String key_title = '/add_screen_title';
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text("Add Screen")],
      ),
    );
  }
}
