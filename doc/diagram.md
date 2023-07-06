


<!-- ## Flutter Logcat Monitor -->


```plantuml
scale 500 width
rectangle "Flutter Logcat Monitor" {


package package:flutter_logcat_monitor {

	component shell {
		card logcat
	}

	component FlutterLogcatMonitor {
		card flutter_logcat_monitor.dart
	}

	component FlutterLogcatMonitorPlugin {
		card FlutterLogcatMonitorPlugin.kt
	}

	FlutterLogcatMonitorPlugin.kt <--> flutter_logcat_monitor.dart : event/method channel
	FlutterLogcatMonitorPlugin.kt <-> logcat : run\nbackground\n thread
}


package example {

	component Example {
		card main.dart
	}

	flutter_logcat_monitor.dart <--> main.dart : Stream
}

```

