import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_forbidshot/flutter_forbidshot.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isCaptured = false;
  StreamSubscription<void> subscription;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    bool isCapture = await FlutterForbidshot.iosIsCaptured;
    setState(() {
      isCaptured = isCapture;
    });
    subscription = FlutterForbidshot.iosShotChange.listen((event) {
      setState(() {
        isCaptured = !isCaptured;
      });
    });
    
  }
  
  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('flutter_borbidshot example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('IOS:isCaptured:${isCaptured}'),
              RaisedButton(
                child: Text('Android forbidshot on'),
                onPressed: () {
                  FlutterForbidshot.setAndroidForbidOn();
                },
              ),
              RaisedButton(
                child: Text('Android forbidshot off'),
                onPressed: () {
                  FlutterForbidshot.setAndroidForbidOff();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
