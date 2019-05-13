import 'dart:async';
import 'dart:io';

import 'package:fake_push/fake_push.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runZoned(() {
    runApp(MyApp());
  }, onError: (Object error, StackTrace stack) {
    print(error);
    print(stack);
  });

  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Push push = Push();
    push.registerApp().then((_) {
      push.startWork(enableDebug: !_isReleaseMode());
      push.areNotificationsEnabled().then((bool isEnabled) {
        if (!isEnabled) {
          push.requestNotificationsPermission();
        }
      });
    });
    return PushProvider(
      push: push,
      child: MaterialApp(
        home: Home(
          push: push,
        ),
      ),
    );
  }

  bool _isReleaseMode() {
    return bool.fromEnvironment('dart.vm.product');
  }
}

class Home extends StatefulWidget {
  Home({
    Key key,
    @required this.push,
  }) : super(key: key);

  final Push push;

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  StreamSubscription<Message> _message;
  StreamSubscription<Message> _notification;
  StreamSubscription<Message> _launchNotification;
  StreamSubscription<Message> _resumeNotification;

  @override
  void initState() {
    super.initState();
    _message = widget.push.message().listen(_handleMessage);
    _notification = widget.push.notification().listen(_handleNotification);
    _launchNotification =
        widget.push.launchNotification().listen(_handleLaunchNotification);
    _resumeNotification =
        widget.push.resumeNotification().listen(_handleResumeNotification);
  }

  @override
  void dispose() {
    if (_message != null) {
      _message.cancel();
    }
    if (_notification != null) {
      _notification.cancel();
    }
    if (_launchNotification != null) {
      _launchNotification.cancel();
    }
    if (_resumeNotification != null) {
      _resumeNotification.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fake Push Demo'),
      ),
      body: Center(
        child: GestureDetector(
          child: Text('${Platform.operatingSystem}'),
          onTap: () {},
        ),
      ),
    );
  }

  void _handleMessage(Message message) {
    print(
        'message: ${message.title} - ${message.content} - ${message.customContent}');
  }

  void _handleNotification(Message notification) {
    print(
        'notification: ${notification.title} - ${notification.content} - ${notification.customContent}');
  }

  void _handleLaunchNotification(Message notification) {
    print(
        'launchNotification: ${notification.title} - ${notification.content} - ${notification.customContent}');
  }

  void _handleResumeNotification(Message notification) {
    print(
        'resumeNotification: ${notification.title} - ${notification.content} - ${notification.customContent}');
  }
}
