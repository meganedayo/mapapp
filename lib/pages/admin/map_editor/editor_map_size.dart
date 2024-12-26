import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'map_key.dart';

part 'editor_map_size.g.dart';

@Riverpod(keepAlive: true)
Size? editorMapSize(Ref ref) {
  final key = ref.watch(mapKeyProvider);
  final RenderBox? renderBox =
      key.currentContext?.findRenderObject() as RenderBox?;
  return renderBox?.size;
}
