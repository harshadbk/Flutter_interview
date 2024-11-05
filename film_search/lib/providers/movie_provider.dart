import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MovieProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<dynamic> _movies = [];
  bool _isLoading = false;

  List<dynamic> get movies => _movies;
  bool get isLoading => _isLoading;

  Future<void> fetchPopularMovies() async {
    _isLoading = true;
    notifyListeners();
    _movies = await _apiService.getPopularMovies();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchMovies(String query) async {
    _isLoading = true;
    notifyListeners();
    _movies = await _apiService.searchMovies(query);
    _isLoading = false;
    notifyListeners();
  }
}
