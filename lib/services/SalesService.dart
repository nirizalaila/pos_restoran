import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../providers/CartProvider.dart';
import '../services/AuthService.dart';

class SalesService {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  final CartProvider _cartProvider;

  // SESUAIKAN kalau pakai emulator/device:
  // - Android emulator: http://10.0.2.2:8000/api
  // - Device fisik: http://IP-LAPTOP:8000/api
  final String _baseUrl = "http://127.0.0.1:8000/api";

  SalesService(
      this._dio,
      this._storage,
      this._cartProvider,
      );

  Future<String> _getAuthToken() async {
    final token = await _storage.read(key: AuthService.ACCESS_TOKEN_KEY);

    if (token == null) {
      throw Exception('Sesi telah berakhir. Mohon login ulang.');
    }

    return token;
  }

  /// Checkout
  /// - kirim transaksi ke /api/sales
  /// - kalau sukses → clear cart
  /// - return: data invoice (map) untuk ditampilkan di struk
  Future<Map<String, dynamic>> checkout({
    required String invoiceNumber,
    required int locationId,
    required String method,
    String? paymentCode,
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

      if (response.statusCode == 201 && response.data is Map) {
        final data = response.data as Map;

        if (data['success'] == true) {
          // kosongkan keranjang
          _cartProvider.clearCart();

          // kembalikan data invoice untuk ditampilkan
          final invoiceData =
          Map<String, dynamic>.from(data['data'] as Map<String, dynamic>);

          return invoiceData;
        }

        final msg = data['error']?.toString() ??
            data['message']?.toString() ??
            'Transaksi gagal.';
        throw Exception(msg);
      }

      throw Exception('Transaksi gagal: Respon tidak valid.');
    } on DioException catch (e) {
      String msg = 'Transaksi gagal.';

      if (e.response != null) {
        final res = e.response!;
        final data = res.data;

        if (data is Map) {
          msg = data['error']?.toString() ??
              data['message']?.toString() ??
              msg;
        } else if (data is String) {
          msg = data;
        } else {
          msg = 'HTTP ${res.statusCode}: ${res.statusMessage ?? 'Error'}';
        }

        // debug ke console
        // ignore: avoid_print
        print('DioException response data: ${res.data}');
      } else {
        msg = e.message ?? msg;
      }

      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
