import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tvs_application/Model/Test.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TestDAL {
  final _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  Future<int> addTest(TestModel t) async {
    int success;

    await firestore
        .collection("user")
        .doc(_auth.currentUser.uid)
        .collection("test")
        .doc()
        .set({
      'type': t.type,
      'result': t.result,
      'date': t.date,
      'location': t.location
    }).whenComplete(() => success = 1);

    return success;
  }

  Future<int> updateTest(TestModel t) async {
    int success;

     await firestore
        .collection("user")
        .doc(_auth.currentUser.uid)
        .collection("test")
        .doc(t.id)
        .update({
      'type': t.type,
      'result': t.result,
      'date': t.date,
      'location': t.location
    }).whenComplete(() => success = 1); 

    return success;
  }

  Future<int> deleteTest(TestModel t) async {
    int success;

    await FirebaseFirestore.instance
        .collection("user")
        .doc(_auth.currentUser.uid)
        .collection('test')
        .doc(t.id)
        .delete();

    return success;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTestStream() {
    var snapshot =
        FirebaseFirestore.instance
            .collection("user")
            .doc(_auth.currentUser.uid)
            .collection('test')
            .orderBy('date',descending:true)
            .snapshots();


    return snapshot;
  }

}
