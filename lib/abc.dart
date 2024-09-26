import 'package:flutter/material.dart';

class AWidget extends StatelessWidget {
  const AWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          const SizedBox(
              width: 100,
              height: 100,
              child: Icon(
                Icons.add,
                size: 100,
              )),
          const Icon(Icons.home),
          const Icon(Icons.menu),
          IconButton(
            onPressed: () {
              debugPrint("koko");
            },
            icon: const Icon(Icons.warning),
          ),
        ],
      ),
    );
  }
}
