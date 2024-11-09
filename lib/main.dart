import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/firebase_options.dart';
import 'package:mapapp/pages/form_page.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      FirebaseStorage.instance.useStorageEmulator("localhost", 9199);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
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

//https://zenn.dev/susatthi/articles/20220615-160504-flutter-cached-network-image-test
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      //設定画面移行
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 142, 254, 146),
              ),
              child: Text('設定'),
            ),
            //プレーパークホームページへ飛ぶ
            ListTile(
              onTap: () {
                final url =
                    Uri.parse('https://sites.google.com/view/hirakataplaypark');
                launchUrl(url);
              },
              title: const Text('プレーパークホームページ'),
            ),
            //プレーパークにいる生き物図鑑のページへ飛ぶ
            ListTile(
              onTap: () {
                final url = Uri.parse(
                    'https://sites.google.com/view/hirakataplaypark/korigaokapp/picturebook');
                launchUrl(url);
              },
              title: const Text('生き物図鑑'),
            ),
            //管理者設定画面へ
            ListTile(
              title: const Text('管理者設定'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FormPage(),
                ),
              ),
            ),
          ],
        ),
      ),
      //遊具説明ボタン (下からｺﾝﾆﾁﾊ‼)
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
                      //遊具写真
                      SizedBox(
                        height: 200.0,
                        width: double.infinity,
                        child: Image.asset('images/dyson.png'),
                      ),
                      //遊具名
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
                      //遊具説明
                      const Text(
                        '竹で作成されたブランコです。大人が使用しても壊れない丈夫な遊具です。',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 4.0,
                        ),
                      ),
                      //表示するイラストの選択画面へ
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
    );
  }
}
