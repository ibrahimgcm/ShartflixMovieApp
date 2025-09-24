import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  String? _photoPath;

  String? get photoPath => _photoPath;

  void setPhotoPath(String? path) {
    _photoPath = path;
    notifyListeners();
  }

  void clearPhoto() {
    _photoPath = null;
    notifyListeners();
  }

  // Beğenilen filmler listesi
  final List<Map<String, dynamic>> _likedMovies = [];

  List<Map<String, dynamic>> get likedMovies => List.unmodifiable(_likedMovies);

  void addLikedMovie(Map<String, dynamic> movie) {
    if (!_likedMovies.any((m) => m['id'] == movie['id'])) {
      _likedMovies.add(movie);
      notifyListeners();
    }
  }

  void removeLikedMovie(int movieId) {
    _likedMovies.removeWhere((m) => m['id'] == movieId);
    notifyListeners();
  }

  void clearLikedMovies() {
    _likedMovies.clear();
    notifyListeners();
  }
}
