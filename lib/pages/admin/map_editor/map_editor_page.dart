import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../map_edit_step/image_file.dart';
import 'attraction_positions.dart';

final _mapImageKey = GlobalKey();

class MapEditorPage extends ConsumerWidget {
  final ImageFile _imageFile;

  const MapEditorPage({super.key, required ImageFile imageFile})
      : _imageFile = imageFile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final positions = ref.watch(attractionPositionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("マップ編集"),
        actions: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ElevatedButton.icon(
                onPressed: () => onCompletePressed(context),
                icon: const Icon(Icons.done),
                label: const Text("完了"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onTapDown: (details) {
                // 画像Widgetの実サイズを取得
                RenderBox mapBox = _mapImageKey.currentContext!
                    .findRenderObject() as RenderBox;
                final mapSize = Size(
                  mapBox.size.width,
                  mapBox.size.height,
                );

                // タップした位置を取得
                final ({double x, double y}) tapped =
                    (x: details.localPosition.dx, y: details.localPosition.dy);

                // 画像実サイズに対するタップした位置からAlignmentを計算
                final alignment = Alignment(
                  (tapped.x / (mapSize.width)) * 2 - 1,
                  (tapped.y / (mapSize.height)) * 2 - 1,
                );

                ref
                    .read(attractionPositionsProvider.notifier)
                    .addByAlignmentAndSize(
                      attractionId: const Uuid().v4(),
                      alignment: alignment,
                      size: Size.square(min(mapSize.width, mapSize.height) / 7),
                    );
              },
              child: Image.memory(
                key: _mapImageKey,
                _imageFile.uint8list,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Center(
            child: AspectRatio(
              aspectRatio: _imageFile.size.aspectRatio,
              child: Stack(
                children: [
                  ...positions.map(
                    (position) {
                      return Align(
                        alignment: position.alignment,
                        child: Container(
                          width: position.size.width,
                          height: position.size.height,
                          color: Colors.red.withOpacity(0.5),
                        ),
                      );
                    },
                  ),
                  ColoredBox(color: Colors.red.withOpacity(0.5)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onCompletePressed(BuildContext context) {
    // 確認ダイアログを表示
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("確認"),
          content: const Text("編集を完了しますか？"),
          actions: <Widget>[
            TextButton(
              child: const Text("キャンセル"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("保存"),
              onPressed: () {
                // 保存処理

                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
