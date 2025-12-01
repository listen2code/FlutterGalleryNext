package com.listen.plugin.plugin_native

import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class LaunchExternalAppMethodChannelHandler(private val context: Context?) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

        try {
            when (call.method) {
                "isLaunchExternalApp" -> {
                    val resultMap = HashMap<String, Any>()
                    try {
                        val arguments = call.arguments as? Map<String, Any>
                        val packageName = arguments?.get("packageName") as? String
                        val activityName = arguments?.get("activityName") as? String

                        if (packageName != null && activityName != null) {
                            val intent = Intent(Intent.ACTION_MAIN).apply {
                                setClassName(packageName, activityName)
                            }
                            val resolvedActivity = context?.packageManager?.resolveActivity(intent, 0)
                            Log.d("isLaunchExternalApp", "Resolved Activity: $resolvedActivity")
                            if (resolvedActivity != null) {
                                resultMap["isLaunchExternalApp"] = true
                                result.success(resultMap)
                                Log.d("isLaunchExternalApp", "isLaunchExternalApp true")
                            } else {
                                resultMap["isLaunchExternalApp"] = false
                                result.success(resultMap)
                                Log.d("isLaunchExternalApp", "isLaunchExternalApp false - Activity not found")
                            }
                        } else {
                            result.error("InvalidArguments", "Package name or activity name is null", null)
                        }

                    } catch (e: Exception) {
                        result.error("Error", e.message, null)
                        Log.e("isLaunchExternalApp", "isLaunchExternalApp error=" + e.message)
                    }
                }

                "launchExternalApp" -> {
                    try {
                        val arguments = call.arguments as? Map<String, Any>
                        val packageName = arguments?.get("packageName") as? String
                        val activityName = arguments?.get("activityName") as? String

                        if (packageName != null && activityName != null) {
                            val intent = Intent(Intent.ACTION_MAIN).apply {
                                setClassName(packageName, activityName)
                            }
                            launchExternalApp(intent)
                            Log.d("LaunchExternalApp", "LaunchExternalApp success")
                        } else {
                            result.error("InvalidArguments", "Package name or activity name is null", null)
                        }
                    } catch (e: Exception) {
                        result.error("UnknownError", e.message, null)
                        Log.e("LaunchExternalApp", "LaunchExternalApp error=" + e.message)
                    }
                }

                else -> {
                    result.notImplemented()
                }
            }
        } catch (e: Exception) {
            result.error("Name not found", e.message, null)
            Log.e("LaunchExternalAppHandler", "LaunchExternalAppHandler error=" + e.message)
        }
    }

    private fun launchExternalApp(intent: Intent) {
        if (context != null) {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
        } else {
            Log.e("LaunchExternalApp", "Context is null, cannot start activity")
            throw IllegalStateException("Context is null, cannot start activity")
        }
    }
}
