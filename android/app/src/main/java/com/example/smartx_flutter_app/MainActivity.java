package com.example.smartx_flutter_app;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothGatt;
import io.flutter.embedding.engine.FlutterEngine;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.android.FlutterActivity;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;

import com.zhj.bluetooth.zhjbluetoothsdk.ble.BleCallbackWrapper;
import com.zhj.bluetooth.zhjbluetoothsdk.ble.bluetooth.BluetoothLe;
import com.zhj.bluetooth.zhjbluetoothsdk.ble.bluetooth.OnLeScanListener;
import com.zhj.bluetooth.zhjbluetoothsdk.ble.bluetooth.exception.ScanBleException;
import com.zhj.bluetooth.zhjbluetoothsdk.ble.bluetooth.scanner.ScanRecord;
import com.zhj.bluetooth.zhjbluetoothsdk.ble.bluetooth.scanner.ScanResult;

import java.util.List;

public class MainActivity extends FlutterActivity  implements  PermissionUtil.RequsetResult {
    private static final String CHANNEL = "samples.flutter.dev/battery";
    private PermissionUtil permissionUtil;
    /**
     * 检测权限，如果返回true,有权限 false 无权限
     * @param flutterEngine 权限
     * @return 是否有权限
     */

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        permissionUtil=new PermissionUtil();
        permissionUtil.setRequsetResult(this);

        BluetoothLe.getDefault().init(this,new  BleCallbackWrapper (){
            @Override
            public void complete(int i, Object o) {



                Log.d("DATA SEEE", String.valueOf(i));
//                Log.d("bluetooth", String.valueOf(BluetoothLe.getDefault().isBluetoothOpen()))
;

                super.complete(i, o);
            }


            @Override
            public void setSuccess() {


            }
        });
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // This method is invoked on the main thread.
                            // TODO
                            if (call.method.equals("getBatteryLevel")) {




                                int batteryLevel = getBatteryLevel();

                                if (batteryLevel != -1) {
//                                    boolean res= BluetoothLe.getDefault().isBluetoothOpen();
                                    Log.d("RESULT____","1111111");

                                    result.success(batteryLevel);
                                } else {
                                    result.error("UNAVAILABLE", "Battery level not available.", null);
                                }
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }
    private int getBatteryLevel() {
        int batteryLevel = -1;
        BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
        batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);

        return batteryLevel;
    }
    public boolean checkSelfPermission(String... permissions){
        return PermissionUtil.checkSelfPermission(permissions);
    }
    public void requestPermissions(int requestCode,String... permissions){
        PermissionUtil.requestPermissions(this,requestCode,permissions);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        permissionUtil.onRequestPermissionsResult(requestCode,permissions,grantResults);
    }
    @Override
    public void requestPermissionsSuccess(int requestCode) {

    }

    @Override
    public void requestPermissionsFail(int requestCode) {

    }
}
