import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_gallery_next/base/common/theme/app_theme.dart';

class DemoAnimPhysicsDragPage extends StatefulWidget {
  const DemoAnimPhysicsDragPage({super.key});

  @override
  State<DemoAnimPhysicsDragPage> createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DemoAnimPhysicsDragPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Alignment _dragAlignment = Alignment.center;
  late Animation<Alignment> _animation;

  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.center,
      ),
    );
    
    // Calculate the velocity relative to the unit interval, [0,1]
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    // Standard physics simulation parameters
    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);
    _controller.animateWith(simulation);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = AppTheme.colors(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text("Physics Drag")),
      body: Stack(
        children: [
          Center(
            child: Text(
              "Drag the card away and release",
              style: TextStyle(color: colors.neutral400, fontStyle: FontStyle.italic),
            ),
          ),
          GestureDetector(
            onPanDown: (details) => _controller.stop(),
            onPanUpdate: (details) {
              setState(() {
                _dragAlignment += Alignment(
                  details.delta.dx / (size.width / 2),
                  details.delta.dy / (size.height / 2),
                );
              });
            },
            onPanEnd: (details) => _runAnimation(details.velocity.pixelsPerSecond, size),
            child: Align(
              alignment: _dragAlignment,
              child: Card(
                elevation: 12,
                shadowColor: colors.blue500.withAlpha(80),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [colors.blue500, colors.blue700],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.swipe, color: Colors.white, size: 60),
                      SizedBox(height: 12),
                      Text("Drag Me!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
