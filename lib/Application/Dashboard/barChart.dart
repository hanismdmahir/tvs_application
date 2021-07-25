import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:tvs_application/Model/AdherenceChart.dart';

class BarChartScreen extends StatefulWidget {
  final List<AdherenceChartModel> takenData;
  final List<AdherenceChartModel> missedData;

  BarChartScreen({this.missedData, this.takenData});

  @override
  _BarChartScreenState createState() => _BarChartScreenState();
}

class _BarChartScreenState extends State<BarChartScreen> {
  @override
  Widget build(BuildContext context) {
    List<charts.Series<AdherenceChartModel, String>> series = [
      charts.Series(
          id: 'Taken',
          data: widget.takenData,
          domainFn: (AdherenceChartModel a, _) =>
              a.takenDate.day.toString() + '/' + a.takenDate.month.toString(),
          measureFn: (AdherenceChartModel a, _) => a.countTaken,
          colorFn: (AdherenceChartModel a, _) => a.barColor),
      charts.Series(
          id: 'Missed',
          data: widget.missedData,
          domainFn: (AdherenceChartModel a, _) =>
              a.takenDate.day.toString() + '/' + a.takenDate.month.toString(),
          measureFn: (AdherenceChartModel a, _) => a.countTaken,
          colorFn: (AdherenceChartModel a, _) => a.barColor)
    ];

    return charts.BarChart(
      series,
      animate: false,
      barGroupingType: charts.BarGroupingType.stacked,
      behaviors: [new charts.SeriesLegend()],
    );
  }
}
