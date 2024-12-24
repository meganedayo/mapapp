import 'package:flutter/material.dart';

@immutable
class Attraction {
  final String attractionId;
  final ({Alignment topLeft, Alignment bottomRight}) rectAlignments;
  final String name;
  final String description;

  const Attraction({
    required this.attractionId,
    required this.rectAlignments,
    this.name = '',
    this.description = '',
  });

  Attraction copyWith({
    ({Alignment topLeft, Alignment bottomRight})? rectAlignments,
    String? name,
    String? description,
  }) {
    return Attraction(
      attractionId: attractionId,
      rectAlignments: rectAlignments ?? this.rectAlignments,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}
