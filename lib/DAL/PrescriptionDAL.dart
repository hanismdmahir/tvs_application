import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tvs_application/Model/Adherence.dart';
import 'package:tvs_application/Model/Reminder.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PrescriptionDAL {
  final _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getIntakeStream() {
    var snapshot = FirebaseFirestore.instance
        .collection("user")
        .doc(_auth.currentUser.uid)
        .collection('adherence')
        .snapshots();

    return snapshot;
  }

  Future<int> addIntake(AdherenceModel a) async {
    int success;

    await firestore
        .collection("user")
        .doc(_auth.currentUser.uid)
        .collection("adherence")
        .doc()
        .set({
      'medName': a.medName,
      'taken': a.taken,
      'takenDate': a.takenDate,
    }).whenComplete(() => success = 1);

    return success;
  }

  Future<int> updateIntake(AdherenceModel a) async {
    int success;

    await firestore
        .collection("user")
        .doc(_auth.currentUser.uid)
        .collection("adherence")
        .doc(a.id)
        .update({
      'medName': a.medName,
      'taken': a.taken,
      'takenDate': a.takenDate,
    }).whenComplete(() => success = 1);

    return success;
  }

  Future<int> deleteIntake(AdherenceModel a) async {
    int success;

    await FirebaseFirestore.instance
        .collection("user")
        .doc(_auth.currentUser.uid)
        .collection('adherence')
        .doc(a.id)
        .delete();

    return success;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getListPrescription() {
    var snapshot = FirebaseFirestore.instance
        .collection("user")
        .doc(_auth.currentUser.uid)
        .collection('prescription')
        .orderBy('med\'s name', descending: false)
        .snapshots();

    return snapshot;
  }

  Future<int> addReminder(ReminderModel r) async {
    int success;

    await firestore
        .collection("user")
        .doc(_auth.currentUser.uid)
        .collection("appointment")
        .doc()
        .set({
      'idNoti': r.idNoti,
      'type': r.type,
      'details': r.details,
      'date': r.date,
      'location': r.location
    }).whenComplete(() => success = 1);

    return success;
  }

  Future<int> updateReminder(ReminderModel r) async {
    int success;

    await firestore
        .collection("user")
        .doc(_auth.currentUser.uid)
        .collection("appointment")
        .doc(r.id)
        .update({
      'type': r.type,
      'details': r.details,
      'date': r.date,
      'location': r.location
    }).whenComplete(() => success = 1);

    return success;
  }

  Future<int> deleteReminder(ReminderModel r) async {
    int success;

    await FirebaseFirestore.instance
        .collection("user")
        .doc(_auth.currentUser.uid)
        .collection('appointment')
        .doc(r.id)
        .delete();

    return success;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getReminderStream() {
    var snapshot = FirebaseFirestore.instance
        .collection("user")
        .doc(_auth.currentUser.uid)
        .collection('appointment')
        .orderBy('date', descending: false)
        .snapshots();

    return snapshot;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getPatientReminderStream(String uid) {
    var snapshot = FirebaseFirestore.instance
        .collection("user")
        .doc(uid)
        .collection('appointment')
        .orderBy('date', descending: false)
        .snapshots();

    return snapshot;
  }
}
