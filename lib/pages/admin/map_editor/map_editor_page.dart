import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapapp/pages/admin/map_editor/attraction_display_data_input_dialog.dart';
import 'package:uuid/uuid.dart';

import '../map_edit_step/image_file.dart';
import 'attractions.dart';

final _mapImageKey = GlobalKey();

@immutable
class AttractionDisplayData {
  final String id;
  final String name;
  final String description;

  const AttractionDisplayData({
    required this.id,
    required this.name,
    required this.description,
  });
}

class MapEditorPage extends ConsumerWidget {
  final ImageFile _imageFile;

  const MapEditorPage({super.key, required ImageFile imageFile})
      : _imageFile = imageFile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attractions = ref.watch(attractionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("マップ編集"),
        actions: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ElevatedButton.icon(
                onPressed: () => _onCompletePressed(context),
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
              onTapDown: (details) => _onMapTapped(context, ref, details),
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
                  ...attractions.map(
                    (attraction) {
                      return Align(
                        alignment: attraction.alignment,
                        child: Container(
                          width: attraction.size.width,
                          height: attraction.size.height,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(.95),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              attraction.name,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onCompletePressed(BuildContext context) {
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

  Future<void> _onMapTapped(
      BuildContext context, WidgetRef ref, TapDownDetails details) async {
    // 画像Widgetの実サイズを取得
    RenderBox mapBox =
        _mapImageKey.currentContext!.findRenderObject() as RenderBox;

    // 画像実サイズに対するタップした位置からAlignmentを計算
    final mapTapAlignment = _calcAlignment(details.localPosition, mapBox.size);

    String attractionId = const Uuid().v4();

    // attractionPositionsProviderに追加
    ref.read(attractionsProvider.notifier).addByAlignmentAndSize(
          attractionId: attractionId,
          alignment: mapTapAlignment,
          size: Size.square(mapBox.size.shortestSide / 7),
        );

    // 新規アトラクションの追加ダイアログを表示
    final attractionDetails =
        await _showAttractionDisplayDataInputDialog(context);

    if (attractionDetails == null) {
      // キャンセルされた場合は削除
      ref.read(attractionsProvider.notifier).remove(attractionId);
      return;
    }

    // 新規アトラクションのデータを更新
    ref.read(attractionsProvider.notifier).updateByNameAndDescription(
          attractionId,
          attractionDetails.name,
          attractionDetails.description,
        );
  }

  Alignment _calcAlignment(Offset tapped, Size size) {
    return Alignment(
      (tapped.dx / (size.width)) * 2 - 1,
      (tapped.dy / (size.height)) * 2 - 1,
    );
  }

  Future<AttractionDisplayData?> _showAttractionDisplayDataInputDialog(
      BuildContext context) async {
    return await showDialog<AttractionDisplayData>(
      context: context,
      builder: (_) {
        return AttractionDisplayDataInputDialog(
          onSubmitted: (String name, String description) {
            Navigator.pop(
              context,
              AttractionDisplayData(
                id: const Uuid().v4(),
                name: name,
                description: description,
              ),
            );
          },
          onCanceled: () => Navigator.pop(context),
        );
      },
    );
  }
}
