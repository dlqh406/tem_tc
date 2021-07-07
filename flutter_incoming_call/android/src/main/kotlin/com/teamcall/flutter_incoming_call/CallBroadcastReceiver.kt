package com.teamcall.flutter_incoming_call

import android.content.BroadcastReceiver
import android.content.Context
import android.view.View;
import android.content.Intent
import android.telephony.TelephonyManager
import android.telephony.PhoneStateListener;
import android.app.Service.START_STICKY
import android.widget.RemoteViews
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.Toast;
import android.widget.TextView;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.app.Activity
import android.view.WindowManager
import android.view.ViewGroup;
import android.graphics.PixelFormat;
import android.os.Handler
import android.os.Looper

import org.json.JSONObject
import org.json.JSONArray
import org.json.JSONTokener
import org.json.JSONException
import android.content.Context.WINDOW_SERVICE


class CallBroadcastReceiver: BroadcastReceiver() {

    private var isShown:Boolean = false;
    private lateinit var wm :WindowManager; //context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
    private lateinit var layout:View;

    companion object {


    }

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return

        val telephony: TelephonyManager =
            context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
        telephony.listen(object : PhoneStateListener() {
            override fun onCallStateChanged(state: Int, incomingNumber: String) {
                super.onCallStateChanged(state, incomingNumber)
                //println("incomingNumber : $incomingNumber")
                //println(state);
                //TelephonyManager.CALL_STATE_IDLE    -> { notify("IDLE") } // 폰이 울리거나 통화 중이 아님.
                //TelephonyManager.CALL_STATE_RINGING -> { notify("RINGING", incomingNumber) } // 폰이 울린다.
                //TelephonyManager.CALL_STATE_OFFHOOK -> { notify("OFFHOOK") } //
                if (state == TelephonyManager.CALL_STATE_RINGING) {
                    //println("CALL_STATE_RINGING")
                    showNotify(context, incomingNumber)
                    //sendPhoneEvent(EVENT_CALL_STARTED, incomingNumber)
                } else if (state == TelephonyManager.CALL_STATE_IDLE) {
                    //println("===============CALL_STATE_IDLE")
                    if(isShown) {
                        wm.removeView(layout)
                        isShown = false
                    }
                } else if (state == TelephonyManager.CALL_STATE_OFFHOOK) {
                    //println("==============CALL_STATE_OFFHOOK")
                } else {
                    //println("==============OTHER...........................")
                }
            }
        }, PhoneStateListener.LISTEN_CALL_STATE)
    }

    fun showNotify(context:Context, incomingNum:String)
    {
        if (incomingNum == "") return
        if (isShown) return

        val pref = context.getSharedPreferences("prefs", 0)
        var callData = pref.getString(incomingNum, "")

        //println("showNotify===========================callData" + callData)
        var obj :JSONObject;
        try {
            obj = JSONObject(callData)
        } catch (ex: JSONException) {
            return
        }
        //group, department, team, name, name
        var groupVal:String? = obj.getString("group");
        var departmentVal:String? = obj.getString("department");
        var teamVal:String? = obj.getString("team");
        var nameVal:String? = obj.getString("name");
        var positionVal:String? = obj.getString("position");

        var mParams: WindowManager.LayoutParams = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            600,
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
            WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN or
                    WindowManager.LayoutParams.FLAG_LAYOUT_INSET_DECOR or
                    WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                    WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                    //WindowManager.LayoutParams.FLAG_FULLSCREEN,
            PixelFormat.TRANSLUCENT)

        mParams.gravity = Gravity.CENTER or Gravity.TOP
        mParams.y = 800

        layout = LayoutInflater.from(context).inflate(R.layout.custom_call_notification, null)

        //group, department, team, name, position
        val tv_group: TextView = layout.findViewById(R.id.tv_group) as TextView
        val tv_department: TextView = layout.findViewById(R.id.tv_department) as TextView
        val tv_team: TextView = layout.findViewById(R.id.tv_team) as TextView
        val tv_name: TextView = layout.findViewById(R.id.tv_name) as TextView
        val tv_position: TextView = layout.findViewById(R.id.tv_position) as TextView

        val tv_phoneNum: TextView = layout.findViewById(R.id.tv_phoneNum) as TextView

        tv_group.setText(groupVal)
        tv_department.setText(departmentVal)
        tv_team.setText(teamVal)
        tv_name.setText(nameVal)
        tv_position.setText(positionVal)
        tv_phoneNum.setText(incomingNum)

        wm = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
        wm.addView(layout, mParams)
        isShown = true;
        var closeButton: ImageView = layout.findViewById(R.id.photo) as ImageView
        closeButton.setOnClickListener(object : View.OnClickListener {
            override fun onClick(view: View?) {
                //println(":::::click1..................................................." + isShown.toString())
                if(isShown) {
                    wm.removeView(layout)
                    isShown = false
                }
            }
        })
/*
        Handler(Looper.getMainLooper()).postDelayed(object : Runnable {
            override fun run() {
                println(":::::Handler11111...................................................")
                if(isShow) {
                    println(":::::Handler.22222..................................................")
                    wm.removeView(layout)
                }
                isShow = false
            }
        },5000)
*/
    }

    private fun sendPhoneEvent(event: String, phoneNumer: String) {
        val actionData = mapOf(
            "uuid" to "1212-1212-1212-1221",
            "name" to phoneNumer,
            "number" to phoneNumer
        )
        FlutterIncomingCallPlugin.eventHandler.send(event, actionData)
    }
/*
    private fun sendCallEvent(event: String, callData: CallData) {
        val actionData = mapOf(
                "uuid" to callData.uuid,
                "name" to callData.name,
                "number" to callData.handle,
                "avatar" to callData.avatar,
                "handleType" to callData.handleType,
                "hasVideo" to callData.hasVideo
        )
        FlutterIncomingCallPlugin.eventHandler.send(event, actionData)
    }
 */
/*
    private fun isJson(strJson:String):Boolean {
        try {
            val jsonArray = JSONTokener(strJson).nextValue() as JSONArray
            return true
        } catch (e: org.json.JSONException) {
            return false
        }
    }
*/
    fun isJson(test: String?): Boolean {
        try {
            JSONObject(test)
        } catch (ex: JSONException) {
            try {
                JSONArray(test)
            } catch (ex1: JSONException) {
                return false
            }
        }
        return true
    }
}