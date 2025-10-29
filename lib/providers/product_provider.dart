import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<ProductModel> products = [];
  List<ProductModel> filteredProducts = [];

  bool isLoading = false;
  String query = "";

  ProductProvider() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading = true;
    notifyListeners();

    final snap = await _db.collection('products').get();
    products = snap.docs.map((d) => ProductModel.fromMap(d.id, d.data())).toList();
 
    filteredProducts = List.from(products);

    isLoading = false;
    notifyListeners();
  }
 
  void search(String q) {
    query = q.toLowerCase();

    if (query.isEmpty) {
      filteredProducts = List.from(products);
    } else {
      filteredProducts = products.where((p) {
        return p.name.toLowerCase().contains(query) ||
            p.category.toLowerCase().contains(query);
      }).toList();
    }

    notifyListeners();
  }
 
  // Future<void> addDummyProductsIfNeeded() async {
  //   final productsSnapshot = await _db.collection('products').get();
  //   if (productsSnapshot.docs.isNotEmpty) return;

  //   List<ProductModel> dummyProducts = List.generate(20, (index) {
  //     return ProductModel(
  //       id: '$index',
  //       name: "Sample Product ${index + 1}",
  //       description: "This is the description of Sample Product ${index + 1}.",
  //       price: (index + 1) * 99,
  //       category: index % 2 == 0 ? "Electronics" : "Fashion",
  //       imageUrl: "https://picsum.photos/200?random=$index",
  //     );
  //   });

  //   WriteBatch batch = _db.batch();
  //   for (var product in dummyProducts) {
  //     DocumentReference docRef = _db.collection('products').doc();
  //     batch.set(docRef, product.toMap());
  //   }
  //   await batch.commit();

  //   fetchProducts(); // refresh UI
  // }

 

  List<ProductModel> byCategory(String category) => products.where((p) => p.category == category).toList();

    Map<String, ProductModel> get productMap {
    return { for (var p in products) p.id: p };
  }
}
