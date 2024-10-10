import 'package:flutter/material.dart';

class AttractionImagePickPage extends StatelessWidget {
  const AttractionImagePickPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: SizedBox(
        width: 300,
        height: 300,
          child: FadeInImage.assetNetwork(
              placeholder: 'images/developtools_300x300_5609a4.png',
              image:
                  'https://img.skin/300x300?text=%E2%80%A6'),
        ),
      ),
    );
  }
}
