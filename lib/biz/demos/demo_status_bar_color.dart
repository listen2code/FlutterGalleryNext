import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gallery_next/base/common/theme/app_theme.dart';
import 'package:flutter_gallery_next/generated/r.dart';

class DemoStatusBarColor extends StatefulWidget {
  const DemoStatusBarColor({super.key});

  @override
  State<DemoStatusBarColor> createState() => _DemoStatusBarColorState();
}

class _DemoStatusBarColorState extends State<DemoStatusBarColor> {
  // Current style configuration
  bool _isIconsDark = true;
  bool _isTransparent = false;
  Color _statusBarColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);

    // Construct the overlay style based on current state
    final systemUiStyle = SystemUiOverlayStyle(
      // Status bar brightness (icons)
      statusBarIconBrightness: _isIconsDark ? Brightness.dark : Brightness.light,
      statusBarBrightness: _isIconsDark ? Brightness.light : Brightness.dark,
      // For iOS

      // Status bar background
      statusBarColor: _isTransparent ? Colors.transparent : _statusBarColor,

      // Navigation bar (Android)
      systemNavigationBarColor: colors.background,
      systemNavigationBarIconBrightness: Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiStyle,
      child: Scaffold(
        extendBodyBehindAppBar: true, // Allow body to flow under AppBar
        appBar: const ImageAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: kToolbarHeight * 3.5),
              _buildControlPanel(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlPanel(BuildContext context) {
    final colors = AppTheme.colors(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Status Bar Controls", style: Theme.of(context).textTheme.titleLarge),
              const Divider(),

              // Icon Brightness Toggle
              ListTile(
                title: const Text("Icon Brightness"),
                subtitle: Text(_isIconsDark ? "Dark Icons" : "Light Icons"),
                trailing: Switch(
                  value: _isIconsDark,
                  onChanged: (v) => setState(() => _isIconsDark = v),
                ),
              ),

              // Transparency Toggle
              ListTile(
                title: const Text("Transparent Status Bar"),
                trailing: Switch(
                  value: _isTransparent,
                  onChanged: (v) => setState(() => _isTransparent = v),
                ),
              ),

              // Color Presets (When not transparent)
              if (!_isTransparent) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text("Background Color Preset"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      _buildColorAction(colors.blue500, "Blue"),
                      _buildColorAction(colors.red500, "Red"),
                      _buildColorAction(colors.green500, "Green"),
                      _buildColorAction(colors.amber500, "Amber"),
                      _buildColorAction(colors.background, "Theme Bg"),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),
              const Text(
                "Note: AnnotatedRegion works per-page. For global app-wide styles, "
                "consider setting it in the theme's appBarTheme.",
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorAction(Color color, String label) {
    return ActionChip(
      backgroundColor: color,
      label: Text(label, style: TextStyle(color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white)),
      onPressed: () => setState(() => _statusBarColor = color),
    );
  }
}

class ImageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ImageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Image spans across the top including status bar area
        SizedBox(
          width: double.infinity,
          height: preferredSize.height,
          child: Image.asset(
            R.imagesLake,
            fit: BoxFit.cover,
          ),
        ),
        // Gradient overlay to ensure back button visibility
        Container(
          height: kToolbarHeight * 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withAlpha(100),
                Colors.transparent,
              ],
            ),
          ),
        ),
        SafeArea(
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text("Demo Status Bar", style: TextStyle(color: Colors.white)),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 3);
}
