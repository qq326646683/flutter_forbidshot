import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_forbidshot/flutter_forbidshot.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_forbidshot');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterForbidshot.iosIsCaptured, '42');
  });
}
