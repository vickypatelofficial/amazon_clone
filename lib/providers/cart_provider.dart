import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import 'auth_provider.dart';

class CartProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  AuthProvider? _auth;
  Map<String, int> items = {}; // productId -> qty
  StreamSubscription<DocumentSnapshot>? _sub;

  void updateAuth(AuthProvider auth) {
    _auth = auth;
    _sub?.cancel();
    if (auth.isAuthenticated) {
      _listenToRemoteCart(auth.user!.uid);
    } else {
      items.clear();
      notifyListeners();
    }
  }

  void _listenToRemoteCart(String uid) {
    final doc = _db.collection('carts').doc(uid);
    _sub = doc.snapshots().listen((snap) {
      if (!snap.exists) return;
      final data = snap.data()!['items'] as Map<String, dynamic>?;
      if (data == null) return;
      items = data.map((k, v) => MapEntry(k, (v as int)));
      notifyListeners();
    });
  }

  Future<void> addItem(ProductModel p, {int qty = 1}) async {
    items[p.id] = (items[p.id] ?? 0) + qty;
    notifyListeners();
    await _saveToRemote();
  }

  Future<void> removeItem(String productId) async {
    items.remove(productId);
    notifyListeners();
    await _saveToRemote();
  }

  Future<void> updateQuantity(String productId, int qty) async {
    if (qty <= 0)
      items.remove(productId);
    else
      items[productId] = qty;
    notifyListeners();
    await _saveToRemote();
  }

  double totalPrice(Map<String, ProductModel> catalog) {
    double total = 0.0;
    items.forEach((pid, qty) {
      final p = catalog[pid];
      if (p != null) total += p.price * qty;
    });
    return total;
  }

  Future<void> _saveToRemote() async {
    if (_auth?.user == null) return;
    final doc = _db.collection('carts').doc(_auth!.user!.uid);
    await doc.set({'items': items});
  }

  bool isInCart(String productId) {
    return items.containsKey(productId);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
