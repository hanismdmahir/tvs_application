import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'infoadd.dart';
import 'infodetails.dart';

class ListInfoPNScreen extends StatefulWidget {
  @override
  _ListInfoPNScreenState createState() => _ListInfoPNScreenState();
}

class _ListInfoPNScreenState extends State<ListInfoPNScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool patient = true;


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection("information").snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  'Information',
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
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            var infos = snapshot.data.docs[index];

                            return buildDismissibleInfo(infos, context);
                          }),
                      SizedBox(height: 60.0)
                    ]),
                  ),
                ),
              ])),
              floatingActionButton: FloatingActionButton(
                      backgroundColor: Color(0xff06224A),
                      child: Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AddInfoScreen()));
                      },
                      tooltip: 'Add new Information',
                    ),
            );
          }
        });
  }

  Dismissible buildDismissibleInfo(
      QueryDocumentSnapshot<Map<String, dynamic>> infos, BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (DismissDirection direction) async {
        await FirebaseFirestore.instance
            .collection('information')
            .doc(infos.reference.id)
            .delete();
        print('deleted' + infos.reference.id);
      },
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Delete"),
              content: const Text("Do you wish to delete the information ?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
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
      child: buildListInfo(infos, context),
    );
  }

  Card buildListInfo(
      QueryDocumentSnapshot<Map<String, dynamic>> infos, BuildContext context) {
    return Card(
      elevation: 0.2,
      child: ExpansionTile(
        title: Text(infos['title']),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Flexible(
                  child: Text(infos['summary'],
                      style: TextStyle(), softWrap: true)),
              SizedBox(
                height: 8,
              )
            ]),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            IconButton(
              icon: Icon(Icons.launch),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            InfoDetailsScreen(infos['title'], infos['url'])));
              }, /* Incorporating Web View into Your App (The Boring Flutter Development Show, Ep. 14) (23.09) */
            ),
          ])
        ],
      ),
    );
  }
}
