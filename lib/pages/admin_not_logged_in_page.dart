import 'package:flutter/material.dart';

class AdminNotLoggedInBody extends StatelessWidget {
  const AdminNotLoggedInBody({super.key, required this.onSignInPressed});

  final VoidCallback onSignInPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("画像の変更等を行うには管理者によるログインが必要です．"),
          ElevatedButton(
            onPressed: () => onSignInPressed(),
            child: const Text("サインイン"),
          ),
        ],
      ),
    );
  }
}
