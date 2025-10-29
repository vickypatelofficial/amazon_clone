import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? user;
  bool isLoading = false;

  String name = "";
  String phone = "";
  String photo = "";
  File? pickedImage;

  AuthProvider() {
    _auth.authStateChanges().listen((u) async {
      user = u;
      if (user != null) {
        await loadUserData();
      }
      notifyListeners();
    });
  }

  bool get isAuthenticated => user != null;

  Future<void> loadUserData() async {
    if (user == null) return;
    isLoading = true;
    notifyListeners();

    final uid = user!.uid;
    final doc = await _db.collection('users').doc(uid).get();

    if (doc.exists && doc.data() != null) {
      name = doc.data()!['name'] ?? "";
      phone = doc.data()!['phone'] ?? "";
      photo = doc.data()!['photo'] ?? "";
    } else {
      name = user!.email?.split('@')[0] ?? "";
      phone = "";
      photo = "";

      await _db.collection('users').doc(uid).set({
        "name": name,
        "phone": phone,
        "photo": photo,
        "email": user!.email,
        "createdAt": DateTime.now(),
      });
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      pickedImage = File(picked.path);
      notifyListeners();
    }
  }

  Future<void> saveProfile() async {
    if (user == null) return;

    isLoading = true;
    notifyListeners();

    final uid = user!.uid;
    String uploadedImageUrl = photo;

    try {
      if (pickedImage != null) {
        final ref = FirebaseStorage.instance.ref().child("profile/$uid.jpg");
        await ref.putFile(pickedImage!);
        uploadedImageUrl = await ref.getDownloadURL();
      }

      await _db.collection('users').doc(uid).set({
        "name": name,
        "phone": phone,
        "photo": uploadedImageUrl,
        "email": user!.email,
      }, SetOptions(merge: true));

      photo = uploadedImageUrl;
      pickedImage = null;
    } catch (e) {}

    isLoading = false;
    notifyListeners();
  }

  Future<String?> loginWithEmail(String email, String pass) async {
    isLoading = true;
    notifyListeners();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: pass);
      await loadUserData();
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> registerWithEmail(String email, String pass) async {
    isLoading = true;
    notifyListeners();
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      await loadUserData();
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
