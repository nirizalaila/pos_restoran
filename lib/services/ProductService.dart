import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pos_restoran/models/Product.dart';
import '../services/AuthService.dart';

class ProductService with ChangeNotifier {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _baseUrl = "http://127.0.0.1:8000/api";

  List<Product> _products = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<Product> get products => _products;

  Future<String> _getAuthToken() async {
    final token = await _storage.read(key: AuthService.ACCESS_TOKEN_KEY);
    if (token == null)
      throw Exception('Sesi telah berakhir. Mohon login ulang.');
    return token;
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _getAuthToken();
      final response = await _dio.get(
        '$_baseUrl/products?type=menu',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final List<dynamic> productJson = response.data['data']['data'];

        _products = productJson.map((json) => Product.fromJson(json)).toList();
      }
    } catch (e) {
      _products = [];
      throw Exception('Gagal memuat menu: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
