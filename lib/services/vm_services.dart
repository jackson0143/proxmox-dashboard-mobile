import 'package:dio/dio.dart';
import '../config/api.dart';

class VmService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: apiBase,
    headers: {'X-API-Key': apiKey},
  ));

// fetch all VMs
  Future<List<dynamic>> fetchVms() async {
    final res = await _dio.get('/api/vms');
    return res.data;
  }

  //POST action on a VM
  Future<dynamic> actOnVm({
    required String type, // 'qemu' or 'lxc'
    required String node,
    required int vmid,
    required String action, // reboot|shutdown|start|stop
  }) async {
    final res = await _dio.post('/api/$type/$node/$vmid/$action');
    return res.data;
  }
}
