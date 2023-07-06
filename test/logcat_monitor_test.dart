import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logcat_monitor/logcat_monitor.dart';

void main() {
  const MethodChannel channel = MethodChannel('logcat_monitor/methods');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'startMonitor':
          return true;
        case 'stopMonitor':
          return true;
        case 'runLogcat':
          return 'logcat example';
        default:
          return 'not implemented';
      }
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getLogcatDump', () async {
    expect(await LogcatMonitor.getLogcatDump, 'logcat example');
  });
}
