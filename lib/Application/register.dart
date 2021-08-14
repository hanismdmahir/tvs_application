import 'dart:core';
import '../Model/User.dart';
import '../BL/AccountBL.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'loader.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterSreenState createState() => _RegisterSreenState();
}

class _RegisterSreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _refferalIdController = TextEditingController();
  bool type1 = false;
  bool type2 = false;
  String typeSelected = "";
  UserModel u = UserModel();
  final bl = AccountBL();

  Widget buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Email',
            style: TextStyle(
                color: Color(0xff0245A3),
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 60,
          child: TextFormField(
            controller: _emailController,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(Icons.mail, color: Color(0xff0245A3)),
              hintText: 'Email',
              hintStyle: TextStyle(color: Colors.black38),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter your email';
              } else if (!value.contains('@') || !value.contains('.')) {
                return 'Please enter a valid email address';
              } else {
                return null;
              }
            },
          ),
        )
      ],
    );
  }

  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Password',
            style: TextStyle(
                color: Color(0xff0245A3),
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 60,
          child: TextFormField(
            controller: _passwordController,
            obscureText: true,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(Icons.lock, color: Color(0xff0245A3)),
              hintText: 'Password',
              hintStyle: TextStyle(color: Colors.black38),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter your password';
              } else if (value.length < 6) {
                return 'Password should be more than 6 characters';
              } else {
                return null;
              }
            },
          ),
        )
      ],
    );
  }

  Widget buildUsername() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Username',
            style: TextStyle(
                color: Color(0xff0245A3),
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 60,
          child: TextFormField(
            controller: _usernameController,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(Icons.person, color: Color(0xff0245A3)),
              hintText: 'Username',
              hintStyle: TextStyle(color: Colors.black38),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter your username';
              } else {
                return null;
              }
            },
          ),
        )
      ],
    );
  }

  Widget buildRefferal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(type1 == true ? 'Refferal Code' : 'Patient Navigator Code',
            style: TextStyle(
                color: Color(0xff0245A3),
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 60,
          child: TextFormField(
            controller: _refferalIdController,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(Icons.person_search, color: Color(0xff0245A3)),
              hintText:
                  type1 == true ? 'Refferal Code' : 'Patient Navigator Code',
              hintStyle: TextStyle(color: Colors.black38),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return type1 == true
                    ? 'Please enter your Refferal Code'
                    : 'Please enter your Patient Navigator Code';
              } else {
                return null;
              }
            },
          ),
        )
      ],
    );
  }

  Widget buildRegisterButton() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        width: double.infinity,
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: 30, height: 60),
          child: ElevatedButton(
            child: Text('Register'),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                if (typeSelected == '') {
                  final snackBar = SnackBar(
                    content: Text('Please Select User Type'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  _register();
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

  Widget buildType() {
    return Container(
        child: Wrap(
      spacing: 5.0,
      runSpacing: 5.0,
      children: <Widget>[
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(2.0),
              child: ChoiceChip(
                  elevation: 3.0,
                  label: Text('Patient'),
                  labelStyle: TextStyle(
                      color: type1 == true ? Colors.white : Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: Colors.white,
                  selectedColor: Color(0xff06224A),
                  selected: typeSelected == 'Patient',
                  onSelected: (selected) {
                    setState(() {
                      if (typeSelected != 'Patient') {
                        setState(() {
                          type1 = selected;
                          type2 = !selected;
                        });
                      }
                      typeSelected = 'Patient';
                    });
                  }),
            ),
            Container(
              padding: const EdgeInsets.all(2.0),
              child: ChoiceChip(
                  elevation: 3.0,
                  label: Text('Patient Navigator'),
                  labelStyle: TextStyle(
                      color: type2 == true ? Colors.white : Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: Colors.white,
                  selectedColor: Color(0xff06224A),
                  selected: typeSelected == 'Patient Navigator',
                  onSelected: (selected) {
                    setState(() {
                      if (typeSelected != 'Patient Navigator') {
                        setState(() {
                          type2 = selected;
                          type1 = !selected;
                        });
                      }
                      typeSelected = 'Patient Navigator';
                    });
                  }),
            ),
          ],
        )
      ],
    ));
  }

  Future<void> _register() async {
    String msg;
    String pnId = '';

    u = new UserModel(
        email: _emailController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        refferalId: _refferalIdController.text,
        patient: typeSelected == "Patient" ? true : false);
    LoaderDialog.showLoadingDialog(context, _formKey);

    pnId = await bl.getPNID(u.refferalId);

    if (pnId == '' && typeSelected == "Patient") //error not pn registered
    {
      msg = 'There is no Patient Navigator with Code : ' + u.refferalId;
    } else if (pnId != '' && typeSelected != "Patient") // pn register
    {
      msg = 'There is already a Patient Navigator with Code : ' + u.refferalId;
    } else {
      msg = await bl.register(u, pnId);
    }

    Navigator.of(_formKey.currentContext, rootNavigator: true).pop();
    final snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    if (msg == 'Successfully registered ' + u.email) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Widget buildLogin() {
    return GestureDetector(
        onTap: () {
          Navigator.pushReplacementNamed(context, '/login');
        },
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
                text: 'Login Here',
                style: TextStyle(
                    color: Color(0xff06224A),
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
          ]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
        child: Stack(
          children: <Widget>[
            Container(
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
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Register',
                          style: TextStyle(
                              color: Color(0xff06224A),
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        buildEmail(),
                        SizedBox(height: 18),
                        buildPassword(),
                        SizedBox(height: 18),
                        buildUsername(),
                        SizedBox(height: 18),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("I am a ",
                                  style: TextStyle(
                                      color: Color(0xff0245A3),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(width: 6),
                              buildType(),
                            ],
                          ),
                        ),
                        SizedBox(height: 18),
                        type1 == false && type2 == false
                            ? Container()
                            : buildRefferal(),
                        SizedBox(height: 20),
                        buildRegisterButton(),
                        SizedBox(height: 10),
                        buildLogin(),
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    ));
  }
}
