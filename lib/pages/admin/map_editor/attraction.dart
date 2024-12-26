import 'package:cloud_firestore/cloud_firestore.dart';
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

  factory Attraction.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    final rectAlignmentsData = data?['rectAlignments'];

    final topLeft = rectAlignmentsData['topLeft'];
    final topLeftX = topLeft['x'];
    final topLeftY = topLeft['y'];

    final bottomRight = rectAlignmentsData['bottomRight'];
    final bottomRightX = bottomRight['x'];
    final bottomRightY = bottomRight['y'];

    return Attraction(
      attractionId: data?['attractionId'],
      rectAlignments: (
        topLeft: Alignment(topLeftX, topLeftY),
        bottomRight: Alignment(bottomRightX, bottomRightY),
      ),
      name: data?['name'],
      description: data?['description'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'attractionId': attractionId,
      'rectAlignments': {
        'topLeft': {
          'x': rectAlignments.topLeft.x,
          'y': rectAlignments.topLeft.y,
        },
        'bottomRight': {
          'x': rectAlignments.bottomRight.x,
          'y': rectAlignments.bottomRight.y,
        },
      },
      'name': name,
      'description': description,
    };
  }
}
