import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/app_theme.dart';
import 'package:flutter_gallery_next/base/widget/dialog/common_dialog.dart';
import 'package:plugin_native/proxy/proxy_info.dart';
import 'package:plugin_native/proxy/proxy_util.dart';

class DemoProxy extends StatefulWidget {
  const DemoProxy({Key? key}) : super(key: key);

  @override
  State<DemoProxy> createState() => _DemoProxyState();
}

class _DemoProxyState extends State<DemoProxy> {
  ProxyInfo? _currentProxy;
  bool _isChecking = false;
  final String _testUrl = "http://jsonplaceholder.typicode.com/posts/1";

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text("Proxy Configuration")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildStatusCard(colors),
            const SizedBox(height: 24),
            _buildActionSection(context, colors),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(dynamic colors) {
    final hasProxy = _currentProxy != null && _currentProxy!.host.isNotEmpty;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.security, color: hasProxy ? colors.green500 : colors.neutral400),
                const SizedBox(width: 12),
                const Text("System Proxy Status", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const Divider(height: 32),
            _buildProxyDetailRow("Host:", _currentProxy?.host ?? "None", colors),
            const SizedBox(height: 8),
            _buildProxyDetailRow("Port:", _currentProxy?.port?.toString() ?? "N/A", colors),
            const SizedBox(height: 16),
            if (hasProxy)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: colors.green100, borderRadius: BorderRadius.circular(8)),
                child: Text("Proxy detected! Traffic can be intercepted.",
                    style: TextStyle(color: colors.green700, fontSize: 12, fontWeight: FontWeight.bold)),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildProxyDetailRow(String label, String value, dynamic colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: colors.neutral500)),
        Text(value, style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildActionSection(BuildContext context, dynamic colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text("Management Actions", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        ),
        _buildActionTile(
          context,
          "Initialize ProxyUtil",
          "Register system listeners for proxy changes.",
          Icons.refresh,
          () async {
            await ProxyUtil.instance.init();
            GlobalDialog.showToast("Proxy Service Initialized");
          },
        ),
        const SizedBox(height: 12),
        _buildActionTile(
          context,
          "Detect & Test Dio",
          "Find current proxy and apply it to a Dio request.",
          Icons.network_check,
          _isChecking ? null : _detectAndTestProxy,
        ),
      ],
    );
  }

  Widget _buildActionTile(BuildContext context, String title, String sub, IconData icon, VoidCallback? onTap) {
    final colors = AppTheme.colors(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: colors.blue600),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(sub, style: const TextStyle(fontSize: 11)),
        onTap: onTap,
        trailing: onTap == null
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : const Icon(Icons.chevron_right, size: 18),
      ),
    );
  }

  Future<void> _detectAndTestProxy() async {
    setState(() => _isChecking = true);

    try {
      // 1. Detect proxy
      final proxyInfo = await ProxyUtil.instance.findProxyAsync(Uri.parse(_testUrl));
      setState(() => _currentProxy = proxyInfo);

      // 2. Configure Dio with detected proxy
      final dio = Dio();
      if (proxyInfo != null && proxyInfo.host.isNotEmpty) {
        (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
          final client = HttpClient();
          client.findProxy = (uri) => "PROXY ${proxyInfo.host}:${proxyInfo.port}";
          // Trust self-signed certs (common for debugging proxies like Charles/Fiddler)
          client.badCertificateCallback = (cert, host, port) => true;
          return client;
        };
      }

      // 3. Make a test request
      final response = await dio.get(_testUrl);
      GlobalDialog.showToast("Request Success via Proxy: ${response.statusCode}");
    } catch (e) {
      GlobalDialog.showToast("Test Failed: $e");
    } finally {
      setState(() => _isChecking = false);
    }
  }
}
