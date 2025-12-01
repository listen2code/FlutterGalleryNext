package com.listen.plugin.plugin_native

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.content.Context

/** PluginNativePlugin */
class PluginNativePlugin : FlutterPlugin {

    private lateinit var deviceChannel: MethodChannel
    private lateinit var proxyChannel: MethodChannel
    private lateinit var launchMethodChannel: MethodChannel

    private var applicationContext: Context? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = flutterPluginBinding.applicationContext

        deviceChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.listen.plugin.plugin_native/device_info")
        deviceChannel.setMethodCallHandler(DeviceInfoMethodChannelHandler(applicationContext))

        proxyChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.listen.plugin.plugin_native/proxy_info")
        proxyChannel.setMethodCallHandler(ProxyInfoMethodChannelHandler(applicationContext))

        launchMethodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.listen.plugin.plugin_native/launch_external_app")
        launchMethodChannel.setMethodCallHandler(LaunchExternalAppMethodChannelHandler(applicationContext))
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        deviceChannel.setMethodCallHandler(null)
        proxyChannel.setMethodCallHandler(null)
        launchMethodChannel.setMethodCallHandler(null)
    }
}
