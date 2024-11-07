import 'package:flutter/material.dart';

class Map1 extends StatefulWidget {
  const Map1({super.key});

  @override
  State<Map1> createState() => _Map1();
}

class PinData {
  num x, y;
  final String message;
  final String imagePath;
  PinData(this.x, this.y, this.message, this.imagePath);
}

class _Map1 extends State<Map1> {
  final _transformationController = TransformationController();
  double scale = 1.0;
  double defaultWidth = 200.0;
  double defaultHeight = 200.0;
  double defFontSize = 20.0;

  double calcWidth() {
    return ((defaultWidth / scale) / 2);
  }

  double calcHeight() {
    return ((defaultHeight / scale));
  }

  void tapPin(String message) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("この場所は"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  // ピンのリストを適当に生成
  final List<PinData> pinDataList = [
    PinData(1300, 400, "竹のジャングルジム", "images/JangulJim.jpg"),
    PinData(750, 600, "ハイジブランコ", "images/Branko.jpg"),
    PinData(700, 1100, "受付", "images/CheckIn,Out.jpg"),
    PinData(575, 300, "ツリーデッキ", "images/TreeDeck.jpg"),
    PinData(150, 370, "展望デッキ", "images/deki.jpg"),
    PinData(900, 370, "工作場", "images/WorkPlace.jpg"),
    PinData(1200, 1100, "竹のシーソー", "images/si-so.jpg"),
    PinData(950, 1050, "笹のトランポリン", "images/Jamp.png"),
    PinData(370, 450, "ジップライン", "images/JipLine.jpg"),
    PinData(370, 1100, "荷物置き場", "images/house.jpg"),
  ];

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      alignment: Alignment.center,
      panAxis: PanAxis.free,
      constrained: false,
      panEnabled: true,
      scaleEnabled: true,
      boundaryMargin: const EdgeInsets.all(100.0),
      minScale: 0.1,
      maxScale: 10.0,
      onInteractionUpdate: (details) {
        setState(() {
          // データを更新
          scale = _transformationController.value.getMaxScaleOnAxis();
        });
      },
      transformationController: _transformationController,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Center(
            child: Image.asset(
              "images/basemap.jpg",
              fit: BoxFit.fitWidth,
            ),
          ),
          for (PinData pinData in pinDataList)
            // 一定の scale よりも小さくなったら非表示にする
            if (scale > 0.9)
              // Positionedで配置
              Positioned(
                // 座標を左上にすると、拡大縮小時にピンの位置がズレていくので、ピンの先端がズレないように固定
                left: pinData.x - calcWidth(),
                top: pinData.y - calcHeight(),
                // 画像の拡大率に合わせて、ピン画像のサイズを調整
                width: defaultWidth,
                height: defaultHeight,
                child: GestureDetector(
                  child: SizedBox(
                    width: calcWidth(),
                    height: calcHeight(),
                    child: FittedBox(
                      child: Image.asset(
                        pinData.imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  onTap: () {
                    tapPin(pinData.message);
                  },
                ),
              ),
        ],
      ),
    );
  }
}
