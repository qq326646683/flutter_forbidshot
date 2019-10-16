#import "FlutterForbidshotPlugin.h"
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

@interface FlutterForbidshotPlugin () <FlutterStreamHandler>
@end

@implementation FlutterForbidshotPlugin {
    FlutterEventSink _eventSink;
    MPVolumeView *volumeView;
    MPMusicPlayerController* musicController;
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
  }
  else if ([@"volume" isEqualToString:call.method]) {
    [self getVolume: result];
  }
  else if ([@"setVolume" isEqualToString:call.method]) {
    NSNumber *volume = call.arguments[@"volume"];
    [self setSystemVolume: volume];
    result(nil);
  }
  else {
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

- (void)getVolume:(FlutterResult)result {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    CGFloat currentVol = audioSession.outputVolume;
    NSLog(@"system volume = %.0f",currentVol);

    //去掉系统音量ui
    if (volumeView == nil) {
        volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-100, 0, 10, 10)];
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        [window addSubview:volumeView];
    }

    result(@(currentVol));
}

- (void)setSystemVolume: (NSNumber*)volume {
    if (musicController == nil) {
        musicController = [MPMusicPlayerController applicationMusicPlayer];
    }
    musicController.volume = volume.floatValue;
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
