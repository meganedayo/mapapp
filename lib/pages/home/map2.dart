import 'package:flutter/material.dart';

class Map2 extends StatefulWidget {
  const Map2({super.key});

  @override
  State<Map2> createState() => _Map2();
}

class _Map2 extends State<Map2> {
  final _transformationController = TransformationController();
  double scale = 1.0;
  double defaultWidth = 220.0;
  double defaultHeight = 220.0;
  double defFontSize = 20.0;

  @override
  void initState() {
    super.initState();
    _transformationController.value = Matrix4.translationValues(
        -defaultWidth * 3, -defaultHeight, -defFontSize);
  }

  double calcWidth() {
    return ((defaultWidth / scale) / 3);
  }

  double calcHeight() {
    return ((defaultHeight / scale));
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: _transformationController,
      alignment: Alignment.center,
      panAxis: PanAxis.free,
      constrained: false,
      panEnabled: true,
      scaleEnabled: true,
      boundaryMargin: const EdgeInsets.all(10000.0),
      minScale: 0.1,
      maxScale: 10.0,
      onInteractionUpdate: (details) {
        setState(() {
          // データを更新
          scale = _transformationController.value.getMaxScaleOnAxis();
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Center(
            child: Image.asset(
              "images/basemap.jpg",
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      ),
    );
  }
}
