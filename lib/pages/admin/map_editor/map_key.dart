import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_size.g.dart';

@Riverpod(keepAlive: true)
GlobalKey mapKey(Ref ref) {
  return GlobalKey();
}
