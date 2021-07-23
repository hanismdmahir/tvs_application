import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'infodetails.dart';

class ListInfoScreen extends StatefulWidget {
  @override
  _ListInfoScreenState createState() => _ListInfoScreenState();
}

class _ListInfoScreenState extends State<ListInfoScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

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

                            return buildListInfo(infos, context);
                          }),
                      SizedBox(height: 60.0)
                    ]),
                  ),
                ),
              ])),
              
            );
          }
        });
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
              }, 
            ),
          ])
        ],
      ),
    );
  }
}
