import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tvs_application/BL/TestBL.dart';
import 'package:tvs_application/Model/Test.dart';

class TestAddScreen extends StatefulWidget {
  final String type;
  final bool add;
  final TestModel test;

  TestAddScreen({this.type, this.add, this.test});

  @override
  _TestAddScreenState createState() => _TestAddScreenState();
}

class _TestAddScreenState extends State<TestAddScreen> {
  final TestBL bl = TestBL();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool type1 = false;
  bool type2 = false;
  String typeSelected;
  TextEditingController _location = TextEditingController();
  TextEditingController _result = TextEditingController();
  TextEditingController _date = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String titleName = 'Add New Test Result';

  @override
  void initState() {
    if (!widget.add) {
      titleName = 'Edit Test Result';
      selectedDate = widget.test.date;
      _date.text = DateFormat.yMd().format(selectedDate);
      _result.text = widget.test.result;
      _location.text = widget.test.location;
    }

    typeSelected = widget.type;

    if (typeSelected == 'Viral Load' ) {
      type1 = true;
    } else {
      type2 = true;
    }
    super.initState();
  }


  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _date.text = DateFormat.yMd().format(selectedDate);
      });
  }

  Widget buildDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
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
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2))
                ]),
            height: 60,
            child: TextFormField(
              controller: _date,
              style: TextStyle(color: Colors.black87),
              validator: (value) {
                return value.isNotEmpty ? null : "Enter the test date";
              },
              enabled: false,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                hintText: 'Test Date',
                hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        )
      ],
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
                  label: Text('Viral Load'),
                  labelStyle: TextStyle(
                      color: type1 == true ? Colors.white : Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: Colors.white,
                  selectedColor: Color(0xff06224A),
                  selected: typeSelected == 'Viral Load',
                  onSelected: (selected) {
                    setState(() {
                      if (typeSelected != 'Viral Load') {
                        setState(() {
                          type1 = selected;
                          type2 = !selected;
                        });
                      }
                      typeSelected = 'Viral Load';
                    });
                  }),
            ),
            Container(
              padding: const EdgeInsets.all(2.0),
              child: ChoiceChip(
                  elevation: 3.0,
                  label: Text('CD4 Count'),
                  labelStyle: TextStyle(
                      color: type2 == true ? Colors.white : Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: Colors.white,
                  selectedColor: Color(0xff06224A),
                  selected: typeSelected == 'CD4 Count',
                  onSelected: (selected) {
                    setState(() {
                      if (typeSelected != 'CD4 Count') {
                        setState(() {
                          type2 = selected;
                          type1 = !selected;
                        });
                      }
                      typeSelected = 'CD4 Count';
                    });
                  }),
            ),
          ],
        )
      ],
    ));
  }

  Widget buildResult() {
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
            controller: _result,
            style: TextStyle(color: Colors.black87),
            keyboardType: TextInputType.number,
            validator: (value) {
              return value.isNotEmpty ? null : "Enter the test result";
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              hintText: typeSelected == 'Viral Load'
                  ? 'Number of HIV copies/mL (copies/mL)'
                  : 'Number of CD4 cells per microliter (cell/µL)',
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
              return value.isNotEmpty ? null : "Enter the test's location";
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
                
                if (typeSelected == '') {
                  final snackBar = SnackBar(
                    content: Text('Please select one of the Type choice'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  int success = 0;
                  TestModel t = TestModel();
                  
                  t.type = typeSelected;
                  t.date = selectedDate;
                  t.location = _location.text;
                  t.result = _result.text;

                  if (widget.add) {
                   success = await bl.addTest(t);
                  } else {
                    t.id = widget.test.id;
                    print('here');
                   success = await bl.updateTest(t);
                  }

                  if(success == 1){
                    Navigator.of(context).pop();
                  }else{
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      buildType(),
                      SizedBox(height: 28),
                      buildResult(),
                      SizedBox(height: 28),
                      buildDate(),
                      SizedBox(height: 28),
                      buildLocation(),
                      SizedBox(height: 38),
                      buildAddButton()
                    ]),
              )),
        ),
      ),
    );
  }
}
