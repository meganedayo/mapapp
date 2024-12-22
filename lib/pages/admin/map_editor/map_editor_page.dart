import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MapEditorPage extends StatelessWidget {
  final ({XFile? file, Uint8List? uint8list}) image;

  const MapEditorPage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("マップ編集"),
      ),
      body: Stack(
        children: [
          Center(
            child: Image.memory(
              image.uint8list!,
              fit: BoxFit.contain,
            ),
          )
        ],
      ),
    );
  }
}
