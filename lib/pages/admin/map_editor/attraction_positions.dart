import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'attraction.dart';

part 'attraction_positions.g.dart';

@riverpod
class AttractionPositions extends _$AttractionPositions {
  @override
  List<Attraction> build() {
    return [];
  }

  /// AttractionPinから新規作成
  void add(Attraction pos) {
    state = [...state, pos];
  }

  /// アラインメント，サイズから新規作成
  void addByAlignmentAndSize({
    required String attractionId,
    required Alignment alignment,
    required Size size,
  }) =>
      add(Attraction(
        attractionId: attractionId,
        alignment: alignment,
        size: size,
      ));

  /// AttractionPinを削除
  void remove(String attractionId) {
    state = state.where((pos) => pos.attractionId != attractionId).toList();
  }
}
