package com.teamcall.flutter_incoming_call

import android.app.Activity
import android.content.Context
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.Toast;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.os.CountDownTimer
import android.app.ActivityManager
import android.content.ComponentName
import android.os.Bundle
import android.content.Intent
import android.app.Service
import android.os.Build

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import android.content.Context.ACTIVITY_SERVICE
import org.json.JSONObject
import org.json.JSONArray
import org.json.JSONTokener

/** FlutterIncomingCallPlugin */
class FlutterIncomingCallPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  
  companion object {
    var activity: Activity? = null
    val eventHandler = EventStreamHandler()
  }
  
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel: MethodChannel
  private lateinit var events: EventChannel
  private var context: Context? = null

  public var STARTFOREGROUND_ACTION = "com.teamcall.flutter_incoming_call.action.startforeground"
  public var STOPFOREGROUND_ACTION = "com.teamcall.flutter_incoming_call.action.stopforeground"

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_incoming_call")
    events = EventChannel(flutterPluginBinding.binaryMessenger, "flutter_incoming_call_events")
    channel.setMethodCallHandler(this)
    events.setStreamHandler(eventHandler)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when(call.method) {
      "startService" -> {
        val intent = Intent(activity, CallService::class.java)
        intent.setAction(STARTFOREGROUND_ACTION)
        intent.putExtra("title", call.argument<String>("title"))
        intent.putExtra("text", call.argument<String>("text"))
        intent.putExtra("subText", call.argument<String>("subText"))
        intent.putExtra("ticker", call.argument<String>("ticker"))
        intent.putExtra("companyUid", call.argument<String>("companyUid"))
        activity?.startService(intent)
        result.success(null)
      }
      "stopService" -> {
        val intent = Intent(activity, CallService::class.java)
        intent.setAction(STOPFOREGROUND_ACTION)
        activity?.stopService(intent)
        result.success(null)
      }
      "setCallData" -> {
        val callData = call.argument<String>("callData")
        val pref = context!!.getSharedPreferences("prefs", 0)
        pref.edit().putString("callData", callData).apply()
        result.success(null)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    context = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
    context = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
    context = binding.activity
  }

  override fun onDetachedFromActivity() {
    activity = null
    context = null
  }


  class EventStreamHandler : EventChannel.StreamHandler {

    private var eventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, sink: EventChannel.EventSink) {
      eventSink = sink
    }

    fun send(event: String, body: Map<String, Any?>) {
      val data = mapOf(
              "event" to event,
              "body" to body
      )
      Handler(Looper.getMainLooper()).post {
        eventSink?.success(data)
      }
    }

    override fun onCancel(p0: Any?) {
      eventSink = null
    }
  }
}
