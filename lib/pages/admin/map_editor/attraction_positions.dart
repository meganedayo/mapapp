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
  /// 名前と説明は空文字列になるので後で設定する必要がある
  void addByAlignmentAndSize({
    required String attractionId,
    required Alignment alignment,
    required Size size,
  }) =>
      add(Attraction(
        attractionId: attractionId,
        alignment: alignment,
        size: size,
        isEditing: true,
      ));

  void update(Attraction pos) {
    state =
        state.map((p) => p.attractionId == pos.attractionId ? pos : p).toList();
  }

  void updateByNameAndDescription(
      String attractionId, String newName, String newDescription) {
    state = state.map((a) {
      if (a.attractionId != attractionId) return a;
      return a.copyWith(
        name: newName,
        description: newDescription,
        isEditing: false,
      );
    }).toList();
  }

  /// AttractionPinを削除
  void remove(String attractionId) {
    state = state.where((pos) => pos.attractionId != attractionId).toList();
  }
}
