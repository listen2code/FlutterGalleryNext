package com.listen.plugin.plugin_native

import android.content.Context
import android.content.pm.PackageInfo
import android.os.Build
import android.util.Log
import java.util.UUID
import androidx.annotation.NonNull

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class DeviceInfoMethodChannelHandler(private val context: Context?) : MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            if (call.method == "getDeviceInfo") {
                val packageManager = context!!.packageManager
                val info = packageManager.getPackageInfo(context!!.packageName, 0)
                val infoMap = HashMap<String, String>()

                try {
                    infoMap["appName"] = info.applicationInfo?.loadLabel(packageManager).toString()
                    infoMap["packageName"] = context.packageName
                    infoMap["appVersionName"] = info.versionName ?: ""
                    infoMap["appVersionCode"] = getLongVersionCode(info).toString()
                    infoMap["model"] = android.os.Build.MODEL
                    infoMap["product"] = android.os.Build.PRODUCT
                    infoMap["deviceVersion"] = android.os.Build.VERSION.RELEASE
                    infoMap["uuid"] = UUID.randomUUID().toString()
                    Log.d("DeviceInfoHandler", "DeviceInfoHandler getDeviceInfo=$infoMap")
                } catch (e: Exception) {
                    Log.e("DeviceInfoHandler", "DeviceInfoHandler getDeviceInfo error=" + e.message)
                } finally {
                    result.success(infoMap)
                }
            } else {
                result.notImplemented()
            }
        } catch (e: Exception) {
            result.error("Name not found", e.message, null)
            Log.e("DeviceInfoHandler", "DeviceInfoHandler onMethodCall error=" + e.message)
        }
    }

    private fun getLongVersionCode(info: PackageInfo): Long {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            info.longVersionCode
        } else {
            info.versionCode.toLong()
        }
    }
}
