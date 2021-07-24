import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tvs_application/Application/Record_Test/testadd.dart';
import 'package:tvs_application/BL/TestBL.dart';
import 'package:tvs_application/Model/Test.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final TestBL bl = TestBL();
  bool type1 = true;
  bool type2 = false;
  String typeSelected = "Viral Load";
  List<TestModel> testData = [];

  Widget buildType() {
    return Container(
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
                      color: type1 == true ? Colors.white : Colors.black,
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
                      color: type2 == true ? Colors.white : Colors.black,
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
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Color(0xff06224A),
        ),
        title: Text(
          'Test',
          style: TextStyle(
              color: Color(0xff06224A),
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
          child: Stack(children: <Widget>[
        Container(
            child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
              height: 10,
            ),
            buildType(),
            SizedBox(
              height: 8,
            ),
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
                stream: bl.getTestStream(),
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
                    for (int i = 0; i < snapshot.data.docs.length; i++) {
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
                                        child: Text('There is no data.'),
                                      )
                                    : charts.TimeSeriesChart(
                                        _createSampleData(testData),
                                        animate: true,
                                        dateTimeFactory:
                                            const charts.LocalDateTimeFactory(),
                                      )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      ListView.builder(
                        itemCount: testData.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Dismissible(
                              key: UniqueKey(),
                              child: Card(
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                new TestAddScreen(
                                                  type: typeSelected,
                                                  add: false,
                                                  test: testData[index],
                                                )));
                                  },
                                  isThreeLine: true,
                                  title: Text(testData[index].result +
                                      ' ' +
                                      (typeSelected == 'Viral Load'
                                          ? 'copies/mL'
                                          : 'cell/µL')),
                                  subtitle: Text('Date: ' +
                                      testData[index].date.day.toString() +
                                      '/' +
                                      testData[index].date.month.toString() +
                                      '/' +
                                      testData[index].date.year.toString() +
                                      '\nLocation: ' +
                                      testData[index].location),
                                ),
                              ),
                              onDismissed: (DismissDirection direction) async {
                                await bl.deleteTest(testData[index]);
                              },
                              confirmDismiss:
                                  (DismissDirection direction) async {
                                return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Delete"),
                                      content: const Text(
                                          "Do you wish to delete the test result ?"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: const Text(
                                              "Delete",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )),
                                      ],
                                    );
                                  },
                                );
                              },
                              secondaryBackground: Container(
                                alignment: AlignmentDirectional.centerEnd,
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                color: Colors.red,
                              ),
                              background: Container(),
                              direction: DismissDirection.endToStart,
                            ),
                          );
                        },
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                      ),
                    ]);
                  }
                }),
          ]),
        )),
        SizedBox(
          height: 16,
        ),
      ])),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff06224A),
        onPressed: () {
          TestModel t = TestModel();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => new TestAddScreen(
                        type: typeSelected,
                        add: true,
                        test: t,
                      )));
        },
        child: Icon(Icons.add, color: Colors.white),
        tooltip: 'Add New Test Result',
      ),
    );
  }

  /// Create one series with sample hard coded data.
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
