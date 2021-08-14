import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tvs_application/BL/AccountBL.dart';
import 'package:tvs_application/Model/User.dart';

import '../login.dart';
import 'resetpassword.dart';
import 'updateaccount.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  UserModel user;
  final bl = AccountBL();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bl.getUserDataStream(),
      builder: (context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Account',
                      style: TextStyle(
                          color: Color(0xff06224A),
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 35),
                ListTile(
                  title: Text(snapshot.data['username']),
                  subtitle: Text('Username'),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => UpdateAccountScreen(
                            data: snapshot.data['username'], type: 1, patient: snapshot.data['patient']));
                  },
                ),
                ListTile(
                  title: Text(snapshot.data['email']),
                  subtitle: Text('Email'),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => UpdateAccountScreen(
                            data: snapshot.data['email'], type: 2, patient: snapshot.data['patient']));
                  },
                ),
                ListTile(
                  title: Text(snapshot.data['code']),
                  subtitle: Text('Code'),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => UpdateAccountScreen(
                            data: snapshot.data['code'], type: 3, patient: snapshot.data['patient']));
                  },
                ),
                SizedBox(height: 90),
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 30, height: 60),
                  child: ElevatedButton(
                    child: Text('Reset Password'),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => ResetPasswordScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      onPrimary: Colors.white,
                      onSurface: Colors.grey,
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 30, height: 60),
                  child: OutlinedButton(
                    child: Text('Sign Out'),
                    onPressed: () async {
                      await auth.signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => LoginScreen()),
                          (route) => false);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(width: 2, color: Color(0xff06224A)),
                      primary: Color(0xff06224A),
                      onSurface: Colors.grey,
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
