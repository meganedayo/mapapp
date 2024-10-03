import 'package:flutter/material.dart';

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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
                        child: Column(children: <Widget>[
                      Container(
                        height: 200.0,
                        width: double.infinity,
                        child: Image.asset('images/dyson.png'),
                      ),
                      ListTile(
                        leading: Icon(Icons.flutter_dash),
                        title: Text("遊具説明"),
                      ),
                      Text(
                        '名前：ブランコ',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 4.0,
                        ),
                      ),
                      Text(
                        '竹で作成されたブランコです。大人が使用しても壊れない丈夫な遊具です。',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 4.0,
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.info_outline_rounded),
                        title: Text("イラスト切替"),
                        onTap: () {},
                      ),
                    ])));
              });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
