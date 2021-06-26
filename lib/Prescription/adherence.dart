import 'package:flutter/material.dart';
import 'package:g2x_week_calendar/g2x_simple_week_calendar.dart';

class AdherenceMainScreen extends StatefulWidget {

  @override
  _AdherenceMainScreenState createState() => _AdherenceMainScreenState();
}

class _AdherenceMainScreenState extends State<AdherenceMainScreen> {
  DateTime dateCallback;

  _dateCallback(DateTime date){
    dateCallback = date;
    print(dateCallback);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Adherence',
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
      body: G2xSimpleWeekCalendar(
        100.0, 
        DateTime.now(),
        format: 'dd/MM/yyyy', 
        dateCallback: (date) => _dateCallback(date), 
        typeCollapse: false,
        backgroundDecoration: new BoxDecoration(color: Color(0xff8FBAF3)),)
    );
  }
}