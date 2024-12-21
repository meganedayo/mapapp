import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'firebase_options.dart';
import 'pages/admin/admin_page.dart';
import 'pages/home/map1.dart';
import 'pages/home/map2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAuth.instance.useAuthEmulator("localhost", 9099);

  if (kDebugMode) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      FirebaseStorage.instance.useStorageEmulator("localhost", 9199);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'プレーパーク マップ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 97, 148, 98)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'プレーパークの遊具ってどんなのがあるのー？'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//https://zenn.dev/susatthi/articles/20220615-160504-flutter-cached-network-image-test
class _MyHomePageState extends State<MyHomePage> {
  bool _isMap1 = true;

  // ガイドが表示されているかどうかを管理する
  bool _isGuideVisible = true;

  // ガイドをタッチしたときに非表示にする関数
  void _hideGuide() {
    setState(
      () {
        _isGuideVisible = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
          ),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                const SizedBox(
                  height: 65,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 137, 211, 138),
                    ),
                    child: Text('設定'),
                  ),
                ),
                ListTile(
                  onTap: () {
                    final url = Uri.parse(
                        'https://sites.google.com/view/hirakataplaypark');
                    launchUrl(url);
                  },
                  title: const Text('プレーパークホームページ'),
                ),
                ListTile(
                  onTap: () {
                    final url = Uri.parse(
                        'https://sites.google.com/view/hirakataplaypark/korigaokapp/picturebook');
                    launchUrl(url);
                  },
                  title: const Text('生き物図鑑'),
                ),
                ListTile(
                  title: const Text('管理者設定'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const AdminPage();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final isMap1 = await showModalBottomSheet<bool>(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 100,
                    width: double.infinity,
                    color: const Color.fromARGB(255, 137, 211, 138),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(Icons.palette_outlined),
                            title: const Text("イラストマップ"),
                            onTap: () {
                              Navigator.pop(context, true);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.map),
                            title: const Text("探索マップ"),
                            onTap: () {
                              Navigator.pop(context, false);
                            }, //一旦ステイ！！！！！！！！！
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );

              setState(() {
                _isMap1 = isMap1 ?? _isMap1;
              });
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          body: _isMap1 ? const Map1() : const Map2(),
        ),
        if (_isGuideVisible)
          Positioned.fill(
            child: GestureDetector(
              onTap: _hideGuide,
              child: Container(
                color: Colors.black.withOpacity(0.5), // 半透明の黒
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        color: Colors.white.withOpacity(0.8), // 半透明の白
                        Icons.pinch,
                        size: 300,
                      ),
                      const Text(
                        '拡大縮小できます',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            decoration: TextDecoration.none),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
