// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// import 'attractions.dart';
// import 'map_size.dart';

// part 'transform_state.g.dart';

// @riverpod
// Rect rect(Ref ref, String attractionId) {
//   final attractions = ref.watch(attractionsProvider);
//   final attraction = attractions.firstWhere(
//     (a) => a.attractionId == attractionId,
//     orElse: () => throw ArgumentError('attractionId not found'),
//   );

//   final mapKey = ref.watch(mapKeyProvider);
//   final mapSize = (mapKey.currentContext!.findRenderObject() as RenderBox).size;

//   // 画像サイズに対するアラインメントからcenterを計算
//   // final imageCenter = mapSize.center(Offset.zero);
//   // final rectCenter = Offset(
//   //   imageCenter.dx + mapSize.width * attraction.alignment.x,
//   //   imageCenter.dy + mapSize.height * attraction.alignment.y,
//   // );
//   // final width = mapSize.width / 5;
//   // final height = mapSize.height / 5;

//   return Rect.fromCenter(
//     center: rectCenter,
//     width: width,
//     height: height,
//   );
// }
