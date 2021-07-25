import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:tvs_application/Application/Reminder/reminderadd.dart';
import 'package:tvs_application/BL/PrescriptionBL.dart';
import 'package:tvs_application/Model/Prescription.dart';
import 'package:tvs_application/Model/Reminder.dart';
import 'package:tvs_application/main.dart';
import 'package:intl/intl.dart';

class ReminderMainScreen extends StatefulWidget {
  @override
  _ReminderMainScreenState createState() => _ReminderMainScreenState();
}

class _ReminderMainScreenState extends State<ReminderMainScreen> {
  final PrescriptionBL bl = PrescriptionBL();
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<String> time = ['Morning', 'Noon', 'Evening', 'Night'];
  List<ReminderModel> reminderData = [];
  DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm");
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  List<PrescriptionModel> Morning = [];
  List<PrescriptionModel> Noon = [];
  List<PrescriptionModel> Evening = [];
  List<PrescriptionModel> Night = [];

  @override
  void initState() {
    initializeSetting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Reminder',
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
      body: Stack(children: [
        PageView(
            controller: _pageController,
            children: <Widget>[medicineScreen(), appointmentScreen()],
            onPageChanged: (int index) {
              setState(() {
                _currentPageNotifier.value = index;
              });
            }),
        Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CirclePageIndicator(
              dotColor: Colors.blueGrey,
              selectedDotColor: Color(0xff06224A),
              itemCount: 2,
              currentPageNotifier: _currentPageNotifier,
            ),
          ),
        )
      ]),
      floatingActionButton: _currentPageNotifier.value == 0
          ? Container()
          : FloatingActionButton(
              backgroundColor: Color(0xff06224A),
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new ReminderAddScreen(
                              add: true,
                            )));
              },
              tooltip: 'Add new Appointment',
            ),
    );
  }

  Widget medicineScreen() {
    return GestureDetector(
        child: Stack(children: <Widget>[
      Container(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Medicine',
                  style: TextStyle(
                      color: Color(0xff06224A),
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("user")
                        .doc(auth.currentUser.uid)
                        .collection('prescription')
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
                        Morning.clear();
                        Noon.clear();
                        Evening.clear();
                        Night.clear();

                        for (var i = 0; i < snapshot.data.docs.length; i++) {
                          var data = snapshot.data.docs[i];
                          PrescriptionModel p = PrescriptionModel(
                              medname: data['med\'s name'],
                              quantity: data['quantity'],
                              type: data['type'],
                              time: data['time'],
                              taken: data['taken']);

                          if (p.time.contains(',')) {
                            List<String> ptime = p.time.split(',');

                            for (var i = 0; i < ptime.length; i++) {
                              if (ptime[i] == 'Morning') {
                                Morning.add(p);
                              } else if (ptime[i] == 'Noon') {
                                Noon.add(p);
                              } else if (ptime[i] == 'Evening') {
                                Evening.add(p);
                              } else {
                                Night.add(p);
                              }
                            }
                          } else {
                            if (p.time == 'Morning') {
                              Morning.add(p);
                            } else if (p.time == 'Noon') {
                              Noon.add(p);
                            } else if (p.time == 'Evening') {
                              Evening.add(p);
                            } else {
                              Night.add(p);
                            }
                          }
                        }

                        return ListView(
                          shrinkWrap: true,
                          children: [
                            Morning.length != 0
                                ? Card(
                                    margin: EdgeInsets.only(bottom: 25.0),
                                    elevation: 1,
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(children: [
                                          Text(time[0].toUpperCase(),
                                              style: TextStyle(
                                                  color: Color(0xff0245A3),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(height: 10),
                                          ListView.separated(
                                              shrinkWrap: true,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return ListTile(
                                                  title: Text(
                                                      Morning[index].medname),
                                                  subtitle: Text(Morning[index]
                                                          .quantity
                                                          .toString() +
                                                      ' ' +
                                                      Morning[index].type +
                                                      ' ' +
                                                      Morning[index].taken),
                                                );
                                              },
                                              separatorBuilder:
                                                  (BuildContext context,
                                                          int index) =>
                                                      const Divider(
                                                        thickness: 0.2,
                                                        color: Colors.grey,
                                                      ),
                                              itemCount: Morning.length)
                                        ])),
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: 16,
                            ),
                            Noon.length != 0
                                ? Card(
                                    margin: EdgeInsets.only(bottom: 25.0),
                                    elevation: 1,
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(children: [
                                          Text(time[1].toUpperCase(),
                                              style: TextStyle(
                                                  color: Color(0xff0245A3),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(height: 10),
                                          ListView.separated(
                                              shrinkWrap: true,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return ListTile(
                                                  title:
                                                      Text(Noon[index].medname),
                                                  subtitle: Text(Noon[index]
                                                          .quantity
                                                          .toString() +
                                                      ' ' +
                                                      Noon[index].type +
                                                      ' ' +
                                                      Noon[index].taken),
                                                );
                                              },
                                              separatorBuilder:
                                                  (BuildContext context,
                                                          int index) =>
                                                      const Divider(
                                                        thickness: 0.2,
                                                        color: Colors.grey,
                                                      ),
                                              itemCount: Noon.length)
                                        ])),
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: 16,
                            ),
                            Evening.length != 0
                                ? Card(
                                    margin: EdgeInsets.only(bottom: 25.0),
                                    elevation: 1,
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(children: [
                                          Text(time[2].toUpperCase(),
                                              style: TextStyle(
                                                  color: Color(0xff0245A3),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(height: 10),
                                          ListView.separated(
                                              shrinkWrap: true,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return ListTile(
                                                  title: Text(
                                                      Evening[index].medname),
                                                  subtitle: Text(Evening[index]
                                                          .quantity
                                                          .toString() +
                                                      ' ' +
                                                      Evening[index].type +
                                                      ' ' +
                                                      Evening[index].taken),
                                                );
                                              },
                                              separatorBuilder:
                                                  (BuildContext context,
                                                          int index) =>
                                                      const Divider(
                                                        thickness: 0.2,
                                                        color: Colors.grey,
                                                      ),
                                              itemCount: Evening.length)
                                        ])),
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: 16,
                            ),
                            Night.length != 0
                                ? Card(
                                    margin: EdgeInsets.only(bottom: 25.0),
                                    elevation: 1,
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(children: [
                                          Text(time[3].toUpperCase(),
                                              style: TextStyle(
                                                  color: Color(0xff0245A3),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(height: 10),
                                          ListView.separated(
                                              shrinkWrap: true,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return ListTile(
                                                  title: Text(
                                                      Night[index].medname),
                                                  subtitle: Text(Night[index]
                                                          .quantity
                                                          .toString() +
                                                      ' ' +
                                                      Night[index].type +
                                                      ' ' +
                                                      Night[index].taken),
                                                );
                                              },
                                              separatorBuilder:
                                                  (BuildContext context,
                                                          int index) =>
                                                      const Divider(
                                                        thickness: 0.2,
                                                        color: Colors.grey,
                                                      ),
                                              itemCount: Night.length)
                                        ])),
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: 16,
                            ),
                          ],
                        );
                      }
                    }),
              ]),
            ),
            SizedBox(
              height: 8,
            ),
          ]),
        ),
      )
    ]));
  }

  Widget appointmentScreen() {
    return GestureDetector(
      child: Stack(
        children: [
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
                        'Appointment',
                        style: TextStyle(
                            color: Color(0xff06224A),
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  StreamBuilder(
                    stream: bl.getReminderStream(),
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
                          print(DateTime.now().isBefore(d));
                          if (DateTime.now().isBefore(d)) {
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
                            return Dismissible(
                              key: UniqueKey(),
                              child: Card(
                                child: InkWell(
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
                                                  fontSize: 22,
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
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                new ReminderAddScreen(
                                                  add: false,
                                                  reminder: reminderData[index],
                                                )));
                                  },
                                ),
                              ),
                              onDismissed: (DismissDirection direction) async {
                                await notificationsPlugin
                                    .cancel(reminderData[index].idNoti);
                                await bl.deleteReminder(reminderData[index]);
                              },
                              confirmDismiss:
                                  (DismissDirection direction) async {
                                return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Delete"),
                                      content: const Text(
                                          "Do you wish to delete the appointment reminder ?"),
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
                            );
                          },
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
