import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/app_theme.dart';
import 'package:package_libs/utils/sp_util.dart';

class DemoDbSp extends StatefulWidget {
  const DemoDbSp({super.key});

  @override
  State<DemoDbSp> createState() => _DemoDbSpState();
}

class _DemoDbSpState extends State<DemoDbSp> {
  // Data states
  int _counter = 0;
  String _username = '';
  bool _isNotificationEnabled = false;

  final TextEditingController _userController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  @override
  void dispose() {
    _userController.dispose();
    super.dispose();
  }

  void _loadAllData() {
    setState(() {
      _counter = SpUtil.instance.getInt('sp_counter');
      _username = SpUtil.instance.getString('sp_username', defaultValue: 'Guest');
      _isNotificationEnabled = SpUtil.instance.getBool('sp_notif');
      _userController.text = _username;
    });
  }

  // --- Actions ---

  Future<void> _incrementCounter() async {
    setState(() {
      _counter++;
    });
    await SpUtil.instance.set('sp_counter', _counter);
  }

  Future<void> _saveUsername(String value) async {
    setState(() {
      _username = value;
    });
    await SpUtil.instance.set('sp_username', value);
  }

  Future<void> _toggleNotification(bool value) async {
    setState(() {
      _isNotificationEnabled = value;
    });
    await SpUtil.instance.set('sp_notif', value);
  }

  Future<void> _resetAll() async {
    await SpUtil.instance.remove('sp_counter');
    await SpUtil.instance.remove('sp_username');
    await SpUtil.instance.remove('sp_notif');
    _loadAllData();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All Shared Preferences cleared!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text("Shared Preferences Demo"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAllData,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Counter Card (Integer)
            _buildCounterCard(colors),
            const SizedBox(height: 16),

            // 2. User Info Card (String)
            _buildSettingsCard(
              colors,
              title: "User Profile",
              icon: Icons.person_outline,
              child: TextField(
                controller: _userController,
                decoration: InputDecoration(
                  labelText: "Username",
                  hintText: "Enter name to save...",
                  prefixIcon: const Icon(Icons.edit),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onChanged: _saveUsername,
              ),
            ),
            const SizedBox(height: 16),

            // 3. System Toggle (Boolean)
            _buildSettingsCard(
              colors,
              title: "System Settings",
              icon: Icons.settings_outlined,
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Enable Notifications"),
                subtitle: const Text("Saves boolean state to SP"),
                value: _isNotificationEnabled,
                onChanged: _toggleNotification,
              ),
            ),

            const SizedBox(height: 32),

            // 4. Reset Action
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: colors.red500),
              onPressed: _resetAll,
              icon: const Icon(Icons.delete_sweep),
              label: const Text("Clear All Local Data"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment Counter',
        backgroundColor: colors.blue600,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCounterCard(dynamic colors) {
    return Card(
      elevation: 0,
      color: colors.blue100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colors.blue500.withAlpha(40)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Persistent Counter", style: TextStyle(color: colors.blue700, fontWeight: FontWeight.bold)),
                const Text("Value survives app restarts", style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            Text(
              "$_counter",
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: colors.blue600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(dynamic colors, {required String title, required IconData icon, required Widget child}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: colors.blue500),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(height: 1),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
