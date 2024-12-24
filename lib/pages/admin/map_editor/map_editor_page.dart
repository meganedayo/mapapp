import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../map_edit_step/image_file.dart';
import 'attraction_display_data_input_dialog.dart';
import 'attractions.dart';
import 'map_size.dart';

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
    final mapKey = ref.watch(mapKeyProvider);

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
              onTapDown: (details) => _onMapTapped(
                  context, details, ref, mapKey.currentContext!.size!),
              child: Image.memory(
                key: mapKey,
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
                  ...attractions.entries.map(
                    (entry) {
                      final attraction = entry.value;

                      return TransformableBox(
                        rect: _twoAlignmentToRect(
                          topLeft: attraction.rectAlignments.topLeft,
                          bottomRight: attraction.rectAlignments.bottomRight,
                        ),
                        onChanged: (result, event) {
                          final rectAlignments = _rectTo2Alignment(result.rect);

                          ref.read(attractionsProvider.notifier).update(
                                attractionId: attraction.attractionId,
                                rectAlignments: rectAlignments,
                              );
                        },
                        contentBuilder: (context, rect, flip) {
                          return Container(
                            width: rect.width,
                            height: rect.height,
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
                          );
                        },
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

  Future<void> _onMapTapped(BuildContext context, TapDownDetails details,
      WidgetRef ref, Size mapSize) async {
    // 新規アトラクションの追加ダイアログを表示
    final attractionDetails =
        await _showAttractionDisplayDataInputDialog(context);

    if (attractionDetails == null) return;

    String attractionId = const Uuid().v4();

    Size defaultAttractionSize = Size.square(mapSize.shortestSide / 6);

    Alignment rectCenter = _calcAlignment(details.localPosition, mapSize);

    Rect rect =
        rectCenter.inscribe(defaultAttractionSize, Offset.zero & mapSize);

    final rectAlignments = _rectTo2Alignment(rect);

    // 新規アトラクションのデータを更新
    ref.read(attractionsProvider.notifier).add(
          attractionId: attractionId,
          rectAlignments: rectAlignments,
          name: attractionDetails.name,
          description: attractionDetails.description,
        );
  }

  Alignment _calcAlignment(Offset tapped, Size size) {
    return Alignment(
      (tapped.dx / (size.width)) * 2 - 1,
      (tapped.dy / (size.height)) * 2 - 1,
    );
  }

  ({Alignment topLeft, Alignment bottomRight}) _rectTo2Alignment(Rect rect) {
    return (
      topLeft: Alignment(
        rect.left / 2 + 0.5,
        rect.top / 2 + 0.5,
      ),
      bottomRight: Alignment(
        rect.right / 2 + 0.5,
        rect.bottom / 2 + 0.5,
      ),
    );
  }

  Rect _twoAlignmentToRect(
      {required Alignment topLeft, required Alignment bottomRight}) {
    return Rect.fromLTRB(
      topLeft.x * 2 - 1,
      topLeft.y * 2 - 1,
      bottomRight.x * 2 - 1,
      bottomRight.y * 2 - 1,
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
