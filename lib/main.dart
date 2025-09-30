import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:dio/dio.dart';


const apiBase = String.fromEnvironment('API_BASE', defaultValue: 'http://localhost:8000');
const apiKey  = String.fromEnvironment('API_KEY',  defaultValue: '');

void main() {
  runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => const MyApp(),
  ));
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  String _result = 'Tap the cloud to call /api/vms';

  // Reuse the values you already defined at the top of the file:
  // const apiBase = String.fromEnvironment('API_BASE', defaultValue: 'http://localhost:8000');
  // const apiKey  = String.fromEnvironment('API_KEY',  defaultValue: '');
  late final Dio _dio = Dio(BaseOptions(
    baseUrl: apiBase,
    headers: {'X-API-Key': apiKey},
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
  ));

  Future<void> _fetchVms() async {
    setState(() => _result = 'Loading...');
    try {
      final res = await _dio.get('/api/vms');
      if (res.data is List) {
        setState(() => _result = 'OK: ${(res.data as List).length} VMs');
      } else {
        setState(() => _result = 'OK: ${res.data.toString()}');
      }
    } catch (e) {
      setState(() => _result = 'ERR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // helpful to confirm wiring
            Text('API_BASE: $apiBase'),
            Text('API_KEY: ${apiKey.isEmpty ? "(none)" : "(set)"}'),
            const SizedBox(height: 16),
            Text(_result, textAlign: TextAlign.center),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchVms,
        tooltip: 'Fetch /api/vms',
        child: const Icon(Icons.cloud_download),
      ),
    );
  }
}
