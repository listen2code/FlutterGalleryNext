import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MaterialApp(
    home: ChartMain(),
    debugShowCheckedModeBanner: false,
  ));
}

class ChartMain extends StatefulWidget {
  const ChartMain({super.key});

  @override
  State<ChartMain> createState() => _ChartMainState();
}

class _ChartMainState extends State<ChartMain> {
  late List<_ChartData> _chartData;

  @override
  void initState() {
    _chartData = _generateLast12MonthsData();
    super.initState();
  }

  List<_ChartData> _generateLast12MonthsData() {
    final DateTime now = DateTime.now();
    return List.generate(12, (index) {
      final DateTime date = DateTime(now.year, now.month - (11 - index), 1);

      final double y1 = 30.0 + (index * 2) + (index % 3 == 0 ? 5 : -2);
      final double y2 = 20.0 + (index * 1.5) + (index % 2 == 0 ? 3 : 0);

      final double yStep = 15.0 + (index * 5) + (index % 3 == 0 ? 15 : (index % 3 == 1 ? -8 : 2));

      return _ChartData(date, y1, y2, yStep);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Chart Demo'),
      ),
      body: Center(
        child: Container(
          height: 400,
          padding: const EdgeInsets.all(16),
          child: SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat('yy/MM'),
              intervalType: DateTimeIntervalType.months,
              interval: 1,
              majorGridLines: const MajorGridLines(width: 0),
            ),
            title: const ChartTitle(text: 'Last 12 Months Performance'),
            legend: const Legend(isVisible: true, position: LegendPosition.bottom),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries<_ChartData, DateTime>>[
              AreaSeries<_ChartData, DateTime>(
                name: 'Product A',
                dataSource: _chartData,
                xValueMapper: (_ChartData data, _) => data.x,
                yValueMapper: (_ChartData data, _) => data.y1,
                color: Colors.blue.withOpacity(0.3),
                borderColor: Colors.blue,
                borderWidth: 2,
              ),
              AreaSeries<_ChartData, DateTime>(
                name: 'Product B',
                dataSource: _chartData,
                xValueMapper: (_ChartData data, _) => data.x,
                yValueMapper: (_ChartData data, _) => data.y2,
                color: Colors.green.withOpacity(0.3),
                borderColor: Colors.green,
                borderWidth: 2,
              ),
              StepLineSeries<_ChartData, DateTime>(
                name: 'Target',
                dataSource: _chartData,
                xValueMapper: (_ChartData data, _) => data.x,
                yValueMapper: (_ChartData data, _) => data.yStep,
                color: Colors.red,
                width: 3,
                dashArray: const <double>[5, 5],
                markerSettings: const MarkerSettings(isVisible: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y1, this.y2, this.yStep);
  final DateTime x;
  final double y1;
  final double y2;
  final double yStep;
}
