import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../services/vm_services.dart';

class VmListCard extends StatelessWidget {
  final Map<String, dynamic> vm;
  final VmService vmService;

  const VmListCard({
    super.key,
    required this.vm,
    required this.vmService,
  });
  // perform action on a VM
  void _performAction(BuildContext context, String action) async {
    try {
      await vmService.actOnVm(
        type: vm['type'] ?? '',
        node: vm['node'] ?? '',
        vmid: vm['vmid'] ?? 0,
        action: action,
      );
      ShadToaster.of(context).show(
        ShadToast(
          description: Text('Action "$action" sent to ${vm['name'] ?? vm['vmid']}'),
        ),
      );
    } catch (e) {
      ShadToaster.of(context).show(
        ShadToast(
          description: Text('Action failed: $e'),
        ),
      );
    }
  }

  ShadBadge _statusBadge(BuildContext context, String status) {
    final s = status.toLowerCase();
    final isDark = ShadTheme.of(context).brightness == Brightness.dark;
    Color dot;
    if (s == 'running' ) {
      dot = isDark ? const Color(0xFF34D399) : const Color(0xFF16A34A);
    } else if (s == 'stopped') {
      dot = isDark ? const Color(0xFFFCA5A5) : const Color(0xFFDC2626);
    } else {
      dot = isDark ? const Color(0xFFFDE68A) : const Color(0xFFD97706);
    }
    return ShadBadge(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(status),
        ],
      ),
    );
  }

 
  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ShadCard(
      width: double.infinity,
      title: Text(vm['name'] ?? 'Unnamed VM', style: theme.textTheme.h4),
      description: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _statusBadge(context, vm['status'] ?? 'unknown'),
              const SizedBox(width: 8),
              Text("Node: ${vm['node']}", style: theme.textTheme.small),
              const SizedBox(width: 8),
              Text("ID: ${vm['vmid']}", style: theme.textTheme.small),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ShadTheme(
            data: ShadTheme.of(context).copyWith(
              primaryButtonTheme: const ShadButtonTheme(
                backgroundColor: Color(0xFFFBBF24), // amber-400
              ),
            ),
            child: ShadButton(
              child: const Text('Reboot'),
              onPressed: () => _performAction(context, 'reboot'),
            ),
          ),
          const SizedBox(width: 8),
          ShadTheme(
            data: ShadTheme.of(context).copyWith(
              primaryButtonTheme: const ShadButtonTheme(
                backgroundColor: Color(0xFFF87171), // red-400
              ),
            ),
            child: ShadButton(
              child: const Text('Shutdown'),
              onPressed: () => _performAction(context, 'shutdown'),
            ),
          ),
          const SizedBox(width: 8),
          ShadTheme(
            data: ShadTheme.of(context).copyWith(
              primaryButtonTheme: const ShadButtonTheme(
                backgroundColor: Color(0xFF34D399), // green-400
              ),
            ),
            child: ShadButton(
              child: const Text('Start'),
              onPressed: () => _performAction(context, 'start'),
            ),
          ),
        ],
      ),
    );
  }
}