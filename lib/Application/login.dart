import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../BL/AccountBL.dart';

import '../Model/User.dart';
import 'loader.dart';
import 'mainmenu.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginSreenState createState() => _LoginSreenState();
}

class _LoginSreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
        SizedBox(height: 18),
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
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
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
        SizedBox(height: 18),
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
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
        )
      ],
    );
  }

  Widget buildLoginButton() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        width: double.infinity,
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: 30, height: 60),
          child: ElevatedButton(
            child: Text('Sign In'),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                _signInWithEmailAndPassword();
              }

              //Navigator.pushReplacementNamed(context, '/mainmenu');
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

  void _signInWithEmailAndPassword() async {
    String msg;

    msg = await bl.signIn(_emailController.text, _passwordController.text);

    final snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    
    if(msg == 'Successfully login ' + _emailController.text)
    {
      LoaderDialog.showLoadingDialog(context, _formKey); 
      UserModel u = await bl.getUserDataModel();
      Navigator.of(_formKey.currentContext,rootNavigator: true).pop();
      Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => new MainMenuScreen(u)));
    }

  }

  Widget buildRegister() {
    return GestureDetector(
        onTap: () {
          Navigator.pushReplacementNamed(context, '/register');
        },
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
                text: 'Register Here',
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
                    Color(0x66BDF1F6),
                    Color(0x99BDF1F6),
                    Color(0xccBDF1F6),
                    Color(0xffBDF1F6),
                  ])),
              child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Sign In',
                          style: TextStyle(
                              color: Color(0xff06224A),
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 50),
                        buildEmail(),
                        SizedBox(height: 20),
                        buildPassword(),
                        SizedBox(height: 10),
                        buildLoginButton(),
                        SizedBox(height: 10),
                        buildRegister()
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
