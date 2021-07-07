package com.team_call;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.annotation.TargetApi;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.content.pm.PackageManager;
import android.content.Intent;
import android.provider.Settings;

public class MainActivity extends FlutterActivity {
    public static int ACTION_MANAGE_OVERLAY_PERMISSION_REQUEST_CODE= 5469;

    @TargetApi(Build.VERSION_CODES.M)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //Ask permission
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M // M 버전(안드로이드 6.0 마시멜로우 버전) 보다 같거나 큰 API에서만 설정창 이동 가능합니다.,
                && !Settings.canDrawOverlays(this)) { //지금 창이 오버레이 설정창이 아니라면 조건 입니다.
            PermissionOverlay();
        }
    }

    @TargetApi(Build.VERSION_CODES.M) //M 버전 이상 API를 타겟으로,
    public void PermissionOverlay() {
        Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:" + getPackageName()));
        startActivityForResult(intent, ACTION_MANAGE_OVERLAY_PERMISSION_REQUEST_CODE);
    }

    @TargetApi(Build.VERSION_CODES.M)
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == ACTION_MANAGE_OVERLAY_PERMISSION_REQUEST_CODE) {
            if (Settings.canDrawOverlays(this)) {
                // You have permission
            }
        }
    }
}
