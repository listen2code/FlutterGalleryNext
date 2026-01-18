import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/app_theme.dart';

class DemoExpandFloatButton extends StatefulWidget {
  const DemoExpandFloatButton({super.key});

  @override
  State<DemoExpandFloatButton> createState() => _DemoExpandFloatButtonState();
}

class _DemoExpandFloatButtonState extends State<DemoExpandFloatButton> {
  bool _isFanStyle = true;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Expandable FAB'),
        actions: [
          TextButton(
            onPressed: () => setState(() => _isFanStyle = !_isFanStyle),
            child: Text(_isFanStyle ? "Switch to Vertical" : "Switch to Fan", style: const TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: 20,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _buildPostCard(context, index),
      ),
      floatingActionButton: ExpandableFab(
        distance: 90.0,
        isFanStyle: _isFanStyle,
        children: [
          ActionButton(
            onPressed: () => _showAction(context, 'Video Uploaded'),
            icon: const Icon(Icons.videocam),
            color: colors.blue500,
          ),
          ActionButton(
            onPressed: () => _showAction(context, 'Photo Shared'),
            icon: const Icon(Icons.insert_photo),
            color: colors.rose500,
          ),
          ActionButton(
            onPressed: () => _showAction(context, 'Post Created'),
            icon: const Icon(Icons.format_size),
            color: colors.green500,
          ),
        ],
      ),
    );
  }

  void _showAction(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Widget _buildPostCard(BuildContext context, int index) {
    final colors = AppTheme.colors(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                    backgroundColor: colors.blue100, child: Text("${index + 1}", style: TextStyle(color: colors.blue600))),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("User Name", style: TextStyle(color: colors.foreground, fontWeight: FontWeight.bold)),
                    Text("2 hours ago", style: TextStyle(color: colors.neutral500, fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
                height: 10,
                width: double.infinity,
                decoration: BoxDecoration(color: colors.neutral100, borderRadius: BorderRadius.circular(5))),
            const SizedBox(height: 8),
            Container(
                height: 10,
                width: 200,
                decoration: BoxDecoration(color: colors.neutral100, borderRadius: BorderRadius.circular(5))),
          ],
        ),
      ),
    );
  }
}

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    super.key,
    this.initialOpen,
    required this.distance,
    required this.children,
    this.isFanStyle = true,
  });

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;
  final bool isFanStyle;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    final colors = AppTheme.colors(context);
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          color: colors.background,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.close, color: colors.blue600),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;

    if (widget.isFanStyle) {
      final step = 90.0 / (count - 1);
      for (var i = 0, angleInDegrees = 0.0; i < count; i++, angleInDegrees += step) {
        children.add(
          _ExpandingActionButton(
            directionInDegrees: angleInDegrees,
            maxDistance: widget.distance,
            progress: _expandAnimation,
            child: widget.children[i],
          ),
        );
      }
    } else {
      // Vertical (Speed Dial) Style
      for (var i = 0; i < count; i++) {
        children.add(
          _ExpandingActionButton(
            directionInDegrees: 90, // Upwards
            maxDistance: widget.distance * (i + 1),
            progress: _expandAnimation,
            child: widget.children[i],
          ),
        );
      }
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(_open ? 0.7 : 1.0, _open ? 0.7 : 1.0, 1.0),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: _toggle,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
    required this.color,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: color,
      elevation: 4.0,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: Colors.white,
      ),
    );
  }
}
