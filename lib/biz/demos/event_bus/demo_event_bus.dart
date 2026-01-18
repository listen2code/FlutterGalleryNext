import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/event_bus/event_bus.dart';
import 'package:flutter_gallery_next/base/common/theme/app_theme.dart';

class DemoEventBus extends StatefulWidget {
  const DemoEventBus({Key? key}) : super(key: key);

  @override
  State<DemoEventBus> createState() => _DemoEventBusState();
}

class _DemoEventBusState extends State<DemoEventBus> {
  final List<String> _logs = [];
  StreamSubscription? _stringSub;
  StreamSubscription? _stickySub;

  @override
  void initState() {
    super.initState();
    _addLog("Event Bus Demo Initialized");
  }

  void _subscribeString() {
    if (_stringSub != null) return;
    _stringSub = EventBus.defaultBus().subscribe<String>(
      subscriber: (data) => _addLog("Received String: $data"),
    );
    _addLog("Subscribed to String events");
  }

  void _addLog(String msg) {
    if (!mounted) return;
    setState(() {
      _logs.insert(0, "${DateTime.now().toString().split('.').first.split(' ').last} | $msg");
    });
  }

  @override
  void dispose() {
    _stringSub?.cancel();
    _stickySub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Event Bus Explorer')),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: _buildControlPanel(colors),
          ),
          const Divider(height: 1),
          Expanded(
            flex: 2,
            child: _buildLogPanel(colors),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel(dynamic colors) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildActionCard(
          "Regular String Events",
          "Manage standard string event flow.",
          [
            ElevatedButton(
              onPressed: () {
                _addLog("Posted String: 'Hello Flutter!'");
                EventBus.defaultBus().post(event: "Hello Flutter!");
              },
              child: const Text("Post String"),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _subscribeString,
              child: const Text("Subscribe"),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: colors.rose500, foregroundColor: Colors.white),
              onPressed: () {
                _stringSub?.cancel();
                _stringSub = null;
                _addLog("Unsubscribed from String");
              },
              child: const Text("Unsubscribe"),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildActionCard(
          "Sticky String Events",
          "Post once, receive on any future subscription.",
          [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: colors.amber500, foregroundColor: Colors.white),
              onPressed: () {
                _addLog("Posted Sticky: 'Hello Flutter!'");
                EventBus.defaultBus().post(key: "secret", event: "Hello Flutter!", sticky: true);
              },
              child: const Text("Post Sticky"),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                if (_stickySub != null) {
                  _addLog("Already subscribed to sticky.");
                  return;
                }
                _stickySub = EventBus.defaultBus().subscribe<String>(
                  key: "secret",
                  subscriber: (data) => _addLog("Sticky Received: $data"),
                );
                _addLog("Subscribed to Sticky");
              },
              child: const Text("Sub Sticky"),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: colors.rose500, foregroundColor: Colors.white),
              onPressed: () {
                _stickySub?.cancel();
                _stickySub = null;
                _addLog("Unsubscribed from Sticky");
              },
              child: const Text("Unsub Sticky"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLogPanel(dynamic colors) {
    return Container(
      width: double.infinity,
      color: colors.neutral100,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Event Logs", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              TextButton(onPressed: () => setState(() => _logs.clear()), child: const Text("Clear")),
            ],
          ),
          Expanded(
            child: _logs.isEmpty
                ? const Center(child: Text("No events recorded yet.", style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    itemCount: _logs.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(_logs[index], style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, String sub, List<Widget> actions) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 16),
            Wrap(spacing: 8, runSpacing: 8, children: actions),
          ],
        ),
      ),
    );
  }
}
