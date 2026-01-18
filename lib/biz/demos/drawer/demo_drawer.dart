import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/biz/demos/drawer/demo_drawer_draggable.dart';
import 'package:flutter_gallery_next/biz/demos/drawer/demo_drawer_draggable_handler.dart';

class DemoDrawer extends StatefulWidget {
  const DemoDrawer({super.key});

  @override
  State<DemoDrawer> createState() => _DemoDrawerState();
}

class _DemoDrawerState extends State<DemoDrawer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: const Text('Demo Drawer')),
      drawer: _buildLeftDrawer(context),
      endDrawer: _buildRightDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              _buildDemoCard(
                [
                  ElevatedButton.icon(
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    icon: const Icon(Icons.menu_open),
                    label: const Text("Open Left Drawer"),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                    icon: const Icon(Icons.menu_open),
                    label: const Text("Open Right Drawer"),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeftDrawer(BuildContext context) {
    return Drawer(
      // Customizing drawer width
      width: MediaQuery.of(context).size.width * 0.75,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Text("FG", style: TextStyle(fontSize: 24, color: Colors.blue)),
            ),
            accountName: const Text("Flutter Gallery"),
            accountEmail: const Text("demo@example.com"),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          // Replaced Home with Draggable Drawer
          ListTile(
            leading: const Icon(Icons.drag_handle),
            title: const Text("Drawer Draggable"),
            onTap: () {
              Navigator.pop(context); // Close drawer first
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const DemoDrawerDraggable()),
              );
            },
          ),
          // Replaced Settings with Drawer Handler
          ListTile(
            leading: const Icon(Icons.touch_app),
            title: const Text("Drawer Draggable Handler"),
            onTap: () {
              Navigator.pop(context); // Close drawer first
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const DemoDrawerDraggableHandler()),
              );
            },
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Logout"),
            onTap: () {},
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildRightDrawer(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.filter_list, size: 60, color: Colors.grey),
            const SizedBox(height: 20),
            const Text("Filter Options", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("This is an endDrawer, often used for filters or secondary actions."),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDemoCard(List<Widget> buttons) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...buttons,
          ],
        ),
      ),
    );
  }
}
