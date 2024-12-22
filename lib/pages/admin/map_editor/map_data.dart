import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

enum MapType {
  illust("イラストマップ"),
  detail("探索マップ");

  const MapType(this.name);

  final String name;
}

@immutable
class MapLayoutData {
  final String id;
  final MapType type;
  final ({XFile file, Uint8List? uint8list}) image;
  final List<AttractionPosition> attractions;

  const MapLayoutData({
    required this.id,
    required this.type,
    required this.image,
    required this.attractions,
  });
}

@immutable
class AttractionPosition {
  final String attractionId;
  final Offset position;
  final Size size;
  final Size mapSize;

  AttractionPosition({
    required this.attractionId,
    required this.position,
    required this.size,
    required this.mapSize,
  })  : assert(position.dx >= 0 && position.dy >= 0),
        assert(size.width > 0 && size.height > 0),
        assert(mapSize.width > 0 && mapSize.height > 0);
}
