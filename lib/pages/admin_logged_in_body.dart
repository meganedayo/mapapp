import 'package:flutter/material.dart';

class AdminLoggedInBody extends StatelessWidget {
  const AdminLoggedInBody({super.key, required this.onSignOutPressed});

  final VoidCallback onSignOutPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("管理者としてログインしています．"),
          ElevatedButton(
            onPressed: onSignOutPressed,
            child: const Text("サインアウト"),
          ),
        ],
      ),
    );
  }
}
