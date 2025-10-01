import 'package:flutter/material.dart';
import '../services/vm_services.dart';

class VmListPage extends StatefulWidget {
  const VmListPage({super.key});
  @override
  State<VmListPage> createState() => _VmListPageState();
}

class _VmListPageState extends State<VmListPage> {
  final VmService _vmService = VmService();
  List<dynamic> _vms = [];
  String _status = 'Tap button to load VMs';

  Future<void> _fetchVms() async {
    setState(() => _status = 'Loading...');
    try {
      final vms = await _vmService.fetchVms();
      setState(() {
        _vms = vms;
        _status = 'Loaded ${_vms.length} VMs';
      });
    } catch (e) {
      setState(() => _status = 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VMs')),
      body: _vms.isEmpty
          ? Center(child: Text(_status))
          : ListView.builder(
              itemCount: _vms.length,
              itemBuilder: (context, index) {
                final vm = _vms[index];
                return ListTile(
                  title: Text(vm['name'] ?? 'Unnamed VM'),
                  subtitle: Text("Status: ${vm['status']} • Node: ${vm['node']}"),
                  trailing: Text("VMID: ${vm['vmid']}"),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchVms,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
