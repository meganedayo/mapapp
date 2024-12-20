import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'admin_logged_in_body.dart';
import 'admin_not_logged_in_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  User? _user;
  late StreamSubscription _sub;

  @override
  void initState() {
    super.initState();

    _sub = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

  @override
  void dispose() {
    _sub.cancel();

    super.dispose();
  }

  Future<void> _login() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }

  Future<void> _logout() async {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("管理者設定"),
      ),
      body: _user == null
          ? AdminNotLoggedInBody(onSignInPressed: _login)
          : AdminLoggedInBody(onSignOutPressed: _logout),
    );
  }
}
