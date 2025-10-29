import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<ProductModel>> productsStream() {
    return _db.collection('products').snapshots().map((snap) =>
        snap.docs.map((d) => ProductModel.fromMap(d.id, d.data())).toList());
  }

  Future<ProductModel?> getById(String id) async {
    final doc = await _db.collection('products').doc(id).get();
    if (!doc.exists) return null;
    return ProductModel.fromMap(doc.id, doc.data()!);
  }

  Future<List<String>> fetchCategories() async {
    final snap = await _db.collection('products').get();
    final cats = <String>{};
    for (final d in snap.docs) {
      final c = d.data()['category'] as String?;
      if (c != null) cats.add(c);
    }
    return cats.toList();
  }
}
