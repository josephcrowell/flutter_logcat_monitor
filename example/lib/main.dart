import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_logcat_monitor/flutter_logcat_monitor.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StringBuffer _logBuffer = StringBuffer();
  int _groupValue = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    try {
      debugPrint('Attempting to add listen Stream of log.');
      FlutterLogcatMonitor.addListen(_listenStream);
    } on PlatformException {
      debugPrint('Failed to listen Stream of log.');
    }
    await FlutterLogcatMonitor.startMonitor("*.*");
  }

  void _listenStream(dynamic value) {
    if (value is String) {
      if (mounted) {
        setState(() {
          _logBuffer.writeln(value);
        });
      } else {
        _logBuffer.writeln(value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Logcat Monitor Example App'),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(4),
              child: Text("Logcat log:"),
            ),
            logBoxBuild(context),
            RadioListTile(
              title: Text("logcat filter: *.*"),
              value: 0,
              groupValue: _groupValue,
              onChanged: (int? value) async {
                setState(() {
                  _groupValue = value!;
                  _logBuffer.clear();
                });
                await FlutterLogcatMonitor.startMonitor("*.*");
              },
            ),
            RadioListTile(
              title:
                  Text("logcat filter: flutter,FlutterLogcatMonitorPlugin,S:*"),
              value: 1,
              groupValue: _groupValue,
              onChanged: (int? value) async {
                setState(() {
                  _groupValue = value!;
                  _logBuffer.clear();
                });
                await FlutterLogcatMonitor.startMonitor(
                    "flutter:*,FlutterLogcatMonitorPlugin:*,*:S");
              },
            ),
            TextButton(
              child: Text("call debugPrint on flutter"),
              onPressed: () async {
                debugPrint("called debugPrint from flutter!");
              },
              style: TextButton.styleFrom(
                  elevation: 2, backgroundColor: Colors.amber[100]),
            ),
            TextButton(
              child: Text("Clear"),
              onPressed: () async {
                clearLog();
              },
              style: TextButton.styleFrom(
                  elevation: 2, backgroundColor: Colors.amber[100]),
            ),
          ],
        ),
      ),
    );
  }

  Widget logBoxBuild(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: AlignmentDirectional.topStart,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
            color: Colors.blueAccent,
            width: 1.0,
          ),
        ),
        child: SingleChildScrollView(
          reverse: true,
          scrollDirection: Axis.vertical,
          child: Text(
            _logBuffer.toString(),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    );
  }

  void clearLog() async {
    FlutterLogcatMonitor.clearLogcat;
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      _logBuffer.clear();
      _logBuffer.writeln("log buffer cleared");
    });
  }
}
