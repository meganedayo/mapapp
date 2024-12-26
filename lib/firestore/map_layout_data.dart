import 'package:flutter/widgets.dart';

import '../pages/admin/map_edit_step/image_file.dart';
import '../pages/admin/map_edit_step/map_type.dart';
import '../pages/admin/map_editor/attraction.dart';

const illustMapId = 'illust';

/// Stepで作る予定のデータ, アップロード時用
@immutable
class MapLayoutData {
  final MapType type;
  final ImageFile mapImageFile;

  // 一旦固定値
  final String id = illustMapId /* = Uuid().v4()  */;

  /// MapEditPageで作成
  final Map<String, Attraction> attractions;

  const MapLayoutData({
    required this.type,
    required this.mapImageFile,
    required this.attractions,
  });
}
