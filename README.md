# todo

1.auto proxy
2.common widget: button, text, expandable, tabview, refreshList
3.architecture+redux
4.demo
5.multi router
6.build apk
7.splash
8.rules
9.plugin: jsonGenerator ?

# architecture

main
-library
--package_base: only dart
----package_libs: basic third util, network, sp, event_bus, theme, globalization
------package_widget: base widgets, button, text, image, dialog, toast, loading, refreshList, tabView,
--------package_biz: base biz
----------package_webView: webView
----------package_splash: splash module
----------package_login: login module
----------package_share: share module
--plugin_native: plugin for native basic info
--plugin_proxy: plugin for proxy

# create package and plugin

1. flutter create --org com.xxx.xxx --template=plugin --platforms=android,ios -a kotlin -i swift plugin_xxx
2. flutter create --template=package package_xxx

# tools

1.FlutterJsonBeanFactory
2.FlutterAssetsGenerator