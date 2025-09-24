import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class User {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;

  User({required this.id, required this.name, required this.email, this.photoUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'],
    );
  }
}

class AuthProvider extends ChangeNotifier {
  String? _token;
  User? _user;

  String? get token => _token;
  User? get user => _user;

  void setAuth(String token, User user) {
    _token = token;
    _user = user;
    notifyListeners();
  }

  void clearAuth() {
    _token = null;
    _user = null;
    notifyListeners();
  }

  void logout() {
    clearAuth();
  }

  Future<String?> registerWithEmail(String name, String email, String password) async {
    try {
      final credential = await fb.FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      await credential.user?.updateDisplayName(name);
      _user = User(id: credential.user?.uid ?? '', name: name, email: email, photoUrl: credential.user?.photoURL);
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> loginWithEmail(String email, String password) async {
    try {
      final credential = await fb.FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      _user = User(id: credential.user?.uid ?? '', name: credential.user?.displayName ?? '', email: email, photoUrl: credential.user?.photoURL);
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
