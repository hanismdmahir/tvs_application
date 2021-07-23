import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tvs_application/Model/Test.dart';
import '../DAL/TestDAL.dart';

class TestBL{
  final TestDAL dl = TestDAL();

  Future<int> addTest(TestModel t) async {
    int success;

    success = await dl.addTest(t);

    return success;
  }

  Future<int> updateTest(TestModel t) async {
    int success;

    success = await dl.updateTest(t);

    return success;
  }

  Future<int> deleteTest(TestModel t) async {
    int success;

    success = await dl.deleteTest(t);

    return success;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTestStream() {
    var snapshot ;

    snapshot = dl.getTestStream();

    return snapshot;
  }

}

