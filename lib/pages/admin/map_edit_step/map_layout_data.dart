import 'package:flutter/widgets.dart';

import '../map_editor/attraction_positions.dart';
import 'image_file.dart';
import 'map_type.dart';

/// Stepで作る予定のデータ
@immutable
class MapLayoutData {
  final String id;
  final MapType type;
  final ImageFile image;

  /// MapEditPageで作成したAttractionPositions
  final List<AttractionPosition> attractions;

  const MapLayoutData({
    required this.id,
    required this.type,
    required this.image,
    required this.attractions,
  });
}
