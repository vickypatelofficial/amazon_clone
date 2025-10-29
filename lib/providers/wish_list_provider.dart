import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'auth_provider.dart';

class WishlistProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  AuthProvider? _auth;

  Set<String> wishlist = {}; // productId only
  StreamSubscription<DocumentSnapshot>? _sub;

  void updateAuth(AuthProvider auth) {
    _auth = auth;
    _sub?.cancel();

    if (auth.isAuthenticated) {
      _listenToRemote(auth.user!.uid);
    } else {
      wishlist.clear();
      notifyListeners();
    }
  }

  void _listenToRemote(String uid) {
    final doc = _db.collection('wishlists').doc(uid);

    _sub = doc.snapshots().listen((snap) {
      if (!snap.exists) return;
      final data = snap.data()!['items'] as Map<String, dynamic>?;
      if (data == null) return;
      wishlist = data.keys.toSet();
      notifyListeners();
    });
  }

  Future<void> toggleWishlist(ProductModel p) async {
    if (wishlist.contains(p.id)) {
      wishlist.remove(p.id);
    } else {
      wishlist.add(p.id);
    }
    notifyListeners();
    await _saveToRemote();
  }

  Future<void> _saveToRemote() async {
    if (_auth?.user == null) return;
    final doc = _db.collection('wishlists').doc(_auth!.user!.uid);
    await doc.set({'items': {for (var id in wishlist) id: true}});
  }

  bool isWishlisted(String productId) {
    return wishlist.contains(productId);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
