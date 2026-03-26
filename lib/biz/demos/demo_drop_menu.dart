import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: DemoDropMenu(),
    debugShowCheckedModeBanner: false,
  ));
}

class DemoDropMenu extends StatelessWidget {
  const DemoDropMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overlay Menu'),
        actions: [
          CommonOverlayMenu(
            title: 'Menu Title',
            titleStyle: const TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
            closeIcon: Icons.cancel_outlined,
            width: 200,
            showScrim: true,
            triggerBuilder: (context, isOpen, toggle) => IconButton(
              icon: Icon(isOpen ? Icons.close : Icons.more_vert),
              onPressed: toggle,
            ),
            contentBuilder: (context, close) => _buildDemoList(close, count: 5),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonOverlayMenu(
              title: 'This is a very long title that should be truncated',
              widthFactor: 0.6,
              maxHeight: 250,
              backgroundColor: Colors.grey.shade50,
              showScrim: true,
              targetAnchor: Alignment.bottomCenter,
              followerAnchor: Alignment.topCenter,
              triggerBuilder: (context, isOpen, toggle) => ElevatedButton.icon(
                onPressed: toggle,
                icon: Icon(isOpen ? Icons.expand_less : Icons.expand_more),
                label: const Text('Centered Title Demo'),
              ),
              contentBuilder: (context, close) => _buildDemoList(close, count: 15),
            ),
            const SizedBox(height: 50),
            CommonOverlayMenu(
              title: 'Quick Select',
              width: 200,
              titleStyle: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              closeIcon: Icons.cancel,
              offset: const Offset(0, -10),
              targetAnchor: Alignment.bottomCenter,
              followerAnchor: Alignment.topCenter,
              triggerBuilder: (context, isOpen, toggle) => GestureDetector(
                onTap: toggle,
                child: Text(
                  'Tap this text',
                  style: TextStyle(
                    color: isOpen ? Colors.blue : Colors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              contentBuilder: (context, close) => _buildDemoList(close, count: 3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoList(VoidCallback closeMenu, {int count = 5}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
          count,
          (index) => ListTile(
                leading: Icon(index % 2 == 0 ? Icons.star_border : Icons.label_outline),
                title: Text('Item ${index + 1}'),
                dense: true,
                onTap: closeMenu,
              )),
    );
  }
}

class CommonOverlayMenu extends StatefulWidget {
  final String title;
  final TextStyle? titleStyle;
  final IconData? closeIcon;
  final Widget Function(BuildContext context, bool isOpen, VoidCallback toggle) triggerBuilder;
  final Widget Function(BuildContext context, VoidCallback closeMenu) contentBuilder;
  final double? width;
  final double widthFactor;
  final double? maxHeight;
  final Color? backgroundColor;
  final Offset offset;
  final Alignment targetAnchor;
  final Alignment followerAnchor;
  final bool showScrim;

  const CommonOverlayMenu({
    super.key,
    required this.title,
    this.titleStyle,
    this.closeIcon,
    required this.triggerBuilder,
    required this.contentBuilder,
    this.width,
    this.widthFactor = 0.45,
    this.maxHeight,
    this.backgroundColor,
    this.offset = const Offset(0, 8),
    this.targetAnchor = Alignment.bottomRight,
    this.followerAnchor = Alignment.topRight,
    this.showScrim = false,
  });

  @override
  State<CommonOverlayMenu> createState() => _CommonOverlayMenuState();
}

class _CommonOverlayMenuState extends State<CommonOverlayMenu> with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isMenuOpen = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
  }

  void _toggleMenu() {
    if (_isMenuOpen) {
      _hideMenu();
    } else {
      _showMenu();
    }
  }

  void _showMenu() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward();
    setState(() {
      _isMenuOpen = true;
    });
  }

  Future<void> _hideMenu() async {
    if (_isMenuOpen) {
      await _animationController.reverse();
      _overlayEntry?.remove();
      _overlayEntry = null;
      if (mounted) {
        setState(() {
          _isMenuOpen = false;
        });
      }
    }
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            GestureDetector(
              onTap: _hideMenu,
              behavior: HitTestBehavior.opaque,
              child: Container(
                color: Colors.black.withOpacity(widget.showScrim ? 0.3 : 0),
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              targetAnchor: widget.targetAnchor,
              followerAnchor: widget.followerAnchor,
              offset: widget.offset,
              child: Material(
                elevation: 8,
                shadowColor: Colors.black26,
                borderRadius: BorderRadius.circular(12),
                color: Colors.transparent,
                child: Container(
                  width: widget.width ?? MediaQuery.of(context).size.width * widget.widthFactor,
                  constraints: BoxConstraints(
                    maxHeight: widget.maxHeight ?? MediaQuery.of(context).size.height * 0.6,
                  ),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor ?? Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header with Centered Title
                      SizedBox(
                        height: 48,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 44.0),
                              child: Text(
                                widget.title,
                                style: widget.titleStyle ??
                                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Positioned(
                              right: 4,
                              child: IconButton(
                                visualDensity: VisualDensity.compact,
                                icon: Icon(widget.closeIcon ?? Icons.close, size: 18),
                                onPressed: _hideMenu,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      Flexible(
                        child: SingleChildScrollView(
                          child: widget.contentBuilder(context, _hideMenu),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: widget.triggerBuilder(context, _isMenuOpen, _toggleMenu),
    );
  }
}
