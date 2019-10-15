# flutter_forbidshot
[![pub package](https://img.shields.io/pub/v/flutter_forbidshot.svg)](https://pub.dev/packages/flutter_forbidshot)
A Flutter plugin to prevent capture and record screen on ios and android.

## Setup

```
flutter_forbidshot: 0.0.2
```

## Usage

#### 1. IOS API

1. Get the current recording screen state (获取到当前是否在录屏)
```
bool isCapture = await FlutterForbidshot.iosIsCaptured;
```
2. Screen recording status changes will call back (录屏状态变化会回调)
```
StreamSubscription<void> subscription = FlutterForbidshot.iosShotChange.listen((event) {});
```

#### 2. Android API

1. Turn on the forbid screen (开启禁止录屏)
```
FlutterForbidshot.setAndroidForbidOn();
```
2. Turn off the forbid screen (取消禁止录屏)
```
FlutterForbidshot.setAndroidForbidOff();
```


## Example
``` dart
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
```


---
注意⚠️

1.使用ios api可以在应用内做监听后暂停视频播放；

2.测试android api在小米手机只能拦截截屏，在三星手机可以拦截截屏，录屏后视频内容变成黑色；