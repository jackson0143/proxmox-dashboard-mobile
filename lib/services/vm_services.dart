import 'package:dio/dio.dart';
import '../config/api.dart';

class VmService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: apiBase,
    headers: {'X-API-Key': apiKey},
  ));

  Future<List<dynamic>> fetchVms() async {
    final res = await _dio.get('/api/vms');
    return res.data;
  }
}
