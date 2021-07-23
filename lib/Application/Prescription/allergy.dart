import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AllergyScreen extends StatefulWidget {
  @override
  _AllergyScreenState createState() => _AllergyScreenState();
}

class _AllergyScreenState extends State<AllergyScreen> {
  TextEditingController _allergy = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  Widget buildAllergy() {
    return Expanded(
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
            ]),
        height: 50,
        child: TextFormField(
          controller: _allergy,
          validator: (value) {
            return value.isNotEmpty ? null : "Enter the allergy";
          },
          style: TextStyle(color: Colors.black87),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            hintText: 'Allergy',
            hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget buildAddButton() {
    return InkWell(
      onTap: () async {
        if (_allergy.text != '') {
          await firestore
              .collection("user")
              .doc(auth.currentUser.uid)
              .collection("allergy")
              .doc()
              .set({'allergy': _allergy.text});

          _allergy.text = '';
        } else {
          print('null');
        }
      },
      child: Container(
          color: Color(0xff06224A),
          height: 50.0,
          width: 50.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Colors.white,
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Allergy',
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
      body: GestureDetector(
          child: Stack(children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildAllergy(),
                    SizedBox(width: 10),
                    buildAddButton()
                  ],
                ),
              ),
              SizedBox(height: 18),
              StreamBuilder(
                  stream: firestore
                      .collection("user")
                      .doc(auth.currentUser.uid)
                      .collection('allergy')
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            var allergy = snapshot.data.docs[index];

                            return Dismissible(
                              key: UniqueKey(),
                              onDismissed: (DismissDirection direction) async {
                                print('deleted' + allergy.reference.id);

                                await FirebaseFirestore.instance
                                    .collection("user")
                                    .doc(auth.currentUser.uid)
                                    .collection('allergy')
                                    .doc(allergy.reference.id)
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
                                          "Do you wish to delete the allergy ?"),
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
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                color: Colors.red,
                              ),
                              background: Container(),
                              direction: DismissDirection.endToStart,
                              child: Card(
                                child: ListTile(
                                  title: Text(allergy['allergy']),
                                ),
                              ),
                            );
                          });
                    }
                  }),
              SizedBox(height: 60.0)
            ]),
          ),
        ),
      ])),
    );
  }
}
