import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class ReminderMainScreen extends StatefulWidget {
  @override
  _ReminderMainScreenState createState() => _ReminderMainScreenState();
}

class _ReminderMainScreenState extends State<ReminderMainScreen> {
  
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<String> time = ['Morning', 'Noon', 'Evening', 'Night'];

  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);

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
            children: <Widget>[
              medicineScreen(),
              appointmentScreen()
            ],
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
              onPressed: () {},
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
                        child: ExpansionTile(
                          title: Text(time[index]),
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(children: [
                                  StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                            .collection("user")
                                            .doc(auth.currentUser.uid)
                                            .collection('prescription').where('time',isEqualTo: time[index])
                                            .snapshots(),
                                    builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>  snapshot) {
                                      if (!snapshot.hasData) {
                                        return Center(child: CircularProgressIndicator());
                                      }
                                      else{
                                        return ListView.separated(
                                          shrinkWrap: true,
                                            itemBuilder:
                                                (BuildContext context, int index) {
                                                  var prescription = snapshot.data.docs[index];
                                              return ListTile(
                                                title: Text(prescription['med\'s name']),
                                                subtitle: Text(prescription['quantity'].toString() +' '+prescription['type']),
                                              );
                                            },
                                            separatorBuilder:
                                                (BuildContext context, int index) =>
                                                    const Divider(thickness: 0.2, color:Color(0xff06224A) ,),
                                            itemCount: snapshot.data.docs.length);
                                      }
                                    }
                                  ),
                                ])),
                          ],
                        ),
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
    return SingleChildScrollView(
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
        ],
      ),
    );
  }
}
