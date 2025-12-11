import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../providers/CartProvider.dart';
import '../services/AuthService.dart';

class SalesService {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  final CartProvider _cartProvider;
  final String _baseUrl = "https://inventara.my.id/api";

  Map<String, dynamic>? lastSale;

  SalesService(this._dio, this._storage, this._cartProvider);

  Future<String> _getAuthToken() async {
    final token = await _storage.read(key: AuthService.ACCESS_TOKEN_KEY);

    if (token == null) {
      throw Exception('Sesi telah berakhir. Mohon login ulang.');
    }

    return token;
  }

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
          _cartProvider.clearCart();

          final invoiceData = Map<String, dynamic>.from(
            data['data'] as Map<String, dynamic>,
          );
          lastSale = invoiceData;

          return invoiceData;
        }

        final msg =
            data['error']?.toString() ??
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
          msg = data['error']?.toString() ?? data['message']?.toString() ?? msg;
        } else if (data is String) {
          msg = data;
        } else {
          msg = 'HTTP ${res.statusCode}: ${res.statusMessage ?? 'Error'}';
        }

        print('DioException response data: ${res.data}');
      } else {
        msg = e.message ?? msg;
      }

      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> fetchSalesHistory() async {
    final token = await _getAuthToken();

    try {
      final response = await _dio.get(
        '$_baseUrl/sales',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data is Map) {
        final data = response.data as Map<String, dynamic>;
        final List<dynamic> rows = data['data'] ?? [];
        return rows.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }

      throw Exception('Gagal memuat riwayat penjualan.');
    } on DioException catch (e) {
      final msg = e.response?.data.toString() ?? e.message ?? 'Error';
      throw Exception('Gagal memuat riwayat: $msg');
    } catch (e) {
      throw Exception('Gagal memuat riwayat: $e');
    }
  }
}
