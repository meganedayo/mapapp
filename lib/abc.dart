import 'package:flutter/material.dart';

class AWidget extends StatelessWidget {
  const AWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Row(
        children: [
          
          SizedBox(width: 100, height: 100, child: Icon(Icons.add, size: 100,)),
          Icon(Icons.home),
          Icon(Icons.menu),
        ],
      ),
    );
  }
}