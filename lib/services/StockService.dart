import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pos_restoran/services/AuthService.dart';

class StockService with ChangeNotifier {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _baseUrl = "https://inventara.my.id/api";

  Future<String> _getAuthToken() async {
    final token = await _storage.read(key: AuthService.ACCESS_TOKEN_KEY);
    if (token == null) {
      throw Exception('Sesi telah berakhir. Mohon login ulang.');
    }
    return token;
  }

  Future<List<Map<String, dynamic>>> fetchStockSummary() async {
    final token = await _getAuthToken();

    try {
      final response = await _dio.get(
        '$_baseUrl/reports/stock-summary',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final raw = response.data;

        List<dynamic> rows = [];

        if (raw is Map<String, dynamic>) {
          final topData = raw['data'];
          if (topData is List) {
            rows = topData;
          } else {
            rows = [];
          }
        } else if (raw is List) {
          rows = raw;
        }

        return rows.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }

      throw Exception('Gagal memuat data stok.');
    } on DioException catch (e) {
      final msg = e.response?.data.toString() ?? e.message ?? 'Error';
      throw Exception('Gagal memuat stok: $msg');
    } catch (e) {
      throw Exception('Gagal memuat stok: $e');
    }
  }
}
