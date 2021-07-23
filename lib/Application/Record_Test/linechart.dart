// Timeseries chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:tvs_application/Model/Test.dart';

class LineChart extends StatefulWidget {
  final List<TestModel> testData;

  LineChart(this.testData);

  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  List<charts.Series> series;

  @override
  void initState() { 

    series = [
      new charts.Series<TestModel, DateTime>(
        id: 'Test',
        colorFn: (_, __) => charts.Color(r: 6, g: 34, b: 74),
        domainFn: (TestModel test, _) => test.date,
        measureFn: (TestModel test, _) => int.parse(test.result),
        data: widget.testData,
      )
    ];
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      series, 
      animate: true,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

}
