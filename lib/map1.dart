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
  final String explan;
  final String realImagePath;
  PinData(this.x, this.y, this.message, this.imagePath, this.explan,
      this.realImagePath);
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

  void messagePin(String message, String explan, String realImagePath) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 500,
              width: double.infinity,
              color: const Color.fromARGB(255, 90, 255, 227),
              child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                SizedBox(
                  height: 200.0,
                  width: double.infinity,
                  child: Image.asset(realImagePath),
                ),
                const ListTile(
                  leading: Icon(Icons.flutter_dash),
                  title: Text("遊具説明"),
                ),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 4.0,
                  ),
                ),
                Text(
                  explan,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 4.0,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: const Text("イラスト切替"),
                  onTap: () {}, //一旦ステイ！！！！！！！！！
                ),
              ])));
        });
  }

  // ピンのリストを適当に生成
  final List<PinData> pinDataList = [
    PinData(1300, 400, "竹のジャングルジム", "images/JangulJim.jpg",
        "竹で作成されたブランコです。大人が使用しても壊れない丈夫な遊具です。", "images/jungle_gym_0.jpg"),
    PinData(750, 600, "ハイジブランコ", "images/Branko.jpg",
        "竹で作られたブランコです。大人の人が遊んでも壊れないが、少し心配かもね。", "images/haiji_buran_0.jpg"),
    PinData(700, 1100, "受付", "images/CheckIn,Out.jpg", "来場したら一番初めに来てね。",
        "images/CheckIn,Out.jpg"),
    PinData(575, 300, "ツリーデッキ", "images/TreeDeck.jpg", "木の展望台だよ。眺めが最高です！",
        "images/sky_deck.jpg"),
    PinData(150, 370, "展望デッキ", "images/deki.jpg", "ツリーデッキより高いよ！",
        "images/sky_deck.jpg"),
    PinData(900, 370, "工作場", "images/WorkPlace.jpg", "竹を使って色んなものを作ろう！",
        "images/work_space_0.jpg"),
    PinData(1200, 1100, "竹のシーソー", "images/si-so.jpg", "友達と二人で遊ぼう！",
        "images/si-so-.jpg"),
    PinData(950, 1050, "笹のトランポリン", "images/Jamp.png", "思ったよりも跳ねるよ！",
        "images/jump_0.jpg"),
    PinData(370, 450, "ジップライン", "images/JipLine.jpg", "勢いよく飛び立とう！",
        "images/jip_line_0.jpg"),
    PinData(370, 1100, "荷物置き場", "images/house.jpg", "ここに荷物を置いてね。",
        "images/house.jpg"),
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
                    messagePin(
                        pinData.message, pinData.explan, pinData.realImagePath);
                  },
                ),
              ),
        ],
      ),
    );
  }
}
