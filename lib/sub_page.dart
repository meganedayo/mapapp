// ignore: file_names
import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('megane'),
      ),
    );
  }
}