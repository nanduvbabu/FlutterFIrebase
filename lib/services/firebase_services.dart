import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/models/product.dart';

class FirebaseService {
  // These are code that are used in firebase for creating a collection in firebase actualy firebase are build as a nosql database so it would be different from normal one so its a collection of datas
  final CollectionReference _productCollection = FirebaseFirestore.instance
      .collection('products');

  Future<void> addProduct(Product product) async {
    final docRef = await _productCollection.add(product.toMap());
    await docRef.update({'id': docRef.id});
  }

  Stream<List<Product>> getAllProducts() {
    return _productCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}

//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   FirebaseService();
//   Future<bool> addUser() async {
//     Map<String, dynamic>  userData = {
//       'name': 'leo',
//       'age':'23',
//       'address':'chanassery House',
//       'phoneNumber':'8848012893'
//     };
//     try {
//       await _db.toMap().add(userData);
//       return true;
//     }
//     catch (e) {
//       return false;
//     }
//   }
// }
