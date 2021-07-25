import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tvs_application/Application/Dashboard/barChart.dart';
import '../../BL/PrescriptionBL.dart';
import '../../Model/Adherence.dart';
import '../../Model/Reminder.dart';
import '../../Model/Test.dart';
import '../../Model/User.dart';
import '../../Model/AdherenceChart.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DashboardPatientScreen extends StatefulWidget {
  final UserModel u;

  DashboardPatientScreen({this.u});

  @override
  _DashboardPatientScreenState createState() => _DashboardPatientScreenState();
}

class _DashboardPatientScreenState extends State<DashboardPatientScreen> {
  List<int> countTaken = [];
  List<int> countMissed = [];

  final double runSpacing = 4;
  final double spacing = 4;
  final int listSize = 4;
  final columns = 2;
  List<AdherenceChartModel> takenData = [];
  List<AdherenceChartModel> missedData = [];

  DateTime firstday;
  List<DateTime> week = [];

  final PrescriptionBL bl = PrescriptionBL();
  List<ReminderModel> reminderData = [];
  DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm");

  bool type1 = true;
  bool type2 = false;
  String typeSelected = "Viral Load";
  List<TestModel> testData = [];

  @override
  void initState() {
    firstday = findFirstDateOfTheWeek(DateTime.now());
    var day = firstday;
    for (var i = 0; i < 7; i++) {
      week.add(day);
      day = day.add(const Duration(days: 1));
    }
    super.initState();
  }

  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  void getDays() {
    setState(() {
      week.clear();
      var day = firstday;
      for (var i = 0; i < 7; i++) {
        week.add(day);
        day = day.add(const Duration(days: 1));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Dashboard',
            style: TextStyle(
                color: Color(0xff06224A),
                fontSize: 26,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: Color(0xff06224A),
          ),
        ),
        body: GestureDetector(
            child: Stack(children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Upcoming Appointment',
                          style: TextStyle(
                              color: Color(0xff06224A),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    StreamBuilder(
                      stream: bl.getPatientReminderStream(widget.u.uid),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.data == null) {
                          return Center(child: CircularProgressIndicator());
                        } else if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.data.docs.length == 0) {
                          return Center(
                            child: Text('There is no data.'),
                          );
                        } else {
                          reminderData = [];
                          for (int i = 0; i < snapshot.data.docs.length; i++) {
                            var data = snapshot.data.docs[i];
                            Timestamp time = data['date'];
                            DateTime d = time.toDate();
                            DateTime now = DateTime.now();
                            final differenceInDays = now.difference(d).inDays;
                            print(now.isBefore(d) && differenceInDays < 7);
                            if (now.isBefore(d) && differenceInDays < 7) {
                              ReminderModel r = ReminderModel(
                                  id: data.reference.id,
                                  details: data['details'],
                                  type: data['type'],
                                  location: data['location'],
                                  date: d,
                                  idNoti: data['idNoti']);
                              reminderData.add(r);
                            }
                          }
                          return ListView.builder(
                            itemCount: reminderData.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          Text(reminderData[index].type,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ]),
                                        SizedBox(height: 8),
                                        Text('Details: ' +
                                            reminderData[index].details),
                                        SizedBox(height: 8),
                                        Text('Location: ' +
                                            reminderData[index].location),
                                        SizedBox(height: 8),
                                        Text('Date: ' +
                                            dateFormat.format(
                                                reminderData[index].date)),
                                      ],
                                    )),
                              );
                            },
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    new Divider(color: Colors.black),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            iconSize: 28,
                            icon: Icon(Icons.arrow_left),
                            onPressed: () {
                              firstday =
                                  firstday.subtract(const Duration(days: 7));
                              getDays();
                            }),
                        Text(
                          'Intake per Week',
                          style: TextStyle(
                              color: Color(0xff06224A),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                            iconSize: 28,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            icon: Icon(Icons.arrow_right),
                            onPressed: () {
                              firstday = firstday.add(const Duration(days: 7));
                              getDays();
                            }),
                      ],
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('user')
                            .doc(widget.u.uid)
                            .collection('adherence')
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.data == null) {
                            return Center(child: CircularProgressIndicator());
                          } else if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.data.docs.length == 0) {
                            return Center(
                              child: Text('There is no data.'),
                            );
                          } else {
                            countTaken = [0, 0, 0, 0, 0, 0, 0];
                            countMissed = [0, 0, 0, 0, 0, 0, 0];

                            for (var i = 0;
                                i < snapshot.data.docs.length;
                                i++) {
                              AdherenceModel a = AdherenceModel();
                              a.takenDate =
                                  snapshot.data.docs[i]['takenDate'].toDate();
                              a.taken = snapshot.data.docs[i]['taken'];

                              for (var j = 0; j < 7; j++) {
                                if (a.takenDate.day == week[j].day &&
                                    a.takenDate.month == week[j].month &&
                                    a.takenDate.year == week[j].year) {
                                  if (a.taken) {
                                    countTaken[j] = 1 + countTaken[j];
                                  } else {
                                    countMissed[j] = 1 + countMissed[j];
                                  }
                                }
                              }
                            }
                            takenData = [];
                            missedData = [];
                            for (var i = 0; i < 7; i++) {
                              takenData.add(
                                AdherenceChartModel(
                                    takenDate: week[i],
                                    countTaken: countTaken[i],
                                    barColor: charts.ColorUtil.fromDartColor(
                                        Color(0xff06224A))),
                              );

                              missedData.add(AdherenceChartModel(
                                  takenDate: week[i],
                                  countTaken: countMissed[i],
                                  barColor: charts.ColorUtil.fromDartColor(
                                      Colors.red)));
                            }
                            return Container(
                              height: 300,
                              width: double.infinity,
                              padding: EdgeInsets.all(8),
                              child: Card(
                                  child: BarChartScreen(
                                      takenData: takenData,
                                      missedData: missedData)),
                            );
                          }
                        }),
                    SizedBox(height: 16),
                    new Divider(color: Colors.black),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(typeSelected + ' Test',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("user")
                            .doc(widget.u.uid)
                            .collection('test')
                            .orderBy('date', descending: true)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.data == null) {
                            return Center(child: CircularProgressIndicator());
                          } else if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.data.docs.length == 0) {
                            return Center(
                              child: Text('There is no data.'),
                            );
                          } else {
                            testData.clear();
                            for (int i = 0;
                                i < snapshot.data.docs.length;
                                i++) {
                              var data = snapshot.data.docs[i];

                              if (data['type'] == typeSelected) {
                                Timestamp time = data['date'];
                                DateTime d = time.toDate();
                                TestModel t = TestModel(
                                    id: data.reference.id,
                                    result: data['result'],
                                    date: d,
                                    location: data['location']);
                                testData.add(t);
                              }
                            }
                            return Column(children: [
                              Container(
                                height: 300,
                                child: InkWell(
                                  child: Card(
                                    elevation: 4,
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 8),
                                        child: testData.length == 0
                                            ? Center(
                                                child:
                                                    Text('There is no data.'),
                                              )
                                            : charts.TimeSeriesChart(
                                                _createSampleData(testData),
                                                animate: true,
                                                dateTimeFactory: const charts
                                                    .LocalDateTimeFactory(),
                                              )),
                                  ),
                                ),
                              ),
                            ]);
                          }
                        }),
                    Container(
                        child: Wrap(
                      spacing: 5.0,
                      runSpacing: 10.0,
                      children: <Widget>[
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2.0),
                              child: ChoiceChip(
                                  elevation: 3.0,
                                  label: Text('Viral Load'),
                                  labelStyle: TextStyle(
                                      color: type1 == true
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  backgroundColor: Colors.white,
                                  selectedColor: Color(0xff06224A),
                                  selected: typeSelected == 'Viral Load',
                                  onSelected: (selected) {
                                    setState(() {
                                      if (typeSelected != 'Viral Load') {
                                        setState(() {
                                          type1 = selected;
                                          type2 = !selected;
                                        });
                                      }
                                      typeSelected = 'Viral Load';
                                    });
                                  }),
                            ),
                            Container(
                              padding: const EdgeInsets.all(2.0),
                              child: ChoiceChip(
                                  elevation: 3.0,
                                  label: Text('CD4 Count'),
                                  labelStyle: TextStyle(
                                      color: type2 == true
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  backgroundColor: Colors.white,
                                  selectedColor: Color(0xff06224A),
                                  selected: typeSelected == 'CD4 Count',
                                  onSelected: (selected) {
                                    setState(() {
                                      if (typeSelected != 'CD4 Count') {
                                        setState(() {
                                          type2 = selected;
                                          type1 = !selected;
                                        });
                                      }
                                      typeSelected = 'CD4 Count';
                                    });
                                  }),
                            ),
                          ],
                        )
                      ],
                    ))
                  ]),
            ),
          )
        ])));
  }

  List<charts.Series<TestModel, DateTime>> _createSampleData(
      List<TestModel> t) {
    return [
      new charts.Series<TestModel, DateTime>(
        id: 'Test',
        colorFn: (_, __) => charts.Color(r: 6, g: 34, b: 74),
        domainFn: (TestModel test, _) => test.date,
        measureFn: (TestModel test, _) => int.parse(test.result),
        data: t,
      )
    ];
  }
}
