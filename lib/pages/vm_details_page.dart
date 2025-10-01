import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class VmDetailsPage extends StatelessWidget {
  final Map<String, dynamic> vm;

  const VmDetailsPage({super.key, required this.vm});

  String _formatPercent(double value) {
    return value.isNaN ? '-' : '${value.toStringAsFixed(1)}%';
  }

  String _formatBytes(num bytes) {
    final b = bytes.toDouble();
    if (b <= 0) return '0 B';
    const units = ['B', 'KiB', 'MiB', 'GiB', 'TiB'];
    int i = 0;
    double size = b;
    while (size >= 1024 && i < units.length - 1) {
      size /= 1024;
      i++;
    }
    return '${size.toStringAsFixed(2)} ${units[i]}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    final String name = (vm['name'] ?? 'Unnamed VM').toString();
    final String node = (vm['node'] ?? '').toString();
    final int vmid = (vm['vmid'] is int)
        ? vm['vmid'] as int
        : int.tryParse(vm['vmid']?.toString() ?? '0') ?? 0;
    final String status = (vm['status'] ?? '').toString();

    final double cpuFraction = (vm['cpu'] is num) ? (vm['cpu'] as num).toDouble() : 0.0;
    final double cpuPct = (cpuFraction * 100).clamp(0, 100);

    final num mem = (vm['mem'] is num) ? vm['mem'] as num : 0;
    final num maxmem = (vm['maxmem'] is num) ? vm['maxmem'] as num : 0;
    final double memPct = (maxmem > 0) ? (mem.toDouble() / maxmem.toDouble()) * 100 : 0.0;

    final num disk = (vm['disk'] is num) ? vm['disk'] as num : 0;
    final num maxdisk = (vm['maxdisk'] is num) ? vm['maxdisk'] as num : 0;
    final double diskPct = (maxdisk > 0) ? (disk.toDouble() / maxdisk.toDouble()) * 100 : 0.0;

    return Scaffold(
      appBar: AppBar(title: Text('Details • $name')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ShadCard(
            title: Text(name, style: theme.textTheme.h3),
            description: Text('Node: $node  •  ID: $vmid  •  Status: ${status.isEmpty ? 'Unknown' : status}'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text('CPU Usage', style: theme.textTheme.muted),
                const SizedBox(height: 6),
                LinearProgressIndicator(value: cpuPct / 100, minHeight: 8),
                const SizedBox(height: 4),
                Text(_formatPercent(cpuPct)),

                const SizedBox(height: 16),
                Text('Memory', style: theme.textTheme.muted),
                const SizedBox(height: 6),
                LinearProgressIndicator(value: (memPct / 100).clamp(0, 1), minHeight: 8),
                const SizedBox(height: 4),
                Text('${_formatBytes(mem)} of ${_formatBytes(maxmem)} (${_formatPercent(memPct)})'),

                const SizedBox(height: 16),
                Text('Disk', style: theme.textTheme.muted),
                const SizedBox(height: 6),
                LinearProgressIndicator(value: (diskPct / 100).clamp(0, 1), minHeight: 8),
                const SizedBox(height: 4),
                Text('${_formatBytes(disk)} of ${_formatBytes(maxdisk)} (${_formatPercent(diskPct)})'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


