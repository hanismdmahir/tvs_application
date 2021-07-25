import 'package:charts_flutter/flutter.dart' as charts;

class AdherenceChartModel {
  int countTaken;
  DateTime takenDate;
  charts.Color barColor;

  AdherenceChartModel({this.countTaken, this.takenDate, this.barColor});
}
