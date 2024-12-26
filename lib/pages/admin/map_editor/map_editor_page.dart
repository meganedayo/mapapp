import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../map_edit_step/image_file.dart';
import 'attraction_display_data_input_dialog.dart';
import 'attractions.dart';
import 'map_key.dart';

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

class MapEditorPage extends ConsumerStatefulWidget {
  final ImageFile _imageFile;

  const MapEditorPage({super.key, required ImageFile imageFile})
      : _imageFile = imageFile;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapEditorPageState();
}

class _MapEditorPageState extends ConsumerState<MapEditorPage> {
  final Map<String, Rect> _attractionRects = {};

  @override
  Widget build(BuildContext context) {
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
                onPressed: () => _onCompletePressed(context, ref),
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
                widget._imageFile.uint8list,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Center(
            child: AspectRatio(
              aspectRatio: widget._imageFile.size.aspectRatio,
              child: Stack(
                children: [
                  ...attractions.entries.map(
                    (entry) {
                      final attraction = entry.value;
                      if (!_attractionRects.containsKey(entry.key)) {
                        debugPrint("koko");
                      }
                      final rect = _attractionRects[entry.key];

                      return TransformableBox(
                        rect: rect,
                        onChanged: (result, event) {
                          setState(() {
                            _attractionRects[entry.key] = result.rect;
                          });

                          ref.read(attractionsProvider.notifier).update(
                                attractionId: entry.key,
                                rectAlignments: _rectTo2Alignment(
                                  result.rect,
                                  mapKey.currentContext!.size!,
                                ),
                              );
                        },
                        allowContentFlipping: false,
                        allowFlippingWhileResizing: false,
                        enabledHandles: HandlePosition.corners.toSet(),
                        visibleHandles: HandlePosition.corners.toSet(),
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

  void _onCompletePressed(BuildContext context, WidgetRef ref) {
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
                // ダイアログを閉じる
                Navigator.pop(context);

                final attractions = ref.read(attractionsProvider);

                // MapEditorPageを閉じる
                Navigator.pop(context, attractions);
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

    final rectAlignments = _rectTo2Alignment(rect, mapSize);

    // 新規アトラクションのデータを更新
    ref.read(attractionsProvider.notifier).add(
          attractionId: attractionId,
          rectAlignments: rectAlignments,
          name: attractionDetails.name,
          description: attractionDetails.description,
        );

    setState(() {
      _attractionRects[attractionId] = rect;
    });
  }

  Alignment _calcAlignment(Offset tapped, Size size) {
    return Alignment(
      (tapped.dx / (size.width)) * 2 - 1,
      (tapped.dy / (size.height)) * 2 - 1,
    );
  }

  /*
  alignmentX = (offsetX - width/2)/(width/2)
  alignmentY = (offsetY - height/2)/(height/2)
 */
  ({Alignment topLeft, Alignment bottomRight}) _rectTo2Alignment(
    Rect rect,
    Size size,
  ) {
    final topLeft = rect.topLeft;
    final topLeftAlignX = (topLeft.dx - size.width / 2) / (size.width / 2);
    final topLeftAlignY = (topLeft.dy - size.height / 2) / (size.height / 2);

    final bottomRight = rect.bottomRight;
    final bottomRightAlignX =
        (bottomRight.dx - size.width / 2) / (size.width / 2);
    final bottomRightAlignY =
        (bottomRight.dy - size.height / 2) / (size.height / 2);

    return (
      topLeft: Alignment(topLeftAlignX, topLeftAlignY),
      bottomRight: Alignment(bottomRightAlignX, bottomRightAlignY),
    );
  }

  /* 
  offsetX = alignmentX * width/2 + width/2
  offsetY = alignmentY * height/2 + height/2
   */
  Rect _twoAlignmentToRect({
    required Alignment topLeftAlign,
    required Alignment bottomRightAlign,
    required Size mapSize,
  }) {
    final topLeftOffset = Offset(
      topLeftAlign.x * mapSize.width / 2 + mapSize.width / 2,
      topLeftAlign.y * mapSize.height / 2 + mapSize.height / 2,
    );

    final bottomRightOffset = Offset(
      bottomRightAlign.x * mapSize.width / 2 + mapSize.width / 2,
      bottomRightAlign.y * mapSize.height / 2 + mapSize.height / 2,
    );

    return Rect.fromPoints(topLeftOffset, bottomRightOffset);
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
