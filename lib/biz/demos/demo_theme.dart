import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/main.dart';

class DemoTheme extends StatelessWidget {
  const DemoTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return const DemoThemePage(
      title: 'Demo Theme',
    );
  }
}

class DemoThemePage extends StatelessWidget {
  final String title;

  const DemoThemePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final bool isDark = MyApp.of(context)?.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Container(
          // Uses colorScheme.primary which will change based on the selected theme.
          color: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.all(20),
          child: Text(
            'Current Mode: ${isDark ? "Dark" : "Light"}',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Toggle the global theme mode using the static 'of' method defined in MyApp.
          final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
          MyApp.of(context)?.changeTheme(newMode);
        },
        tooltip: 'Toggle Theme',
        child: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
      ),
    );
  }
}
