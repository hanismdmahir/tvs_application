import 'package:firebase_auth/firebase_auth.dart';
import 'package:tvs_application/Model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountDAL {
  final _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  Future<String> register(UserModel u) async {
    User uc;
    String msg;

    try {
      uc = (await _auth.createUserWithEmailAndPassword(
        email: u.email,
        password: u.password,
      )).user;

      await firestore.collection("user").doc(uc.uid).set({
        'email': u.email,
        'username': u.username,
        'code': u.refferalId,
        'patient': u.patient
      }).whenComplete(() => msg = 'Successfully registered ' + u.email);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      if (e.code == 'email-already-in-use') {
        msg = 'The email is already in use.';
      } else if (e.code == 'invalid-email') {
        msg = 'The email is invalid.';
      } else if (e.code == 'weak-password') {
        msg = 'The password is weak. Please use stronger password';
      }
    }
    return msg;
  }

  Future<String> signIn(String email, String password) async {
    String msg;

    try {
      User u = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;

      msg = 'Successfully login ' + u.email;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        msg = 'No user found for that email. Please try again.';
      } else if (e.code == 'wrong-password') {
        msg = 'Wrong password. Please try again.';
      } else if (e.code == 'invalid-email') {
        msg = 'The email is invalid. Please try again.';
      }
    }

    return msg;
  }

  Future<UserModel> getUserDataModel(String uid) async {
    var userDoc =
        await FirebaseFirestore.instance.collection("user").doc(uid).get();

    UserModel u = UserModel(
        email: userDoc['email'],
        username: userDoc['username'],
        uid: uid,
        refferalId: userDoc['code'],
        patient: userDoc['patient']);

    return u;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDataStream(String uid) {
    var snapshot =
        FirebaseFirestore.instance.collection("user").doc(uid).snapshots();

    return snapshot;
  }

  String getUserID() {
    return _auth.currentUser.uid;
  }

  Future<int> update1UserData(
      String field, String updateData, String uid) async {
    int update = 0;

    await firestore.collection("user").doc(uid).update({
      field: updateData,
    }).whenComplete(() => update = 1);

    return update;
  }
}
