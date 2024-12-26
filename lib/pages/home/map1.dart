import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapapp/pages/home/fetch_map_layout.dart';

import '../admin/map_editor/attraction.dart';
import 'fetch_attractions.dart';

class Map1 extends ConsumerStatefulWidget {
  const Map1({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _Map1State();
}

class _Map1State extends ConsumerState<Map1> {
  final _transformationController = TransformationController();
  double scale = 1.0;
  double defaultWidth = 220.0;
  double defaultHeight = 220.0;
  double defFontSize = 20.0;

  @override
  void initState() {
    super.initState();
    _transformationController.value = Matrix4.translationValues(
      -defaultWidth * 3,
      -defaultHeight,
      0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapLayout = ref.watch(illustMapLayoutProvider);
    final attractions = ref.watch(fetchAttractionsProvider);
    final mapSize = ref.watch(mapSizeProvider);

    if (mapLayout.value == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (attractions.value == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (mapSize.value == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return _buildMap(
      context,
      mapImageUrl: mapLayout.value!.mapImageUrl,
      mapSize: mapSize.value!,
      attractions: attractions.value!,
    );
  }

  Widget _buildMap(
    BuildContext context, {
    required String mapImageUrl,
    required Size mapSize,
    required List<Attraction> attractions,
  }) {
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
            child: Image.network(
              mapImageUrl,
              fit: BoxFit.contain,
            ),
          ),
          for (final attraction in attractions)
            // アトラクションのピンを描画
            _buildAttractionPin(attraction, mapSize),
        ],
      ),
    );
  }

  Widget _buildAttractionPin(Attraction attraction, Size mapSize) {
    // Alignmentをピクセル単位の座標に変換
    final topLeftOffset = Offset(
      (attraction.rectAlignments.topLeft.x + 1) / 2 * mapSize.width, // x座標
      (attraction.rectAlignments.topLeft.y + 1) / 2 * mapSize.height, // y座標
    );

    final bottomRightOffset = Offset(
      (attraction.rectAlignments.bottomRight.x + 1) / 2 * mapSize.width, // x座標
      (attraction.rectAlignments.bottomRight.y + 1) / 2 * mapSize.height, // y座標
    );

    return Positioned(
      top: topLeftOffset.dy,
      left: topLeftOffset.dx,
      child: GestureDetector(
        child: Container(
          width: bottomRightOffset.dx - topLeftOffset.dx,
          height: bottomRightOffset.dy - topLeftOffset.dy,
          color: Colors.grey,
          child: const FittedBox(
            child: Text("aaa"),
          ),
        ),
        onTap: () {
          messagePin(
            message: attraction.name,
            explan: attraction.description,
          );
        },
      ),
    );
  }

  void messagePin({
    required String message,
    required String explan,
    String realImagePath = "images/Jamp.jpg",
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 500,
          width: double.infinity,
          color: const Color.fromARGB(255, 97, 148, 98),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
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
              ],
            ),
          ),
        );
      },
    );
  }
}
