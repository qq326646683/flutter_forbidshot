package com.jinxian.flutter_forbidshot;

import android.provider.Settings;
import android.view.WindowManager;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterForbidshotPlugin */
public class FlutterForbidshotPlugin implements MethodCallHandler {
  private Registrar _registrar;
  private FlutterForbidshotPlugin(Registrar registrar){
    this._registrar = registrar;
  }
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_forbidshot");
    channel.setMethodCallHandler(new FlutterForbidshotPlugin(registrar));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("setOn")) {
      _registrar.activity().getWindow().addFlags(WindowManager.LayoutParams.FLAG_SECURE);
    } else if(call.method.equals("setOff")){
      _registrar.activity().getWindow().clearFlags(WindowManager.LayoutParams.FLAG_SECURE);
    }
  }
}
