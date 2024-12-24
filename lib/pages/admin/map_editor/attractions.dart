import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'attraction.dart';

part 'attractions.g.dart';

@riverpod
class Attractions extends _$Attractions {
  @override
  Map<String, Attraction> build() {
    return {};
  }

  void add({
    required String attractionId,
    required ({Alignment topLeft, Alignment bottomRight}) rectAlignments,
    required String name,
    required String description,
  }) {
    state = {
      ...state,
      attractionId: Attraction(
        attractionId: attractionId,
        rectAlignments: rectAlignments,
        name: name,
        description: description,
      ),
    };
  }

  void update({
    required String attractionId,
    ({Alignment topLeft, Alignment bottomRight})? rectAlignments,
    String? name,
    String? description,
  }) {
    state = {
      ...state,
      attractionId: state[attractionId]!.copyWith(
        rectAlignments: rectAlignments ?? state[attractionId]!.rectAlignments,
        name: name ?? state[attractionId]!.name,
        description: description ?? state[attractionId]!.description,
      ),
    };
  }
}
