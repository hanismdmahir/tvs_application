import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tvs_application/Model/Prescription.dart';
import 'adherence.dart';
import 'allergy.dart';
import 'prescriptionadd.dart';

class PrescriptionMain extends StatefulWidget {
  @override
  _PrescriptionMainScreenState createState() => _PrescriptionMainScreenState();
}

class _PrescriptionMainScreenState extends State<PrescriptionMain> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("user")
            .doc(auth.currentUser.uid)
            .collection('prescription')
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(
                  color: Color(0xff06224A), //change your color here
                ),
                title: Text(
                  'Prescription',
                  style: TextStyle(
                      color: Color(0xff06224A),
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                actions: [
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Text("Adherence"),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text("Allergy"),
                      ),
                    ],
                    offset: Offset(0, 45),
                    onSelected: (value) {
                      if (value == 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AdherenceMainScreen()));
                      } else if (value == 2) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AllergyScreen()));
                      }
                    },
                  )
                ],
              ),
              body: GestureDetector(
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var prescription = snapshot.data.docs[index];
                                  return Dismissible(
                                    child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
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
                                                  Text(
                                                      prescription[
                                                          'med\'s name'],
                                                      style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                ]),
                                                Text(prescription['quantity']
                                                        .toString() +
                                                    ' ' +
                                                    prescription['type'] +
                                                    ' (' +
                                                    prescription['strength'] +
                                                    'mg) '),
                                                Text('Take ' +
                                                    prescription['taken'] +
                                                    ' in ' +
                                                    prescription['time']),
                                              ],
                                            )),
                                        onLongPress: () {
                                          PrescriptionModel p =
                                              PrescriptionModel();
                                          p.id = prescription.reference.id;
                                          p.medname =
                                              prescription['med\'s name'];
                                          p.quantity = prescription['quantity'];
                                          p.type = prescription['type'];
                                          p.strength = prescription['strength'];
                                          p.taken = prescription['taken'];
                                          p.time = prescription['time'];

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          new PrescriptionAdd(
                                                              false, p)));
                                        },
                                      ),
                                    ),
                                    key: UniqueKey(),
                                    onDismissed:
                                        (DismissDirection direction) async {
                                      print('deleted' +
                                          prescription.reference.id);
                                      await FirebaseFirestore.instance
                                          .collection("user")
                                          .doc(auth.currentUser.uid)
                                          .collection('prescription')
                                          .doc(prescription.reference.id)
                                          .delete();
                                    },
                                    confirmDismiss:
                                        (DismissDirection direction) async {
                                      return await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Delete"),
                                            content: const Text(
                                                "Do you wish to delete the prescription ?"),
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
                              ),
                            ],
                          )),
                    )
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Color(0xff06224A),
                onPressed: () {
                  PrescriptionModel p = PrescriptionModel();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new PrescriptionAdd(true, p)));
                },
                child: Icon(Icons.add, color: Colors.white),
                tooltip: 'Add New Prescription',
              ),
            );
          }
        });
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////