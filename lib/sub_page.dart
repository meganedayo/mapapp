import 'package:flutter/material.dart' show BuildContext, Placeholder, State, StatefulWidget, Widget;

class SubWidget extends StatefulWidget {
  const SubWidget({super.key});

  @override
  State<SubWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SubWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}