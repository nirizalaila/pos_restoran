import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pos_restoran/models/Product.dart';
import '../services/AuthService.dart';

class ProductService with ChangeNotifier {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _baseUrl = "https://inventara.my.id/api";

  List<Product> _products = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Product> get products => List.unmodifiable(_products);

  ProductService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _getAuthToken();
          options.headers['Accept'] = 'application/json';
          options.headers['Authorization'] = 'Bearer $token';
          handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {}
          handler.next(e);
        },
      ),
    );
  }

  Future<String> _getAuthToken() async {
    final token = await _storage.read(key: AuthService.ACCESS_TOKEN_KEY);
    if (token == null) {
      throw Exception('Sesi telah berakhir. Mohon login ulang.');
    }
    return token;
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _dio.get('$_baseUrl/products?type=menu');

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final List<dynamic> productJson = response.data['data']['data'];

        _products = productJson
            .map((json) => Product.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        _products = [];
        throw Exception(
          'Gagal memuat menu: ${response.data['message'] ?? 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      _products = [];
      String message = 'Gagal memuat menu';
      if (e.response != null) {
        message +=
            ': ${e.response?.data['message'] ?? e.response?.statusMessage}';
      } else {
        message += ': ${e.message}';
      }
      throw Exception(message);
    } catch (e) {
      _products = [];
      throw Exception('Gagal memuat menu: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
