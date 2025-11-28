import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';

class AuthService with ChangeNotifier {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _baseUrl = "http://10.0.2.2:8000/api"; // <-- SESUAIKAN IP

  static const String ACCESS_TOKEN_KEY = 'sanctum_token';

  User? _currentUser;
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;
  User? get currentUser => _currentUser;

  Future<void> checkLoginStatus() async {
    final token = await _storage.read(key: ACCESS_TOKEN_KEY);
    _isLoggedIn = token != null;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final token = response.data['data']['token'];
        final userJson = response.data['data']['user'];

        await _storage.write(key: ACCESS_TOKEN_KEY, value: token);
        _currentUser = User.fromJson(userJson);
        _isLoggedIn = true;
        notifyListeners();
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            'Login gagal, cek koneksi atau kredensial.',
      );
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: ACCESS_TOKEN_KEY);
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
