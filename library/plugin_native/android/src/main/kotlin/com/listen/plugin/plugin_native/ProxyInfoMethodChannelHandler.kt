package com.listen.plugin.plugin_native

import android.content.Context
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.net.InetSocketAddress
import java.net.Proxy
import java.net.ProxySelector
import java.net.URI


class ProxyInfoMethodChannelHandler(private val context: Context?) : MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                "getProxyInfo" -> {
                    val infoMap = HashMap<String, String>()
                    try {
                        infoMap["host"] = System.getProperty("http.proxyHost", "")
                        infoMap["port"] = System.getProperty("http.proxyPort", "")
                        infoMap["nonProxy"] = System.getProperty("http.nonProxyHosts", "")
                        Log.d("ProxyInfoHandler", "ProxyInfoHandler getProxyInfo=$infoMap")
                    } catch (e: Exception) {
                        Log.e("ProxyInfoHandler", "ProxyInfoHandler getProxyInfo error=" + e.message)
                        infoMap["host"] = ""
                        infoMap["port"] = ""
                        infoMap["nonProxy"] = ""
                    } finally {
                        result.success(infoMap)
                    }
                }

                "findProxy" -> {
                    var infoMap = HashMap<String, String>()
                    try {
                        val arguments = call.arguments as? Map<String, Any>
                        val url = arguments?.get("url") as? String
                        infoMap = findProxyByUrl(url)
                        Log.d("ProxyInfoHandler", "ProxyInfoHandler findProxyByUrl url=$url result=$infoMap")
                    } catch (e: Exception) {
                        Log.e("ProxyInfoHandler", "ProxyInfoHandler findProxyByUrl error=" + e.message)
                        infoMap["host"] = ""
                        infoMap["port"] = ""
                        infoMap["type"] = "DIRECT"
                    } finally {
                        result.success(infoMap)
                    }
                }

                else -> {
                    result.notImplemented()
                }
            }
        } catch (e: Exception) {
            result.error("Name not found", e.message, null)
            Log.e("ProxyInfoHandler", "ProxyInfoHandler onMethodCall error=" + e.message)
        }
    }


    private fun findProxyByUrl(url: String?): HashMap<String, String> {
        val map = HashMap<String, String>()
        map["host"] = ""
        map["port"] = ""
        map["type"] = "DIRECT"
        if (url.isNullOrEmpty()) {
            Log.d("ProxyInfoHandler", "findProxyByUrl url is empty(DIRECT)=$url")
            return map
        }

        var proxyList = ProxySelector.getDefault().select(URI.create(url))
        Log.d("ProxyInfoHandler", "findProxyByUrl proxyList(${proxyList.size})=" + proxyList)
        if (proxyList?.isNullOrEmpty() == true || proxyList[0].type() != Proxy.Type.HTTP) {
            Log.d("ProxyInfoHandler", "findProxyByUrl proxyList not found(DIRECT)=$url")
            return map
        }

        var proxy = proxyList[0]
        Log.d("ProxyInfoHandler", "findProxyByUrl address=${proxy.address()}")
        if (proxy.address() !is InetSocketAddress) {
            Log.d("ProxyInfoHandler", "findProxyByUrl proxy not InetSocketAddress=${proxy.address().javaClass}")
            return map
        }
        var inetSocketAddress = proxy.address() as InetSocketAddress
        map["host"] = inetSocketAddress.hostName
        map["port"] = inetSocketAddress.port.toString()
        map["type"] = "PROXY"
        Log.d("ProxyInfoHandler", "findProxyByUrl result(PROXY)=${map["type"]} ${map["host"]} ${map["port"]}")

        return map
    }
}