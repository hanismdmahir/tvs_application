import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordSreenState createState() => _ResetPasswordSreenState();
}

class _ResetPasswordSreenState extends State<ResetPasswordScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool passGood = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _old = TextEditingController();
  final TextEditingController _new = TextEditingController();
  final TextEditingController _newrepeat = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        scrollable: true,
        title: Text('Reset Password'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel')),
          TextButton(
              onPressed: () async {

                await validateCurrentPass(_old.text);

                if (_formKey.currentState.validate() && passGood) {
                    var user = auth.currentUser; 
                    await user.updatePassword(_new.text);
                    Navigator.of(context).pop();
                }
              },
              child: Text('Reset')),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        content: Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextFormField(
                controller: _old,
                obscureText: true,
                validator: (value) {
                  return value.isNotEmpty ? null : "Enter the Current Password";
                },
                decoration: InputDecoration(hintText: "Current Password", errorText: (passGood) ? null : "Wrong Password"),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _new,
                obscureText: true,
                validator: (value) {
                  return value.isNotEmpty ? null : "Enter the New Password";
                },
                decoration: InputDecoration(hintText: "New Password"),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _newrepeat,
                obscureText: true,
                validator: (value) {
                  if (value.isNotEmpty) {
                    if (_new.text == value) {
                      return null;
                    } else {
                      return 'Repeat Password is not correct';
                    }
                  } else {
                    return "Repeat the New Password";
                  }
                },
                decoration: InputDecoration(hintText: "Repeat New Password"),
              ),
              SizedBox(height: 15),
            ])));
  }

  Future<void> validateCurrentPass(String pass) async {
    var user = auth.currentUser;
    var authCredentials =
        EmailAuthProvider.credential(email: user.email, password: pass);
    UserCredential authResult;

    authResult = await user.reauthenticateWithCredential(authCredentials);
    if (authResult.user != null)
    setState(() {
      passGood = true;
    });
    else
    setState(() {
      passGood = false;
    });
    
  }
}
