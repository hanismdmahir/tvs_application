import 'package:flutter/material.dart';

import 'Prescription/prescriptionmain.dart';

class RecordMainScreen extends StatefulWidget {
  @override
  _RecordMainScreenState createState() => _RecordMainScreenState();
}

class _RecordMainScreenState extends State<RecordMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 15),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () => print('Test pressed'),
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 200, height: 200),
                  child: Card(
                  elevation: 5,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.bar_chart, color: Color(0xff06224A), size: 70.0),
                        Text('Test')
                      ]),
                ),
              ),
            ),
            SizedBox(height: 50),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PrescriptionMain()) );
              },
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 200, height: 200),
                child: Card(
                elevation: 5,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.assignment,
                          color: Color(0xff06224A), size: 50.0),
                      Text('Prescription'),
                    ]),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
