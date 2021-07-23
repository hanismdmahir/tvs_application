import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tvs_application/Model/Prescription.dart';

class PrescriptionAdd extends StatefulWidget {
  PrescriptionAdd(this.add, this.prescription);

  final bool add;
  final PrescriptionModel prescription;
  
    @override
    _PrescriptionAddScreenState createState() => _PrescriptionAddScreenState();
  }
  
  

class _PrescriptionAddScreenState extends State<PrescriptionAdd> {
  final FirebaseAuth auth = FirebaseAuth.instance; 
  final firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool type1 = false;
  bool type2 = false;
  bool time1 =false, time2=false, time3=false, time4=false;
  bool taken1 =false, taken2=false;

  TextEditingController _medname = TextEditingController();
  TextEditingController _quantity = TextEditingController();
  TextEditingController _strength = TextEditingController();
  
  String titleName = 'Add New Prescription';

  String typeSelected = "";
  String timeSelected = "";
  String takenSelected = "";

  @override
  void initState() { 
    super.initState();
    if (widget.add == false){
      titleName = 'Edit Prescription';
      _medname.text = widget.prescription.medname;
      _quantity.text = widget.prescription.quantity.toString();
      _strength.text = widget.prescription.strength;
      typeSelected = widget.prescription.type;
      if (typeSelected == 'Capsule') {
        type1 = true;
      } else {
        type2 = true;
      }
      timeSelected = widget.prescription.time;
      if (timeSelected == 'Morning') {
        time1 = true;
      } else if(timeSelected == 'Noon') {
        time2 = true;
      } else if(timeSelected == 'Evening') {
        time3 = true;
      } else{
        time4 = true;
      }
      
      takenSelected = widget.prescription.taken;
      if (takenSelected == 'Before Meal') {
        taken1 = true;
      } else {
        taken2 = true;
      }
    }
  }

