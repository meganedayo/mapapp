import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../firestore/map_layout_data.dart';

part 'fetch_attraction_image.g.dart';

class Illustration {
  final String imageUrl;

  const Illustration({
    required this.imageUrl,
  });

  factory Illustration.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return Illustration(
      imageUrl: data?['imageUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'imageUrl': imageUrl,
    };
  }
}

@riverpod
Future<List<String>> fetchAttractionImages(Ref ref, String attractionId) async {
  final db = FirebaseFirestore.instance;
  final attractionImageRef = db
      .collection('maps')
      .doc(illustMapId)
      .collection('attractions')
      .doc(attractionId)
      .collection('illustrations')
      .withConverter(
          fromFirestore: Illustration.fromFirestore,
          toFirestore: (illustration, _) => illustration.toFirestore());

  final attractionImageDoc = await attractionImageRef.get();

  if (attractionImageDoc.docs.isEmpty) {
    return [];
  }

  final imageUrlList =
      attractionImageDoc.docs.map((doc) => doc.data().imageUrl).toList();

  return imageUrlList;
}

@riverpod
Future<String> fetchAttractionImage(Ref ref, String attractionId) async {
  final attractionImageUrls =
      ref.watch(fetchAttractionImagesProvider(attractionId));

  if (attractionImageUrls.value == null || attractionImageUrls.value!.isEmpty) {
    return "";
  }

  // ランダムな要素を返す
  Random random = Random();
  final randomIndex = random.nextInt(attractionImageUrls.value!.length);

  return attractionImageUrls.value![randomIndex];
}
