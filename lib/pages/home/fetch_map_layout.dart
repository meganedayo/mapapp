import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../firestore/map_layout_data.dart';
import '../admin/map_edit_step/map_type.dart';

part 'fetch_map_layout.g.dart';

@immutable
class MapLayout {
  final MapType type;
  final String mapImageUrl;

  const MapLayout({
    required this.type,
    required this.mapImageUrl,
  });

  factory MapLayout.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return MapLayout(
      type: MapType.values.firstWhere((type) => type.index == data?['type']),
      mapImageUrl: data?['mapImageUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'type': type.index,
      'mapImageUrl': mapImageUrl,
    };
  }
}

@riverpod
Future<MapLayout?> illustMapLayout(Ref ref) async {
  final db = FirebaseFirestore.instance;

  final illustMapRef = db
      .collection('maps')
      .withConverter(
        fromFirestore: MapLayout.fromFirestore,
        toFirestore: (mapLayout, _) => mapLayout.toFirestore(),
      )
      .doc(illustMapId);

  final illustMapDoc = await illustMapRef.get();

  if (!illustMapDoc.exists || illustMapDoc.data() == null) {
    return null;
  }

  return illustMapDoc.data();
}

@riverpod
Future<Size?> mapSize(Ref ref) async {
  final mapLayout = ref.watch(illustMapLayoutProvider);

  if (mapLayout.value == null) {
    return null;
  }

  final image = Image.network(mapLayout.value!.mapImageUrl);

  final completer = Completer<Size>();

  image.image.resolve(ImageConfiguration.empty).addListener(
    ImageStreamListener(
      (ImageInfo imageInfo, bool synchronousCall) {
        final myImage = imageInfo.image;
        final Size size = Size(
          myImage.width.toDouble(),
          myImage.height.toDouble(),
        );
        completer.complete(size);
      },
    ),
  );

  return completer.future;
}
