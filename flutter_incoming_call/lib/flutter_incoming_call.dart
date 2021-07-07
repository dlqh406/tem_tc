import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show describeEnum;

class FlutterIncomingCall {

  static const MethodChannel _channel = const MethodChannel('flutter_incoming_call');
  static const EventChannel _eventChannel = const EventChannel('flutter_incoming_call_events');

  static Future<void> setCallData(String data) async {
    await _channel.invokeMethod('setCallData', <String, dynamic>{
      'callData': data,
    });
  }

  static Future<String> startService({String title, String text, String subText, String ticker, String companyUid}) {
    final args = {
      'TeamCall': title,
      'TeamCall Service': text,
      'subText': subText,
      'ticker': ticker,
      'companyUid':companyUid
    };
    return _channel.invokeMethod('startService', args);
  }

  static Future<String> stopService() {
    return _channel.invokeMethod('stopService');
  }

}
