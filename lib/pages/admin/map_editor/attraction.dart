import 'package:flutter/material.dart';

@immutable
class Attraction {
  final String attractionId;
  final String name;
  final String description;
  final Alignment alignment;
  final Size size;

  Attraction({
    required this.attractionId,
    this.name = '',
    this.description = '',
    required this.alignment,
    required this.size,
    bool isEditing = false,
  }) {
    if (!isEditing) {
      assert(name.isNotEmpty);
      assert(description.isNotEmpty);
    }
  }

  Attraction copyWith({
    String? name,
    String? description,
    Alignment? alignment,
    Size? size,
    bool? isEditing,
  }) {
    return Attraction(
      attractionId: attractionId,
      name: name ?? this.name,
      description: description ?? this.description,
      alignment: alignment ?? this.alignment,
      size: size ?? this.size,
      isEditing: isEditing ?? false,
    );
  }
}
