import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/app_theme.dart';
import 'package:package_libs/utils/auth_util.dart';
import 'package:package_libs/utils/sp_util.dart';

class DemoAuth extends StatefulWidget {
  const DemoAuth({super.key});

  @override
  State<DemoAuth> createState() => _DemoAuthState();
}

class _DemoAuthState extends State<DemoAuth> {
  bool _isSupported = false;
  String _authType = "Checking...";
  bool _isLockEnabled = false;
  int _timeoutMinutes = 0;

  @override
  void initState() {
    super.initState();
    _checkHardware();
    _loadSettings();
  }

  Future<void> _checkHardware() async {
    final supported = await AuthUtil.instance().isAvailable();
    final type = await AuthUtil.instance().getAuthTypeName();
    setState(() {
      _isSupported = supported;
      _authType = type;
    });
  }

  void _loadSettings() {
    setState(() {
      _isLockEnabled = SpUtil.instance.getString("lockPassWordId").isNotEmpty;
      String timeStr = SpUtil.instance.getString("authenticationTime", defaultValue: "0");
      _timeoutMinutes = int.tryParse(timeStr) ?? 0;
    });
  }

  Future<void> _handleAuth() async {
    final result = await AuthUtil.instance().authenticate();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Auth Result: ${result.name.toUpperCase()}")),
      );
    }
    _loadSettings();
  }

  Future<void> _toggleLock(bool value) async {
    // In a real app, this would involve setting a pin/pattern
    await SpUtil.instance.set("lockPassWordId", value ? "MOCK_PIN_1234" : "");
    _loadSettings();
  }

  Future<void> _updateTimeout(double value) async {
    await SpUtil.instance.set("authenticationTime", value.toInt().toString());
    _loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text("Biometric Authentication")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHardwareCard(colors),
          const SizedBox(height: 24),
          _buildSettingsCard(colors),
          const SizedBox(height: 24),
          _buildActionCard(colors),
        ],
      ),
    );
  }

  Widget _buildHardwareCard(dynamic colors) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.fingerprint, color: _isSupported ? colors.green500 : colors.red500),
                const SizedBox(width: 12),
                const Text("Hardware Status", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow("Device Supported", _isSupported ? "YES" : "NO", colors),
            _buildInfoRow("Auth Methods", _authType, colors),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(dynamic colors) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text("Enable App Lock", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text("Required for automatic re-auth"),
            value: _isLockEnabled,
            onChanged: _toggleLock,
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Lock Timeout (Minutes)", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("${_timeoutMinutes}m", style: TextStyle(color: colors.blue600, fontWeight: FontWeight.bold)),
                  ],
                ),
                Slider(
                  value: _timeoutMinutes.toDouble(),
                  min: 0,
                  max: 60,
                  divisions: 12,
                  onChanged: _isLockEnabled ? _updateTimeout : null,
                ),
                Text(
                  "App will require biometric auth after being in background for ${_timeoutMinutes}m.",
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(dynamic colors) {
    return Card(
      color: colors.blue100,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Test manual authentication:", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: colors.blue600,
                foregroundColor: Colors.white,
              ),
              onPressed: _isSupported ? _handleAuth : null,
              icon: const Icon(Icons.lock_open),
              label: const Text("Authenticate Now"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, dynamic colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: colors.neutral600, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}
