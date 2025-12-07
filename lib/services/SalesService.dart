import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../providers/CartProvider.dart';
import '../services/AuthService.dart';

class SalesService {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  final CartProvider _cartProvider;

  final String _baseUrl = "http://127.0.0.1:8000/api";

  SalesService(
      this._dio,
      this._storage,
      this._cartProvider,
      );

  Future<String> _getAuthToken() async {
    final token =
    await _storage.read(key: AuthService.ACCESS_TOKEN_KEY);

    if (token == null) {
      throw Exception('Sesi telah berakhir. Mohon login ulang.');
    }

    return token;
  }

  Future<String> checkout({
    required String invoiceNumber,
    required int locationId,
    required String method,
    required String? paymentCode,
    String? buyerName,
  }) async {
    if (_cartProvider.items.isEmpty) {
      throw Exception('Keranjang belanja masih kosong.');
    }

    final token = await _getAuthToken();

    try {
      final payload = {
        'invoice_number': invoiceNumber,
        'location_id': locationId,
        'payment_method': method,
        'payment_code': paymentCode,
        'buyer_name': buyerName,
        'total_amount': _cartProvider.totalAmount,
        'items': _cartProvider.salePayloadItems,
      };

      final response = await _dio.post(
        '$_baseUrl/sales',
        data: payload,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 201) {
        _cartProvider.clearCart();
        return "Transaksi berhasil";
      }

      return "Transaksi gagal: Respon tidak valid.";
    } on DioException catch (e) {
      final msg = e.response?.data['error'] ??
          e.response?.data['message'] ??
          "Transaksi gagal.";
      throw Exception(msg);
    }
  }
}
