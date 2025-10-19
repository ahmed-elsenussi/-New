// IMPORT
import'package:flutter/material.dart';
import 'package:camera/camera.dart';


// PAGES
import 'pages/register/register.dart';
import 'pages/camera/camera.dart';

void main () async {

  // try printing...
  print("hello world");

  // TO DEAL WITH PHONE PLATFORM, HARDRWARE, NATIVE SYSTEM
  // Hey Flutter, get ready to talk to the device hardware and platform plugins before I start running code.
  WidgetsFlutterBinding.ensureInitialized();

  // camera variables
  final cameras = await availableCameras();
  final firstCamera = cameras.first;


  // function for creating app
  runApp(MyApp(camera : firstCamera));

}


// ROOT WIDGET
class MyApp extends StatelessWidget {

  // INPUTS
  final CameraDescription camera;
  
  // rebuild || reuse [constructor]
  const MyApp({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/register',
      routes: {
        '/register': (context) =>  RegisterPage(),
        '/camera': (context) => CameraPage(camera: camera),
      },
    );
    
  }
}