import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:logcat_monitor/logcat_monitor.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  StringBuffer _logBuffer = StringBuffer();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;

    try {
      LogcatMonitor.addListen(_listenStream);
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    try {
      platformVersion = await LogcatMonitor.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void _listenStream(dynamic value) {
    if (value is String) {
      setState(() {
        _logBuffer.writeln(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Logcat Monitor example app'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Running on:  $_platformVersion\n'),
            Text("Logcat log:"),
            logboxBuild(context),
            Row(
              children: [
                TextButton(
                    child: Text(
                        "run Monitor: flutter\nand LogcatMonPlugin TAGs ONLY"),
                    onPressed: () async {
                      _logBuffer.clear();
                      await LogcatMonitor.startMonitor(
                          "flutter:*,LogcatMonPlugin:*,*:S");
                    },
                    style: TextButton.styleFrom(
                        elevation: 2, backgroundColor: Colors.amber[100])),
                TextButton(
                    child: Text("run Monitor: ALL tags"),
                    onPressed: () async {
                      _logBuffer.clear();
                      await LogcatMonitor.startMonitor("*.*");
                    },
                    style: TextButton.styleFrom(
                        elevation: 2, backgroundColor: Colors.amber[200])),
              ],
            ),
            TextButton(
                child: Text("call debugPrint"),
                onPressed: () async {
                  await debugPrint("called debugPrint from flutter!");
                },
                style: TextButton.styleFrom(
                    elevation: 2, backgroundColor: Colors.amber[100])),
          ],
        ),
      ),
    );
  }

  Widget logboxBuild(BuildContext context) {
    return Expanded(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              color: Colors.blueAccent,
              width: 1.0,
            ),
          ),
          child: Scrollbar(
            thickness: 10,
            radius: Radius.circular(20),
            child: SingleChildScrollView(
              reverse: true,
              scrollDirection: Axis.vertical,
              child: Text(
                _logBuffer.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
