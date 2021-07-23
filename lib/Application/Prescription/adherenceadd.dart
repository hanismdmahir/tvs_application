import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tvs_application/BL/PrescriptionBL.dart';
import 'package:intl/intl.dart';
import 'package:tvs_application/Model/Adherence.dart';

class AdherenceAddScreen extends StatefulWidget {
  final bool add;
  final AdherenceModel intake;

  AdherenceAddScreen({this.add, this.intake});

  @override
  _AdherenceAddScreenState createState() => _AdherenceAddScreenState();
}

class _AdherenceAddScreenState extends State<AdherenceAddScreen> {
  final PrescriptionBL bl = PrescriptionBL();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String titleName = 'Record Adherence';
  String errorMsg = '';
  List<String> medName = [];
  var _type;
  TextEditingController _date = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateFormat dateFormat = DateFormat("dd-MM-yyyy");
  bool type1 = false;
  bool type2 = false;
  String typeSelected = "";

  @override
  void initState() {
    if(!widget.add){
      titleName = 'Edit Prescription';
    _type = widget.intake.medName;
    selectedDate = widget.intake.takenDate;
    _date.text = dateFormat.format(selectedDate);
    var taken = widget.intake.taken;
    if (taken) {
      type1 = true;
      typeSelected = 'Taken';
    } else {
      type2 = true;
      typeSelected = 'Missed';
    }
    }
    
    super.initState();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
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
      child: Card(
        elevation: 3,
        child: Container(
          alignment: Alignment.centerLeft,
          height: 60,
          child: TextFormField(
            controller: _date,
            style: TextStyle(color: Colors.black87),
            validator: (value) {
              return value.isNotEmpty ? null : "Enter the taken date";
            },
            enabled: false,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              hintText: 'Taken Date',
              hintStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildType() {
    return Container(
        child: Wrap(
      spacing: 5.0,
      runSpacing: 10.0,
      children: <Widget>[
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(2.0),
              child: ChoiceChip(
                  elevation: 3.0,
                  label: Text('Taken'),
                  labelStyle: TextStyle(
                      color: type1 == true ? Colors.white : Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: Colors.white,
                  selectedColor: Color(0xff06224A),
                  selected: typeSelected == 'Taken',
                  onSelected: (selected) {
                    setState(() {
                      if (typeSelected != 'Taken') {
                        setState(() {
                          type1 = selected;
                          type2 = !selected;
                        });
                      }
                      typeSelected = 'Taken';
                    });
                  }),
            ),
            Container(
              padding: const EdgeInsets.all(2.0),
              child: ChoiceChip(
                  elevation: 3.0,
                  label: Text('Missed'),
                  labelStyle: TextStyle(
                      color: type2 == true ? Colors.white : Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: Colors.white,
                  selectedColor: Color(0xff06224A),
                  selected: typeSelected == 'Missed',
                  onSelected: (selected) {
                    setState(() {
                      if (typeSelected != 'Missed') {
                        setState(() {
                          type2 = selected;
                          type1 = !selected;
                        });
                      }
                      typeSelected = 'Missed';
                    });
                  }),
            ),
          ],
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        scrollable: true,
        title: Text(titleName),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel')),
          TextButton(
              onPressed: () async {
                var success;
                AdherenceModel a = AdherenceModel(
                    medName: _type, taken: type1, takenDate: selectedDate);

                if (widget.add) {
                  success = await bl.addIntake(a);
                } else {
                  a.id = widget.intake.id;
                  success = await bl.updateIntake(a);
                }

                if (success == 1) {
                  Navigator.of(context).pop();
                } else {
                  final snackBar = SnackBar(
                    content: Text('Somethin wrong.. Try again.'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: widget.add ? Text('Add') : Text('Update')),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        content: Form(
            key: _formKey,
            child: StreamBuilder(
                stream: bl.getListPrescription(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.data.docs.length == 0) {
                    return Center(
                      child: Text('There is no prescription added.'),
                    );
                  } else {
                    medName.clear();
                    var data = snapshot.data;
                    for (var i = 0; i < data.docs.length; i++) {
                      medName.add(data.docs[i]['med\'s name']);
                    }
                    return Column(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: DropdownButton<String>(
                          underline: SizedBox(),
                          isExpanded: true,
                          focusColor: Colors.grey,
                          value: _type,
                          dropdownColor: Colors.white,
                          elevation: 3,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold),
                          iconEnabledColor: Colors.black,
                          items: medName
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          }).toList(),
                          hint: Text(
                            "Medicine Name",
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
                      SizedBox(height: 8),
                      buildDate(),
                      SizedBox(height: 8),
                      buildType(),
                      SizedBox(height: 15),
                    ]);
                  }
                })));
  }
}
