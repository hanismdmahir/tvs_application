import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:g2x_week_calendar/g2x_simple_week_calendar.dart';
import 'package:tvs_application/Application/Prescription/adherenceadd.dart';
import 'package:tvs_application/BL/PrescriptionBL.dart';
import 'package:tvs_application/Model/Adherence.dart';
import 'package:intl/intl.dart';

class AdherenceMainScreen extends StatefulWidget {
  @override
  _AdherenceMainScreenState createState() => _AdherenceMainScreenState();
}

class _AdherenceMainScreenState extends State<AdherenceMainScreen> {
  final PrescriptionBL bl = PrescriptionBL();
  List<AdherenceModel> takenList = [];
  List<AdherenceModel> missedList = [];
  DateFormat dateFormat = DateFormat("dd-MM-yyyy");
  DateTime dateCallback = DateTime.now();

  _dateCallback(DateTime date) {
    setState(() {
      dateCallback = date;
      print(dateCallback);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Adherence',
          style: TextStyle(
              color: Color(0xff06224A),
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Color(0xff06224A),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          G2xSimpleWeekCalendar(
            60.0,
            DateTime.now(),
            format: 'dd/MM/yyyy',
            dateCallback: (date) => _dateCallback(date),
            typeCollapse: false,
            defaultTextStyle: TextStyle(color: Colors.white),
            //selectedTextStyle: ,
            backgroundDecoration: new BoxDecoration(color: Color(0xff06224A)),
          ),
          SizedBox(
            height: 16,
          ),
          StreamBuilder(
              stream: bl.getIntakeStream(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.data.docs.length == 0) {
                  return Center(
                    child: Text('There is no data.'),
                  );
                } else {
                  takenList.clear();
                  missedList.clear();

                  var data = snapshot.data;
                  for (var i = 0; i < data.docs.length; i++) {
                    var data = snapshot.data.docs[i];
                    Timestamp time = data['takenDate'];
                    DateTime d = time.toDate();
                    var dateNow = dateFormat.format(dateCallback);
                    var dateData = dateFormat.format(d);

                    if (dateNow == dateData) {
                      AdherenceModel intake = AdherenceModel(
                          id: data.reference.id,
                          medName: data['medName'],
                          taken: data['taken'],
                          takenDate: d);

                      if (intake.taken) {
                        takenList.add(intake);
                        print('1');
                      } else {
                        missedList.add(intake);
                        print('0');
                      }
                    }
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 12,
                          ),
                          Text('TAKEN :',
                              style: TextStyle(
                                  color: Color(0xff0245A3),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount:
                              takenList.length == 0 ? 1 : takenList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return takenList.length != 0
                                ? Dismissible(
                                    key: UniqueKey(),
                                    child: Card(
                                      child: ListTile(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  new AdherenceAddScreen(
                                                    add: false,
                                                    intake: takenList[index],
                                                  ));
                                        },
                                        title: Text(takenList[index].medName),
                                      ),
                                    ),
                                    onDismissed:
                                        (DismissDirection direction) async {
                                      await bl.deleteIntake(takenList[index]);
                                    },
                                    confirmDismiss:
                                        (DismissDirection direction) async {
                                      return await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Delete"),
                                            content: const Text(
                                                "Do you wish to delete the intake record ?"),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                                child: const Text("Cancel"),
                                              ),
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                  child: const Text(
                                                    "Delete",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  )),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    secondaryBackground: Container(
                                      alignment: AlignmentDirectional.centerEnd,
                                      child: Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ),
                                      color: Colors.red,
                                    ),
                                    background: Container(),
                                    direction: DismissDirection.endToStart,
                                  )
                                : Center(
                                    child: Text('There is no data.'),
                                  );
                          },
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 12,
                          ),
                          Text('MISSED :',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount:
                              missedList.length == 0 ? 1 : missedList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return missedList.length != 0
                                ? Dismissible(
                                    key: UniqueKey(),
                                    child: Card(
                                      child: ListTile(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  new AdherenceAddScreen(
                                                    add: false,
                                                    intake: missedList[index],
                                                  ));
                                        },
                                        title: Text(missedList[index].medName),
                                      ),
                                    ),
                                    onDismissed:
                                        (DismissDirection direction) async {
                                      await bl.deleteIntake(missedList[index]);
                                    },
                                    confirmDismiss:
                                        (DismissDirection direction) async {
                                      return await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Delete"),
                                            content: const Text(
                                                "Do you wish to delete the intake record ?"),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                                child: const Text("Cancel"),
                                              ),
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                  child: const Text(
                                                    "Delete",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  )),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    secondaryBackground: Container(
                                      alignment: AlignmentDirectional.centerEnd,
                                      child: Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ),
                                      color: Colors.red,
                                    ),
                                    background: Container(),
                                    direction: DismissDirection.endToStart,
                                  )
                                : Center(
                                    child: Text('There is no data.'),
                                  );
                          },
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                        ),
                      ),
                    ],
                  );
                }
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff06224A),
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => new AdherenceAddScreen(
                    add: true,
                  ));
        },
        tooltip: 'Add new adherence',
      ),
    );
  }
}
