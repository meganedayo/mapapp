import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'attraction_positions.g.dart';

@riverpod
class AttractionPositions extends _$AttractionPositions {
  @override
  List<AttractionPosition> build() {
    return [];
  }

  /// AttractionPinから新規作成
  void add(AttractionPosition pin) {
    state = [...state, pin];
  }

  /// アラインメント，サイズから新規作成
  void addByAlignmentAndSize({
    required String attractionId,
    required Alignment alignment,
    required Size size,
  }) =>
      add(AttractionPosition(
        attractionId: attractionId,
        alignment: alignment,
        size: size,
      ));
}

@immutable
class AttractionPosition {
  final String attractionId;
  final Alignment alignment;
  final Size size;

  const AttractionPosition({
    required this.attractionId,
    required this.alignment,
    required this.size,
  });
}
