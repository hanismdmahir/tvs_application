
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tvs_application/Model/User.dart';
import '../DAL/AccountDAL.dart';

class AccountBL {
  final AccountDAL a = AccountDAL();

  Future<String> register(UserModel u) async {
      String msg;
      
      msg = await a.register(u);

      return msg;
  }

  Future<String> signIn(String email, String password) async {
      String msg;
      
      msg = await a.signIn(email, password);

      return msg;
  }

  Future<UserModel> getUserDataModel() async {
    var id = a.getUserID();

    UserModel u = await a.getUserDataModel(id);

    return u;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDataStream() {
    var snapshot = a.getUserDataStream(getUserID());

    return snapshot;
  }

  String getUserID() {
    return a.getUserID();
  }

  

  Future<int> update1UserData(String field, String updateData) async{
    int update ;

    var id = a.getUserID();

    update = await a.update1UserData(field,updateData, id);

    return update;
  }



}