import 'package:firebase_core/firebase_core.dart';
import 'package:firebasefcm/services/firebase_messaging_service.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String noticiationData = 'No data';
  String noticiationBody = 'No data';
  String noticiationTitle = 'No data';

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();

    final FirebaseMessagingService firebaseMessagingService =
        FirebaseMessagingService();

    firebaseMessagingService.setNotification();

    firebaseMessagingService.streamCtrl.stream.listen(_changeData);
    firebaseMessagingService.titleCtrl.stream.listen(_changeTitle);
    firebaseMessagingService.bodyCtrl.stream.listen(_changeBody);
  }

  _changeData(String msg) => setState(() => noticiationData = msg);
  _changeTitle(String msg) => setState(() => noticiationTitle = msg);
  _changeBody(String msg) => setState(() => noticiationBody = msg);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
