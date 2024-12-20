import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/auth.dart';
import 'admin_logged_in_body.dart';
import 'admin_not_logged_in_page.dart';

class AdminPage extends ConsumerWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("管理者設定"),
      ),
      body: user == null
          ? AdminNotLoggedInBody(onSignInPressed: () {
              ref.read(authControllerProvider.notifier).signInWithRedirect();
            })
          : AdminLoggedInBody(onSignOutPressed: () {
              ref.read(authControllerProvider.notifier).signOut();
            }),
    );
  }
}
