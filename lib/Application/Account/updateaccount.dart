import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tvs_application/BL/AccountBL.dart';

import '../loader.dart';

class UpdateAccountScreen extends StatefulWidget {
  final String data;
  final int type;

  UpdateAccountScreen({Key key, @required this.data, @required this.type})
      : super(key: key);

  @override
  _UpdateAccountScreenState createState() => _UpdateAccountScreenState();
}

class _UpdateAccountScreenState extends State<UpdateAccountScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _change = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  String title;
  bool passGood = true;
  final bl = AccountBL();
  String errorMsg = '';

  @override
  Widget build(BuildContext context) {
    if (widget.type == 1) {
      title = 'Username';
    } else if (widget.type == 2) {
      title = 'Email';
    } else {
      title = 'Code';
    }

    return AlertDialog(
        scrollable: true,
        title: Text('Update ' + title),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel')),
          TextButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  int update = 0;

                  LoaderDialog.showLoadingDialog(context, _formKey);
                  if (widget.type == 2) {
                    var user = auth.currentUser;
                    var authCredentials = EmailAuthProvider.credential(
                        email: widget.data, password: _pass.text);

                    UserCredential authResult;

                    authResult = await user
                        .reauthenticateWithCredential(authCredentials);
                    if (authResult.user != null) {
                      await user.updateEmail(_change.text);
                      await firestore
                          .collection("user")
                          .doc(auth.currentUser.uid)
                          .update({
                        'email': _change.text,
                      });

                      Navigator.of(context).pop();
                    } else {
                      setState(() {
                        passGood = false;
                      });
                    }
                  } else {
                    update = await bl.update1UserData(
                        title.toLowerCase(), _change.text);
                  }

                  Navigator.of(_formKey.currentContext, rootNavigator: true)
                      .pop();

                  if (update == 1) {
                    Navigator.of(context).pop();
                  } else {
                    setState(() {
                      errorMsg = 'Error. Please try again later.';
                    });
                  }
                }
              },
              child: Text('Update')),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        content: Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextFormField(
                controller: _change,
                validator: (value) {
                  return value.isEmpty ? "Enter new " + title : null;
                },
                decoration: InputDecoration(hintText: widget.data),
              ),
              SizedBox(height: 15),
              widget.type == 2
                  ? TextFormField(
                      controller: _pass,
                      obscureText: true,
                      validator: (value) {
                        return value.isNotEmpty ? null : "Enter Your Password ";
                      },
                      decoration: InputDecoration(
                          hintText: 'Password',
                          errorText: (passGood) ? null : "Wrong Password"),
                    )
                  : SizedBox(height: 0),
              Text(
                errorMsg,
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
              )
            ])));
  }
}
