#import "FlutterForbidshotPlugin.h"

@interface FlutterForbidshotPlugin () <FlutterStreamHandler>
@end

@implementation FlutterForbidshotPlugin {
    FlutterEventSink _eventSink;
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterForbidshotPlugin* instance = [[FlutterForbidshotPlugin alloc] init];
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"flutter_forbidshot"
            binaryMessenger:[registrar messenger]];
    [registrar addMethodCallDelegate:instance channel:channel];
    
    
    FlutterEventChannel* changeChannel = [FlutterEventChannel eventChannelWithName:@"flutter_forbidshot_change" binaryMessenger:[registrar messenger]];
    [changeChannel setStreamHandler: instance];


}


- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if([@"isCaptured" isEqualToString:call.method]) {
      [self initScreen: result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}


- (void)initScreen:(FlutterResult)result {
  // 监测当前设备是否处于录屏状态
    UIScreen * sc = [UIScreen mainScreen];
    if (@available(iOS 11.0, *)) {
        if (sc.isCaptured) {
            result([NSNumber numberWithBool: TRUE]);
        }
    }
    result([NSNumber numberWithBool: FALSE]);
    
}


#pragma mark FlutterStreamHandler impl
- (FlutterError*) onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
    _eventSink = eventSink;
    if (@available(iOS 11.0, *)) {
        // 检测到当前设备录屏状态发生变化
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(screenshotsChange:) name:UIScreenCapturedDidChangeNotification object:nil];
        
    }
    return nil;
}

- (FlutterError*) onCancelWithArguments:(id)arguments {
    if (@available(iOS 11.0, *)) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIScreenCapturedDidChangeNotification object:nil];
    }
    _eventSink = nil;
    return nil;
}


-(void) screenshotsChange: (BOOL)isCaptured{
    if (!_eventSink) return;
    _eventSink(@"change");
}

@end
