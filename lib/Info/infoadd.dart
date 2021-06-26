import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddInfoScreen extends StatefulWidget {

  @override
  _AddInfoScreenState createState() => _AddInfoScreenState();
}

class _AddInfoScreenState extends State<AddInfoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _summary = TextEditingController();
  final TextEditingController _url = TextEditingController();
  final firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _title.dispose();
    _summary.dispose();
    _url.dispose();
    super.dispose();
  }

  Widget buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 60,
          child: TextFormField(
            controller: _title,
            style: TextStyle(color: Colors.black87),
            validator: (value) {
              return value.isNotEmpty ? null : "Enter the Information's Title";
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              hintText: 'Title',
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
        )
      ],
    );
  }

  Widget buildSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 240,
          child: TextFormField(
            textAlignVertical: TextAlignVertical.top,
            expands: true,
            maxLines: null,
            controller: _summary,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            style: TextStyle(color: Colors.black87),
            validator: (value) {
              return value.isNotEmpty ? null : "Enter the Information's Summary";
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 18.0),
              hintText: 'Summary',
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
        )
      ],
    );
  }

  Widget buildUrl() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 60,
          child: TextFormField(
            controller: _url,
            style: TextStyle(color: Colors.black87),
            validator: (value) {
              return value.isNotEmpty ? null : "Enter the Information's Url";
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              hintText: 'Url',
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
        )
      ],
    );
  }

   Widget buildAddButton() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        width: double.infinity,
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: 30, height: 60),
          child: ElevatedButton(
            child: Text('Post'),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                await firestore.collection("information").doc().set({
                  'date': DateTime.now() ,
                  'summary': _summary.text,
                  'title': _title.text,
                  'url': _url.text
                });
                
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Color(0xff06224A),
              onPrimary: Colors.white,
              onSurface: Colors.grey,
              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Color(0xff06224A), //change your color here
        ),
        title: Text('Add New Information',
                    style: TextStyle(
                    color: Color(0xff06224A),
                    fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
              Color(0xffBDF1F6),
              Color(0xccBDF1F6),
              Color(0x99BDF1F6),
              Color(0x66BDF1F6),
            ])),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Form(
                key: _formKey,
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 15),
                      buildTitle(),
                      SizedBox(height: 18),
                      buildSummary(),
                      SizedBox(height: 18),
                      buildUrl(),
                      SizedBox(height: 25),
                      buildAddButton()
                    ]),
              )),
        ),
      ),
    );
  }
}