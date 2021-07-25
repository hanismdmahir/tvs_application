import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tvs_application/Application/Chat/chatPN.dart';
import 'package:tvs_application/BL/AccountBL.dart';
import 'package:tvs_application/Model/User.dart';

import 'dashboardPatient.dart';

class DashboardMenuScreen extends StatefulWidget {
  final UserModel u;

  DashboardMenuScreen({this.u});
  @override
  _DashboardMenuScreenState createState() => _DashboardMenuScreenState();
}

class _DashboardMenuScreenState extends State<DashboardMenuScreen> {
  final AccountBL bl = AccountBL();
  List<UserModel> patientList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'List Of Patients',
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
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            StreamBuilder(
                                stream: bl.getPatientListStream(widget.u),
                                builder: (context,
                                    AsyncSnapshot<
                                            QuerySnapshot<Map<String, dynamic>>>
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
                                    patientList.clear();
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.data.docs.length,
                                        itemBuilder: (context, index) {
                                          var data = snapshot.data.docs[index];
                                          UserModel patient = UserModel(
                                              username: data['username'],
                                              email: data['username'],
                                              uid: data['uid'],
                                              refferalId: data['code'],
                                              patient: data['patient']);
                                          patientList.add(patient);
                                          return Card(
                                            elevation: 5,
                                            child: ListTile(
                                              title: Text(
                                                  patientList[index].username),
                                              trailing: Wrap(
                                                spacing:
                                                    16, // space between two icons
                                                children: <Widget>[
                                                  IconButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    new DashboardPatientScreen(
                                                                      u: patientList[
                                                                          index],
                                                                    )));
                                                      },
                                                      icon:
                                                          Icon(Icons.insights)),
                                                  IconButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    new ChatPNScreen(
                                                                      u: patientList[
                                                                          index],
                                                                      pnId: widget
                                                                          .u
                                                                          .uid,
                                                                    )));
                                                      },
                                                      icon: Icon(Icons.chat)),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  }
                                }),
                          ],
                        ),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
