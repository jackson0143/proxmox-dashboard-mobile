import 'package:flutter/material.dart';
import 'pages/vm_list_page.dart';


// root widget, includes the app bar and the home page
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proxmox Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 51, 212, 64)),
      ),
      home: const VmListPage(),
    );
  }
}
