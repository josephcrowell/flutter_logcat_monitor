# flutter_logcat_monitor

Flutter plugin to monitor the stream of system messages, stack traces etc using *logcat* command-line tool.

NOTE: This plugin fetches logcat logs only on Android Devices.

# how to use

1. Create a function to consume the *logcat* messages
```dart
  void _mylistenStream(dynamic value) {
    if (value is String) {
      _logBuffer.writeln(value);
    }
  }
```

2. Register your function as a listener to get logs then use it in anyway within your app.
```dart
    FlutterLogcatMonitor.addListen(_mylistenStream);
```

3. Start the logcat monitor passing the [filter parameters](#logcat_filter) as defined in *logcat* tool.
```dart
    await FlutterLogcatMonitor.startMonitor("*.*");
```

## Installation

Need permission in AndroidManifest.xml:
```xml
<uses-permission android:name="android.permission.READ_LOGS" />
```

[https://pub.dev/packages/flutter_logcat_monitor/install](https://pub.dev/packages/flutter_logcat_monitor/install)

# example

See the example code in [example](https://github.com/josephcrowell/flutter_logcat_monitor/tree/main/example) folder.

Here we use a StringBuffer to store the messages and display them on a log screen.

<p align='center'>
    <img src="https://raw.githubusercontent.com/josephcrowell/flutter_logcat_monitor/main/doc/example1.jpg" />
</p>

# under the hood

The FlutterLogcatMonitorPlugin runs event/method channel handlers in **UI-thread** and the *logcat* process monitor in a **background thread** as recomended by Google to not block the UI interface.

<p align='center'>
    <img src="https://raw.githubusercontent.com/josephcrowell/flutter_logcat_monitor/main/doc/diagram.png" />
</p>


### logcat filter options

<a name="logcat_filter"></a>

from the [Android Developers logcat documentation](https://developer.android.com/tools/logcat#filteringOutput):
```txt
filterspecs are a series of
  <tag>[:priority]

where <tag> is a log component tag (or * for all) and priority is:
  V    Verbose (default for <tag>)
  D    Debug (default for '*')
  I    Info
  W    Warn
  E    Error
  F    Fatal
  S    Silent (suppress all output)

'*' by itself means '*:D' and <tag> by itself means <tag>:V.
If no '*' filterspec or -s on command line, all filter defaults to '*:V'.
eg: '*:S <tag>' prints only <tag>, '<tag>:S' suppresses all <tag> log messages.
```

Examples:
 - `*.*` show ALL tags and priorities.
 - `flutter,FlutterLogcatMonitorPlugin,S:*` show flutter and FlutterLogcatMonitorPlugin and suppresses all others.
