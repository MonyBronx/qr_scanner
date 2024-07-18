import 'package:admin_flutter/database/main_database.dart';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_html/html.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();


    WidgetsBinding.instance.addPostFrameCallback((_){
      getCameraPermission();
      requestCameraAccess();
    });
  }

  getCameraPermission() async{
    var cameraStatus = await Permission.camera.status;
    print('is camera status denied ${cameraStatus.isDenied}');
    if (cameraStatus.isDenied){
      await Permission.camera
      .onDeniedCallback((){})
      .onGrantedCallback((){
      })
      .request();
    }
  }

  Future<MediaStream> requestCameraAccess() async {
    final mediaDevices = window.navigator.mediaDevices;
    if (mediaDevices == null) {
      throw Exception("MediaDevices API not supported");
    }

    try {
      final stream = await mediaDevices.getUserMedia();
      return stream;
    } on DomException catch (e) {
      // Handle permission denied error
      if (e.name == 'PermissionDeniedError') {
        // Show a message to the user indicating permission was denied
        print("Camera permission denied");
      }
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AiBarcodeScanner(
      onDetect: (BarcodeCapture barcodeCapture) {
        debugPrint("${barcodeCapture.raw}");
        debugPrint("${barcodeCapture.size}");
        debugPrint("${barcodeCapture.image}");
        for (var bar in barcodeCapture.barcodes){
          debugPrint("$bar");
        }
      },
    );
  }
}
