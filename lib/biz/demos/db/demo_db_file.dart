import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/app_theme.dart';
import 'package:path_provider/path_provider.dart';

class CounterStorage {
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) return 0;
      final contents = await file.readAsString();
      return int.parse(contents);
    } catch (e) {
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;
    return file.writeAsString('$counter');
  }

  Future<void> resetCounter() async {
    final file = await _localFile;
    if (await file.exists()) {
      await file.delete();
    }
  }
}

class DemoDbFile extends StatefulWidget {
  final CounterStorage storage;

  const DemoDbFile({super.key, required this.storage});

  @override
  State<DemoDbFile> createState() => _DemoDbFileState();
}

class _DemoDbFileState extends State<DemoDbFile> {
  int _counter = 0;
  String _filePath = 'Loading...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    final path = await widget.storage.localPath;
    final value = await widget.storage.readCounter();
    if (!mounted) return;
    setState(() {
      _counter = value;
      _filePath = '$path/counter.txt';
      _isLoading = false;
    });
  }

  Future<void> _incrementCounter() async {
    setState(() {
      _counter++;
    });
    await widget.storage.writeCounter(_counter);
  }

  Future<void> _resetCounter() async {
    await widget.storage.resetCounter();
    setState(() {
      _counter = 0;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Counter reset and file deleted.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('File IO Operations'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildStatusCard(colors),
                  const SizedBox(height: 24),
                  _buildPathCard(colors),
                  const SizedBox(height: 32),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.red500,
                      side: BorderSide(color: colors.red500),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _resetCounter,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text("Reset & Delete File"),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _incrementCounter,
        label: const Text("Increment"),
        icon: const Icon(Icons.add),
        backgroundColor: colors.blue600,
      ),
    );
  }

  Widget _buildStatusCard(dynamic colors) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [colors.blue500, colors.blue700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const Icon(Icons.touch_app, color: Colors.white, size: 48),
            const SizedBox(height: 16),
            const Text(
              "Taps Recorded",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Text(
              "$_counter",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPathCard(dynamic colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.folder_open, size: 18, color: colors.blue500),
            const SizedBox(width: 8),
            Text(
              "Storage Location",
              style: TextStyle(
                color: colors.neutral900,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.neutral100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colors.neutral200),
          ),
          child: Text(
            _filePath,
            style: TextStyle(
              color: colors.neutral600,
              fontSize: 11,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }
}
