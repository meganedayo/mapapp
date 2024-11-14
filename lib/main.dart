import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import './map1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 142, 254, 146),
                  ),
                  child: Text('設定'),
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
                const ListTile(
                  title: Text('管理者設定'),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 500,
                    width: double.infinity,
                    color: const Color.fromARGB(255, 90, 255, 227),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 200.0,
                            width: double.infinity,
                            child: Image.asset('images/dyson.png'),
                          ),
                          const ListTile(
                            leading: Icon(Icons.flutter_dash),
                            title: Text("遊具説明"),
                          ),
                          const Text(
                            '名前：ブランコ',
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 4.0,
                            ),
                          ),
                          const Text(
                            '竹で作成されたブランコです。大人が使用しても壊れない丈夫な遊具です。',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 4.0,
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.info_outline_rounded),
                            title: const Text("イラスト切替"),
                            onTap: () {}, //一旦ステイ！！！！！！！！！
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          body: const Map1(),
        ),
        if (_isGuideVisible)
          GestureDetector(
            onTap: _hideGuide, // タッチしたらガイドを消す
            child: Positioned.fill(
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
                            fontSize: 50,
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