  Widget buildName() {
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
            controller: _medname,
            style: TextStyle(color: Colors.black87),
            validator: (value) {
              return value.isNotEmpty ? null : "Enter the medicine's name";
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              hintText: 'Medicine Name',
              hintStyle: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }

  Widget buildQuantity() {
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
        height: 60,
        child: TextFormField(
          controller: _quantity,
          validator: (value) {
              return value.isNotEmpty ? null : "Enter the quantity";
            },
          style: TextStyle(color: Colors.black87),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            hintText: 'Quantity',
            hintStyle: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget buildStrength() {
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
            controller: _strength,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              hintText: 'Strength (mg)',
              hintStyle: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
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
      runSpacing: 5.0,
      children: <Widget>[
        Wrap( crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Container(
            padding: const EdgeInsets.all(2.0),
            child: ChoiceChip(
              elevation: 3.0,
              label: Text('Capsule'),
              labelStyle: TextStyle(
                  color: type1 == true ? Colors.white : Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              backgroundColor: Colors.white,
              selectedColor: Color(0xff06224A),
              selected: typeSelected == 'Capsule',
              onSelected: (selected) {
                setState(() {
                  if(typeSelected != 'Capsule')
                  {
                    type1 = selected;
                    type2 = !selected;
                  }
                  typeSelected = 'Capsule';
                  
                });
              }
          ),
        ),
        Container(
            padding: const EdgeInsets.all(2.0),
            child: ChoiceChip(
              elevation: 3.0,
              label: Text('Tablet'),
              labelStyle: TextStyle(
                  color: type2 == true ? Colors.white : Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              backgroundColor: Colors.white,
              selectedColor: Color(0xff06224A),
              selected: typeSelected == 'Tablet',
              onSelected: (selected) {
                setState(() {
                  
                  if(typeSelected != 'Tablet')
                  {
                    type2 = selected;
                    type1 = !selected;
                  }
                  typeSelected = 'Tablet';
                  
                });
                
              }
          ),
        ),
        ],
        )
      ],
    ));
  }


  Widget buildTime() {
    return Container(
        child: Wrap(
      spacing: 5.0,
      runSpacing: 5.0,
      children: <Widget>[
        Wrap(
          children: [
            Container(
            padding: const EdgeInsets.all(2.0),
            child: ChoiceChip(
              elevation: 3.0,
              label: Text('Morning'),
              labelStyle: TextStyle(
                  color: time1 == true ? Colors.white : Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              backgroundColor: Colors.white,
              selectedColor: Color(0xff06224A),
              selected: timeSelected == 'Morning',
              onSelected: (selected) {
                setState(() {
                  if(timeSelected != 'Morning')
                  {
                    time1 = selected;
                    time2 = !selected;
                    time3 = !selected;
                    time4 = !selected;
                  }
                  timeSelected = 'Morning';
                  
                });
              }
          ),
        ),
        
        Container(
            padding: const EdgeInsets.all(2.0),
            child: ChoiceChip(
              elevation: 3.0,
              label: Text('Noon'),
              labelStyle: TextStyle(
                  color: time2 == true ? Colors.white : Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              backgroundColor: Colors.white,
              selectedColor: Color(0xff06224A),
              selected: timeSelected == 'Noon',
              onSelected: (selected) {
                setState(() {
                  
                  if(timeSelected != 'Noon')
                  {
                    time2 = selected;
                    time1 = !selected;
                    time3 = !selected;
                    time4 = !selected;
                  }
                  timeSelected = 'Noon';
                  
                });
                
              }
          ),
        ),
        Container(
            padding: const EdgeInsets.all(2.0),
            child: ChoiceChip(
              elevation: 3.0,
              label: Text('Evening'),
              labelStyle: TextStyle(
                  color: time3 == true ? Colors.white : Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              backgroundColor: Colors.white,
              selectedColor: Color(0xff06224A),
              selected: timeSelected == 'Evening',
              onSelected: (selected) {
                setState(() {
                  
                  if(timeSelected != 'Evening')
                  {
                    time3 = selected;
                    time1 = !selected;
                    time2 = !selected;
                    time4 = !selected;
                  }
                  timeSelected = 'Evening';
                  
                });
                
              }
          ),
        ),
        Container(
            padding: const EdgeInsets.all(2.0),
            child: ChoiceChip(
              elevation: 3.0,
              label: Text('Night'),
              labelStyle: TextStyle(
                  color: time4 == true ? Colors.white : Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              backgroundColor: Colors.white,
              selectedColor: Color(0xff06224A),
              selected: timeSelected == 'Night',
              onSelected: (selected) {
                setState(() {
                  
                  if(timeSelected != 'Night')
                  {
                    time4 = selected;
                    time1 = !selected;
                    time2 = !selected;
                    time3 = !selected;
                  }
                  timeSelected = 'Night';
                  
                });
                
              }
          ),
        ),
        ],
        )
      ],
    ));
  }

  Widget buildTaken() {
    return Container(
        child: Wrap(
      spacing: 5.0,
      runSpacing: 5.0,
      children: <Widget>[
        Wrap(
          children: [
            Container(
            padding: const EdgeInsets.all(2.0),
            child: ChoiceChip(
              elevation: 3.0,
              label: Text('Before Meal'),
              labelStyle: TextStyle(
                  color: taken1 == true ? Colors.white : Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              backgroundColor: Colors.white,
              selectedColor: Color(0xff06224A),
              selected: takenSelected == 'Before Meal',
              onSelected: (selected) {
                setState(() {
                  if(takenSelected != 'Before Meal')
                  {
                    taken1 = selected;
                    taken2 = !selected;
                  }
                  takenSelected = 'Before Meal';
                  
                });
              }
          ),
        ),
        Container(
            padding: const EdgeInsets.all(2.0),
            child: ChoiceChip(
              elevation: 3.0,
              label: Text('After Meal'),
              labelStyle: TextStyle(
                  color: taken2 == true ? Colors.white : Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              backgroundColor: Colors.white,
              selectedColor: Color(0xff06224A),
              selected: takenSelected == 'After Meal',
              onSelected: (selected) {
                setState(() {
                  
                  if(takenSelected != 'After Meal')
                  {
                    taken2 = selected;
                    taken1 = !selected;
                  }
                  takenSelected = 'After Meal';
                  
                });
                
              }
          ),
        ),
        ],
        )
      ],
    ));
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
              if (widget.add) {
                if (_medname.text  == ''){
                  final snackBar = SnackBar(
                    content: Text('Please fill the medicine\'s name'),
                  );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                else if (_quantity.text == ''){
                  final snackBar = SnackBar(
                    content: Text('Please fill the medicine\'s quantity'),
                  );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                else if (typeSelected == ''){
                  final snackBar = SnackBar(
                    content: Text('Please select one of the Type choice'),
                  );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } 
                else if (_strength.text == ''){
                  final snackBar = SnackBar(
                    content: Text('Please fill the medicine\'s strength'),
                  );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                else if (timeSelected == ''){
                  final snackBar = SnackBar(
                    content: Text('Please select one of the Time choice'),
                  );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } 
                else if (takenSelected == ''){
                  final snackBar = SnackBar(
                    content: Text('Please select one of the Taken choice'),
                  );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } 
                else{
                  await firestore.collection("user")
                        .doc(auth.currentUser.uid)
                        .collection("prescription")
                        .doc()
                        .set({
                          'med\'s name': _medname.text,
                          'quantity': int.parse(_quantity.text),
                          'strength': _strength.text,
                          'taken': takenSelected,
                          'time': timeSelected,
                          'type': typeSelected
                        }); 
                  
                  Navigator.of(context).pop();
                }
              }
              else {
                await firestore.collection("user")
                        .doc(auth.currentUser.uid)
                        .collection("prescription")
                        .doc(widget.prescription.id)
                        .update({
                          'med\'s name': _medname.text,
                          'quantity': int.parse(_quantity.text),
                          'strength': _strength.text,
                          'taken': takenSelected,
                          'time': timeSelected,
                          'type': typeSelected
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
                          buildName(),
                          SizedBox(height: 28),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildQuantity(),
                                SizedBox(width: 24),
                                buildType(),
                              ],
                            ),
                          ),
                          SizedBox(height: 28),
                          buildStrength(),
                          SizedBox(height: 28),
                          buildTime(),
                          SizedBox(height: 20),
                          buildTaken(),
                          SizedBox(height: 38),
                          Center(child: Text('Note: Reminder will be automatically set.')),
                          SizedBox(height: 10),
                          buildAddButton()
                        ]),
                  )),
            ),
          ),
        );
      }
    
      

  
}
