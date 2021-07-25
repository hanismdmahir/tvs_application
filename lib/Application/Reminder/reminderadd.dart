import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tvs_application/BL/PrescriptionBL.dart';
import 'package:tvs_application/Model/Reminder.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:tvs_application/main.dart';

class ReminderAddScreen extends StatefulWidget {
  final bool add;
  final ReminderModel reminder;

  ReminderAddScreen({this.add, this.reminder});

  @override
  _ReminderAddScreenState createState() => _ReminderAddScreenState();
}

class _ReminderAddScreenState extends State<ReminderAddScreen> {
  var rng = new Random();
  final PrescriptionBL bl = PrescriptionBL();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _type;
  TextEditingController _details = TextEditingController();
  TextEditingController _time = TextEditingController();
  TextEditingController _date = TextEditingController();
  TextEditingController _location = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String titleName = 'Add New Appoinment';
  DateFormat dateFormat = DateFormat("dd-MM-yyyy");

  @override
  void initState() {
    if (!widget.add) {
      titleName = 'Edit Appointment';
      _type = widget.reminder.type;
      selectedDate = widget.reminder.date;
      _date.text = dateFormat.format(selectedDate);
      selectedTime = TimeOfDay.fromDateTime(selectedDate);
      var _hour = selectedTime.hour.toString();
      var _minute = selectedTime.minute.toString();
      _time.text = _hour.padLeft(2, '0') + ' : ' + _minute.padLeft(2, '0');
      _details.text = widget.reminder.details;
      _location.text = widget.reminder.location;
    }
    super.initState();
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        var _hour = selectedTime.hour.toString();
        var _minute = selectedTime.minute.toString();
        _time.text = _hour.padLeft(2, '0') + ' : ' + _minute.padLeft(2, '0');
      });
  }

  Widget buildTime() {
    return InkWell(
      onTap: () {
        _selectTime(context);
      },
      child: Container(
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
          controller: _time,
          style: TextStyle(color: Colors.black87),
          validator: (value) {
            return value.isNotEmpty ? null : "Enter the appointment time";
          },
          enabled: false,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            hintText: 'Appointment Time',
            hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _date.text = dateFormat.format(selectedDate);
      });
  }

  Widget buildDate() {
    return InkWell(
      onTap: () {
        _selectDate(context);
      },
      child: Container(
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
          controller: _date,
          style: TextStyle(color: Colors.black87),
          validator: (value) {
            return value.isNotEmpty ? null : "Enter the appointment date";
          },
          enabled: false,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            hintText: 'Appointment Date',
            hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget buildLocation() {
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
            controller: _location,
            style: TextStyle(color: Colors.black87),
            validator: (value) {
              return value.isNotEmpty
                  ? null
                  : "Enter the appointment's location";
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              hintText: 'Location',
              hintStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }

  Widget buildDetails() {
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
            controller: _details,
            style: TextStyle(color: Colors.black87),
            validator: (value) {
              return value.isNotEmpty
                  ? null
                  : "Enter the appointment's details";
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              hintText: 'Details',
              hintStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }

  Widget buildType() {
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              underline: SizedBox(),
              isExpanded: true,
              focusColor: Colors.grey,
              value: _type,
              dropdownColor: Colors.white,
              //elevation: 5,
              style: TextStyle(color: Colors.black87),
              iconEnabledColor: Colors.black,
              items: <String>[
                'Meet Up with Patient Navigator',
                'Doctor\'s Appointment',
                'Medicine\'s Restock',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.black87),
                  ),
                );
              }).toList(),
              hint: Text(
                "Appointment Type",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold),
              ),
              onChanged: (String value) {
                setState(() {
                  _type = value;
                });
              },
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
            child: widget.add ? Text('Add') : Text('Update'),
            onPressed: () async {
               if (_formKey.currentState.validate()) {
                if (_type == '') {
                  final snackBar = SnackBar(
                    content: Text('Please select one of the appointment type'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  int success = 0;
                  ReminderModel r = ReminderModel();

                  r.type = _type;
                  r.date = new DateTime(selectedDate.year, selectedDate.month,
                      selectedDate.day, selectedTime.hour, selectedTime.minute);
                  r.location = _location.text;
                  r.details = _details.text;

                  if (widget.add) {
                    r.idNoti = rng.nextInt(100) + 100;
                    success = await bl.addReminder(r);
                  } else {
                    r.id = widget.reminder.id;
                    success = await bl.updateReminder(r);
                  }

                  if (success == 1) {
                    setAppointmentNotification(r);
                    Navigator.of(context).pop();
                  } else {
                    final snackBar = SnackBar(
                      content: Text('Somethin wrong.. Try again.'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
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
          color: Color(0xff06224A),
        ),
        title: Text(
          titleName,
          style:
              TextStyle(color: Color(0xff06224A), fontWeight: FontWeight.bold),
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
                      SizedBox(height: 20),
                      buildType(),
                      SizedBox(height: 20),
                      buildDetails(),
                      SizedBox(height: 28),
                      buildLocation(),
                      SizedBox(height: 28),
                      buildDate(),
                      SizedBox(height: 28),
                      buildTime(),
                      SizedBox(height: 38),
                      buildAddButton()
                    ]),
              )),
        ),
      ),
    );
  }

  Future<void> setAppointmentNotification(ReminderModel r) async {
    print('setupNoti');
    await notificationsPlugin.zonedSchedule(
        r.idNoti,
        r.type,
        r.details,
        tz.TZDateTime.from(r.date, tz.local),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                '2', 'ReminderAppointment', 'Description')),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }
}
