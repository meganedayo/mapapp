import 'package:flutter/material.dart';

class SubWidget extends StatefulWidget {
  const SubWidget({super.key});

  @override
  State<SubWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SubWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Subpage'),
      ),
      body: const Center(
        child: Text(
          'hage',
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 100,
            backgroundColor: Colors.black,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/sub');
        },
      ),
    );
  }
}
