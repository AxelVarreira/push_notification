import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../firebase_options.dart';

Future<void> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (message.data.containsKey('data')) {
    final data = message.data['data'];
  }

  if (message.data.containsKey(['notification'])) {
    final notification = message.data['notification'];
  }
}

class FirebaseMessagingService {
  final streamCtrl = StreamController<String>.broadcast();
  final titleCtrl = StreamController<String>.broadcast();
  final bodyCtrl = StreamController<String>.broadcast();

  setNotification() {
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

    // When app is in active state
    foregroundNotification();

    // When app is in background state
    backgroundNotification();

    // WHen app is close
    terminateNotification();
  }

  foregroundNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data.containsKey('data')) {
        streamCtrl.sink.add(message.data['data']);
      }

      if (message.data.containsKey('notification')) {
        streamCtrl.sink.add(message.data['notification']);
      }

      titleCtrl.sink.add(message.notification!.title!);
      titleCtrl.sink.add(message.notification!.body!);
    });
  }

  backgroundNotification() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data.containsKey('data')) {
        streamCtrl.sink.add(message.data['data']);
      }

      if (message.data.containsKey('notification')) {
        streamCtrl.sink.add(message.data['notification']);
      }

      titleCtrl.sink.add(message.notification!.title!);
      titleCtrl.sink.add(message.notification!.body!);
    });
  }

  terminateNotification() async {
    RemoteMessage? initializeMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initializeMessage != null) {
      if (initializeMessage.data.containsKey('data')) {
        streamCtrl.sink.add(initializeMessage.data['data']);
      }

      if (initializeMessage.data.containsKey('notification')) {
        streamCtrl.sink.add(initializeMessage.data['notification']);
      }

      titleCtrl.sink.add(initializeMessage.notification!.title!);
      titleCtrl.sink.add(initializeMessage.notification!.body!);
    }
  }
}
