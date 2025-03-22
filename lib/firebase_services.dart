import 'package:cloud_firestore/cloud_firestore.dart';


class FirebaseService {


  // These are code that are used in firebase for creating a collection in firebase actualy firebase are build as a nosql database so it would be different from normal one so its a collection of datas

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseService();
  Future<bool> addUser() async {
    Map<String, dynamic> userData = {
      'name': 'leo',
      'age':'23',
      'address':'chanassery House',
      'phoneNumber':'8848012893'
    };
    try {
      await _db.collection('Customer').add(userData);
      return true;
    }
    catch (e) {
      return false;
    }
  }
}