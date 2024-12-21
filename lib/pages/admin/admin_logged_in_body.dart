import 'package:flutter/material.dart';
import 'package:mapapp/pages/admin/map_editor/layout_editor_page.dart';

class AdminLoggedInBody extends StatelessWidget {
  const AdminLoggedInBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: .7,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(),
            ListTile(
              title: const Text("背景画像とアトラクションの配置を変更する"),
              leading: const Icon(Icons.map_rounded),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const MapEditorPage();
                    },
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text("アトラクションの画像を新しく追加する"),
              leading: const Icon(Icons.upload_file_rounded),
              onTap: () {},
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
