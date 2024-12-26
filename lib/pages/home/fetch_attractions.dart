import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../firestore/map_layout_data.dart';
import '../admin/map_editor/attraction.dart';

part 'fetch_attractions.g.dart';

@riverpod
Future<List<Attraction>?> fetchAttractions(Ref ref) async {
  final db = FirebaseFirestore.instance;
  final illustMapRef = db.collection('maps').doc(illustMapId);
  final attractionsRef = illustMapRef.collection('attractions').withConverter(
        fromFirestore: Attraction.fromFirestore,
        toFirestore: (attraction, option) => attraction.toFirestore(),
      );
  final attractionsData = await attractionsRef.get();

  return attractionsData.docs.map((doc) => doc.data()).toList();
}
