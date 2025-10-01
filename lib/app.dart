import 'package:flutter/material.dart';
import 'pages/vm_list_page.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

// root widget, includes the app bar and the home page
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp(
      title: 'Proxmox Dashboard',
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: const ShadSlateColorScheme.light(
          background: Color(0xFFF7F7F8),
          card: Color(0xFFFFFFFF),
        ),
        primaryButtonTheme: const ShadButtonTheme(
          backgroundColor: Color(0xFF0A84FF)
        ),
      ),
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: const ShadSlateColorScheme.dark(
          background: Color(0xFF1C1C1E),
          card: Color(0xFF2C2C2E),
        ),
        primaryButtonTheme: const ShadButtonTheme(
          backgroundColor: Color(0xFF8E8E93)
        ),
      ),
      home: const ShadToaster(
        child: VmListPage(),
      ),
    );
  }
}
