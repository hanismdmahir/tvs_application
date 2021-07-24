import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:tvs_application/Application/Reminder/reminderadd.dart';
import 'package:tvs_application/BL/PrescriptionBL.dart';
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
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.only(bottom: 25.0),
                        elevation: 0.5,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              Text(time[index].toUpperCase(),
                                  style: TextStyle(
                                      color: Color(0xff0245A3),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("user")
                                      .doc(auth.currentUser.uid)
                                      .collection('prescription')
                                      .where('time', isEqualTo: time[index])
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<
                                              QuerySnapshot<
                                                  Map<String, dynamic>>>
                                          snapshot) {
                                    if (snapshot.data == null) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (!snapshot.hasData) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.data.docs.length == 0) {
                                      return Center(
                                        child: Text('There is no data.'),
                                      );
                                    } else {
                                      return ListView.separated(
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            var prescription =
                                                snapshot.data.docs[index];
                                            return ListTile(
                                              title: Text(
                                                  prescription['med\'s name']),
                                              subtitle: Text(
                                                  prescription['quantity']
                                                          .toString() +
                                                      ' ' +
                                                      prescription['type']),
                                            );
                                          },
                                          separatorBuilder:
                                              (BuildContext context,
                                                      int index) =>
                                                  const Divider(
                                                    thickness: 0.2,
                                                    color: Colors.grey,
                                                  ),
                                          itemCount: snapshot.data.docs.length);
                                    }
                                  }),
                            ])),
                      );
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
                        reminderData.clear();
                        for (int i = 0; i < snapshot.data.docs.length; i++) {
                          var data = snapshot.data.docs[i];
                          Timestamp time = data['date'];
                          DateTime d = time.toDate();
                          ReminderModel r = ReminderModel(
                            id: data.reference.id,
                            details: data['details'],
                            type: data['type'],
                            location: data['location'],
                            date: d,
                            idNoti: data['idNoti']
                          );
                          reminderData.add(r);
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
                                await notificationsPlugin.cancel(reminderData[index].idNoti);
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
