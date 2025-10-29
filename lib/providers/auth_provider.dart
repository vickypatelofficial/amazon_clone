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

  // PROFILE FIELDS
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

  // ✅ Load or Create User Profile
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
      // Create default profile if first login
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

  // ✅ Set picked image (Camera / Gallery)
  // ✅ Pick Image with source (camera or gallery)
  Future<void> pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      pickedImage = File(picked.path);
      notifyListeners(); // will refresh UI
    }
  }

  // ✅ Save profile (Upload image if changed)
  Future<void> saveProfile() async {
    print("🔥 saveProfile() called");

    if (user == null) {
      print("❌ user is NULL");
      return;
    }

    isLoading = true;
    notifyListeners();
    print("⏳ Loading true");

    final uid = user!.uid;
    String uploadedImageUrl = photo;

    print("👤 Current UID: $uid");
    print("📞 Phone: $phone");
    print("📝 Name: $name");
    print("🖼 Current Photo URL: $photo");
    print("📂 Picked Image: $pickedImage");

    try {
      // ✅ Upload Image if New Image Picked
      // if (pickedImage != null) {
      //   print("⬆ Uploading image to Firebase Storage...");
      //   final ref = FirebaseStorage.instance.ref().child("profile/$uid.jpg");
      //   await ref.putFile(pickedImage!);
      //   uploadedImageUrl = await ref.getDownloadURL();
      //   print("✅ Image Upload Success → $uploadedImageUrl");
      // } else {
      //   print("⚠ No new image picked. Skipping upload.");
      // }

      // ✅ Update Firestore
      print("🟢 Updating Firestore document...");
      await _db.collection('users').doc(uid).set({
        "name": name,
        "phone": phone,
        "photo": uploadedImageUrl,
        "email": user!.email,
      }, SetOptions(merge: true));

      print("✅ Firestore Updated Successfully!");

      // ✅ Update Local
      photo = uploadedImageUrl;
      pickedImage = null;
    } catch (e) {
      print("❌ ERROR while saving profile: $e");
    }

    isLoading = false;
    notifyListeners();
    print("✅ Done. Loading false");
  }

  // ✅ Login
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

  // ✅ Register
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

  // ✅ Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
