import 'package:flutter/material.dart';
import '../services/vm_services.dart';
import '../widgets/vm_list_card.dart';

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
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final vm = _vms[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: VmListCard(vm: vm, vmService: _vmService),
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
