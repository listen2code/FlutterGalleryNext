import Flutter
import UIKit

public class PluginNativePlugin: NSObject, FlutterPlugin {
  
  var data = [String: String]()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = DevicePlugin()

    let deviceChannel = FlutterMethodChannel(name: "com.listen.plugin.plugin_native/device_info", binaryMessenger: registrar.messenger())
    let proxyChannel = FlutterMethodChannel(name: "com.listen.plugin.plugin_native/proxy_info", binaryMessenger: registrar.messenger())

    registrar.addMethodCallDelegate(instance, channel: deviceChannel)
    registrar.addMethodCallDelegate(instance, channel: proxyChannel)

  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getDeviceInfo":
      var data = [String: String]()
      if let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] {
          data["appName"] = String(describing: appName)
      } else if let appName = Bundle.main.infoDictionary?["CFBundleName"] {
          data["appName"] = String(describing: appName)
      }
      if let bundleId = Bundle.main.infoDictionary?["CFBundleIdentifier"] {
          data["packageName"] = String(describing: bundleId)
      }
      if let appVersionName = Bundle.main.infoDictionary?["CFBundleShortVersionString"] {
          data["appVersionName"] = String(describing: appVersionName)
      }
      if let appVersionCode = Bundle.main.infoDictionary?["CFBundleVersion"] {
          data["appVersionCode"] = String(describing: appVersionCode)
      }
      data["model"] = UIDevice.current.model
      data["product"] = getPlatform()
      data["deviceVersion"] = UIDevice.current.systemVersion
      data["uuid"] = UUID().uuidString
      result(data)
    case "getProxyInfo":
      result(getProxyInfo())
    case "findProxy":
      let arguments = call.arguments as! [String: Any]
      let url = arguments["url"] as! String
      result(findProxyByUrl(urlStr: url))
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  func getPlatform() -> String {
    var size: Int = 0
    sysctlbyname("hw.machine", nil, &size, nil, 0)
    var machine = [CChar](repeating: 0, count: Int(size))
    sysctlbyname("hw.machine", &machine, &size, nil, 0)
    return String.init(cString: machine)
  }

  func getProxyInfo() -> [String: String] {
      data = [
          "host": "",
          "port": "",
          "nonProxy": "",
          "type": ""
      ]
      guard let proxySettings = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() as? NSDictionary else {
          return data
      }
      if let httpEnable: NSNumber = proxySettings.object(forKey: kCFNetworkProxiesHTTPEnable as String) as? NSNumber,httpEnable.intValue != 0 {
          // 手動プロキシの場合
          if let host:String = proxySettings.object(forKey: "HTTPProxy") as? String {
              data["host"] = host
          }
          if let port:NSNumber = proxySettings.object(forKey: "HTTPPort") as? NSNumber {
              data["port"] = String(describing: port)
          }
          if let nonProxyHosts = proxySettings.object(forKey: "ExceptionsList") as? [String] {
              let nonProxy:String = nonProxyHosts.joined(separator: "|")
              data["nonProxy"] = nonProxy
          }
          return data
      } else if let proxyAutoConfigEnable: NSNumber = proxySettings.object(forKey: kCFNetworkProxiesProxyAutoConfigEnable as String) as? NSNumber,proxyAutoConfigEnable.intValue != 0 {
          // 自動プロキシの場合
          data["type"] = "AUTO"
          return data
      }
      return data
  }

  func findProxyByUrl(urlStr: String) -> [String: String] {
      data = [
          "host": "",
          "port": "",
          "type": "DIRECT"
      ]
      guard let proxySettings = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() as? NSDictionary,
            let url = URL(string: urlStr) else {
          return data
      }
      let proxies = CFNetworkCopyProxiesForURL((url as CFURL), proxySettings).takeUnretainedValue() as! [NSDictionary]
      if let httpEnable: NSNumber = proxySettings.object(forKey: kCFNetworkProxiesHTTPEnable as String) as? NSNumber,httpEnable.intValue != 0 {
          // 手動プロキシの場合
          for proxy in proxies {
              if let hostName = proxy.object(forKey: (kCFProxyHostNameKey as String)), let port = proxy.object(forKey: (kCFProxyPortNumberKey as String)) {
                  data["host"] = String(describing: hostName)
                  data["port"] = String(describing: port)
                  data["type"] = "PROXY"
                  return data
              }
          }
      } else if let proxyAutoConfigEnable: NSNumber = proxySettings.object(forKey: kCFNetworkProxiesProxyAutoConfigEnable as String) as? NSNumber,proxyAutoConfigEnable.intValue != 0 {
          // 自動プロキシの場合
          for proxy in proxies {
              if let autoUrl = proxy.object(forKey: (kCFProxyAutoConfigurationURLKey as String)) {
                  fetchProxySetting(for: URL(string: urlStr)!, pacUrl: URL(string: String(describing: autoUrl))!)
                  return data
              }
          }
      }
      return data
  }

  struct PACInfo {
      static var proxyHost: String = ""
      static var proxyPort: String = ""
      static var proxyType: String = "DIRECT"
      /// CFNetworkExecuteProxyAutoConfigurationURLのコールバック
      static func proxyAutoConfigurationResultCallback(client: UnsafeMutableRawPointer, proxyList: CFArray, error: CFError?) {
          if error != nil {
              return
          }
          // プロキシ情報を解析する
          if let proxyArray = proxyList as? [Dictionary<CFString, Any>] {
              for dictionary in proxyArray {
                  if let host = dictionary[kCFProxyHostNameKey], let port = dictionary[kCFProxyPortNumberKey] {
                      // プロキシありの場合
                      proxyHost = String(describing: host)
                      proxyPort = String(describing: port)
                      proxyType = "PROXY"
                  } else {
                      // プロキシなしの場合
                      proxyHost = ""
                      proxyPort = ""
                      proxyType = "DIRECT"
                  }
              }
          }
      }
  }

  /// URLに基づいてプロキシ情報を返する
  func fetchProxySetting(for url: URL, pacUrl: URL) {
      let runLoop = CFRunLoopGetCurrent()
      let mode = CFRunLoopMode.defaultMode
      var context = CFStreamClientContext(version: CFIndex(0), info: nil, retain: nil, release: nil, copyDescription: nil)

      // URLに従って.pacファイルを実行し、プロキシ情報を返する
      let pacSource = CFNetworkExecuteProxyAutoConfigurationURL(pacUrl as CFURL, url as CFURL,{client,proxyList,error in
          PACInfo.proxyAutoConfigurationResultCallback(client: client, proxyList: proxyList, error: error)
          CFRunLoopStop(CFRunLoopGetCurrent())
      }, &context)
      CFRunLoopAddSource(runLoop, pacSource, mode)
      CFRunLoopRun()
      CFRunLoopRemoveSource(runLoop, pacSource, mode)

      // data更新
      data["host"] = PACInfo.proxyHost
      data["port"] = PACInfo.proxyPort
      data["type"] = PACInfo.proxyType
  }
}
