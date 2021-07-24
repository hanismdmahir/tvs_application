import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tvs_application/Model/User.dart';
import '../DAL/AccountDAL.dart';

class AccountBL {
  final AccountDAL a = AccountDAL();

  Future<String> register(UserModel u, String pnId) async {
    String msg;

    msg = await a.register(u,pnId);

    return msg;
  }

  Future<String> signIn(String email, String password) async {
    String msg;

    msg = await a.signIn(email, password);

    return msg;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getPatientListStream(
      UserModel u) {
    var snapshot = a.getPatientListStream(u);
    return snapshot;
  }

  Future<String> getPNID(String code) async {

    String id = await a.getPNID(code);

    return id;
  }

  Future<UserModel> getUserDataModel() async {
    var id = a.getUserID();

    UserModel u = await a.getUserDataModel(id);

    return u;
  }

  Future<UserModel> getUserDataModelByID(String id) async {
    UserModel u = await a.getUserDataModel(id);

    return u;
  }
  Stream<DocumentSnapshot<Map<String, dynamic>>> getPatientChatStream(UserModel u) {
    var snapshot = a.getPatientChatStream(u);

    return snapshot;
  }
  

  Stream<QuerySnapshot<Map<String, dynamic>>> getPeerDataStream(UserModel u) {
    var snapshot = a.getPeerDataStream(u);

    return snapshot;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDataStream() {
    var snapshot = a.getUserDataStream(getUserID());

    return snapshot;
  }

  String getUserID() {
    return a.getUserID();
  }

  Future<int> update1UserData(String field, String updateData) async {
    int update;

    var id = a.getUserID();

    update = await a.update1UserData(field, updateData, id);

    return update;
  }
}
