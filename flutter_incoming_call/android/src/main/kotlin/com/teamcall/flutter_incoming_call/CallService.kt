package com.teamcall.flutter_incoming_call

import android.app.Service;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.IBinder;
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import androidx.core.app.NotificationCompat
import android.content.Context
import android.os.Build
import android.content.IntentFilter
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
import android.widget.ImageView;
import android.widget.RemoteViews

import com.google.firebase.firestore.FirebaseFirestore
import org.json.JSONObject
import org.json.JSONArray
import org.json.JSONTokener
import org.json.JSONException
import java.util.*
import android.app.Service.START_STICKY
import android.view.View;

class CallService : Service() {

    private var phoneReceiver = CallBroadcastReceiver()
    private var STARTFOREGROUND_ACTION = "com.teamcall.flutter_incoming_call.action.startforeground"
    private var STOPFOREGROUND_ACTION = "com.teamcall.flutter_incoming_call.action.stopforeground"
    private var SHOW_ACTION = "com.teamcall.flutter_incoming_call.action.show"

    private var isShow: Boolean = false;

    override fun onCreate() {
        super.onCreate()
        val intentFilter = IntentFilter()
        //adding some filters
        intentFilter.addAction("android.intent.action.PHONE_STATE")
        registerReceiver(phoneReceiver, intentFilter)
    }

    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        //if (intent == null) return android.app.Service.START_STICKY;
        if (STARTFOREGROUND_ACTION.equals(intent.getAction())) {
            val pm: PackageManager = getApplicationContext().getPackageManager()
            val notificationIntent: Intent =
                pm.getLaunchIntentForPackage(getApplicationContext().getPackageName())
            val pendingIntent: PendingIntent = PendingIntent.getActivity(
                this, 0,
                notificationIntent, 0
            )

            val builder: NotificationCompat.Builder
            if (Build.VERSION.SDK_INT >= 26) {
                val CHANNEL_ID = "teamcall_service_channel"
                val channel = NotificationChannel(
                    CHANNEL_ID,
                    "팀콜 상태표시줄",
                    NotificationManager.IMPORTANCE_MIN
                    //NotificationManager.IMPORTANCE_MIN
                )
                (getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager)
                    .createNotificationChannel(channel)
                builder = NotificationCompat.Builder(this, CHANNEL_ID)

                val remoteViews = RemoteViews(getPackageName(), R.layout.custom_notif)
                builder.setContent(remoteViews)
                builder.setPriority(NotificationCompat.PRIORITY_LOW)
                builder.setVisibility(Notification.VISIBILITY_SECRET)

            } else {
                builder = NotificationCompat.Builder(this)
            }

            val bundle: Bundle = intent.getExtras()

            builder.setSmallIcon(R.drawable.photo)
                .setContentTitle(bundle.getString("title"))
                .setContentText(bundle.getString("text"))
                .setSubText(bundle.getString("subText"))
                .setTicker(bundle.getString("ticker"))
                .setContentIntent(pendingIntent);

            startForeground(1, builder.build());

            val db = FirebaseFirestore.getInstance()

            val companyUid = bundle.getString("companyUid");
            db.collection("main_data").document(companyUid).collection("main_collection")
                .addSnapshotListener { snapshots, e ->
                    if (e != null) {
                        println("listen:error")
                        return@addSnapshotListener
                    }
                    println("===========================================")
                    fetchData(companyUid);
                    /*
                    for (dc in snapshots!!.documentChanges) {
                        when (dc.type) {
                            DocumentChange.Type.ADDED -> Log.d(TAG, "New city: ${dc.document.data}")
                            DocumentChange.Type.MODIFIED -> Log.d(TAG, "Modified city: ${dc.document.data}")
                            DocumentChange.Type.REMOVED -> Log.d(TAG, "Removed city: ${dc.document.data}")
                        }
                    }*/
                }
        } else if (STOPFOREGROUND_ACTION.equals(intent.getAction())) {
            stopForeground(true)
            stopSelf()
        }
        return android.app.Service.START_STICKY
    }

    override fun onDestroy() {
        unregisterReceiver(phoneReceiver);
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? {
        // Used only in case if services are bound (Bound Services).
        return null
    }

    fun showNotify(context:Context, incomingNum:String)
    {
        if (incomingNum == "") return

        val pref = context.getSharedPreferences("prefs", 0)
        var callData = pref.getString(incomingNum, "")

        //println("===========================callData" + callData)
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
        mParams.y = 680

        val layout = LayoutInflater.from(context).inflate(R.layout.custom_call_notification, null)
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

        val wm = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
        wm.addView(layout, mParams)
        isShow = true;
        var closeButton: ImageView = layout.findViewById(R.id.photo) as ImageView
        closeButton.setOnClickListener(object : View.OnClickListener {
            override fun onClick(view: View?) {
                if(isShow) wm.removeView(layout)
                isShow = false
            }
        })
/*
        Handler(Looper.getMainLooper()).postDelayed(object : Runnable {
            override fun run() {
                if(isShow) wm.removeView(layout)
                isShow = false
            }
        },60000)
 */
    }

    fun fetchData(companyUid: String)
    {
        deleteKey();
        val jsonArr = JSONArray()
        val db = FirebaseFirestore.getInstance()
        db.collection("main_data").document(companyUid).collection("main_collection")
            .get()
            .addOnSuccessListener { result ->
                val pref = getSharedPreferences("prefs", 0)
                //pref.edit().clear().commit()
                //pref.edit().clear().apply()
                println(result);
                for (document in result) {
                    val obj = JSONObject()
                    obj.put("phoneNumber",document.data.get("phoneNumber"))
                    //group, department, team, name, position
                    obj.put("group",document.data.get("group"))
                    obj.put("department",document.data.get("department"))
                    obj.put("team",document.data.get("team"))
                    obj.put("name",document.data.get("name"))
                    obj.put("position",document.data.get("position"))
                    obj.put("landlineNum",document.data.get("landlineNum"))
                    val phoneNumber:String = document.data.get("phoneNumber").toString();
                    val landlineNum:String = document.data.get("landlineNum").toString();

                    //println("obj.toString()=============================================")
                    //println(obj.toString())
                    //println(phoneNumber)
                    //println("landlineNum:::::"+landlineNum)
                    if(phoneNumber.length > 5)
                        pref.edit().putString(phoneNumber, obj.toString()).apply()
                    if(landlineNum.length > 5)
                        pref.edit().putString(landlineNum, obj.toString()).apply()

                    //jsonArr.put(obj)
                    //println("${document.id} => ${document.data}")
                }
                //showNotify(this,"01027856863");
                //println("jsonArr.toString()=============================================")
                //println(jsonArr.toString())
                //pref.edit().putString("callData", jsonArr.toString()).apply()
            }

            .addOnFailureListener { exception ->
                //Log.d(TAG, "Error getting documents: ", exception)
            }
    }

    fun deleteKey() {
        val pref = getSharedPreferences("prefs", 0)
        pref.edit().clear().commit();
        val allEntries: Map<String, *> = pref.getAll()
        for ((key, value) in allEntries) {
            println(key + ": " + value.toString())
            //pref.edit().remove("key").apply();
        }
    }

    companion object {
        private const val TAG = "ForegroundService"
        var ONGOING_NOTIFICATION_ID = 1
    }
}
