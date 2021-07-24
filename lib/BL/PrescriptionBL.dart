import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tvs_application/DAL/PrescriptionDAL.dart';
import 'package:tvs_application/Model/Adherence.dart';
import 'package:tvs_application/Model/Prescription.dart';
import 'package:tvs_application/Model/Reminder.dart';

class PrescriptionBL {
  PrescriptionDAL dal = PrescriptionDAL();

  Stream<QuerySnapshot<Map<String, dynamic>>> getIntakeStream() {
    var snapshot = dal.getIntakeStream();

    return snapshot;
  }

  Future<int> addIntake(AdherenceModel a) async {
    int success;

    success = await dal.addIntake(a);

    return success;
  }

  Future<int> updateIntake(AdherenceModel a) async {
    int success;

    success = await dal.updateIntake(a);

    return success;
  }

  Future<int> deleteIntake(AdherenceModel a) async {
    int success;

    success = await dal.deleteIntake(a);

    return success;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getListPrescription() {
    var snapshot = dal.getListPrescription();

    return snapshot;
  }

  Future<int> addReminder(ReminderModel r) async {
    int success;

    success = await dal.addReminder(r);

    return success;
  }

  Future<int> updateReminder(ReminderModel r) async {
    int success;

    success = await dal.updateReminder(r);

    return success;
  }

  Future<int> deleteReminder(ReminderModel r) async {
    int success;

    success = await dal.deleteReminder(r);

    return success;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getReminderStream() {
    var snapshot = dal.getReminderStream();

    return snapshot;
  }
}
