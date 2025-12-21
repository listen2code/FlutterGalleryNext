import 'package:flutter/material.dart';

class DemoTabScrollable extends StatelessWidget {
  const DemoTabScrollable({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(icon: Icon(Icons.directions_car), text: 'Car'),
              Tab(icon: Icon(Icons.directions_transit), text: 'Transit'),
              Tab(icon: Icon(Icons.directions_bike), text: 'Bike'),
              Tab(icon: Icon(Icons.directions_boat), text: 'Boat'),
              Tab(icon: Icon(Icons.directions_walk), text: 'Walk'),
              Tab(icon: Icon(Icons.airplanemode_active), text: 'Plane'),
              Tab(icon: Icon(Icons.train), text: 'Train'),
              Tab(icon: Icon(Icons.tram), text: 'Tram'),
            ],
          ),
          title: const Text('tab scrollable'),
        ),
        body: const TabBarView(
          children: [
            Icon(Icons.directions_car),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
            Icon(Icons.directions_boat),
            Icon(Icons.directions_walk),
            Icon(Icons.airplanemode_active),
            Icon(Icons.train),
            Icon(Icons.tram),
          ],
        ),
      ),
    );
  }
}
