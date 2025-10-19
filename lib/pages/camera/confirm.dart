import 'package:camera/camera.dart';
import 'package:card_register/pages/camera/camera.dart';
import 'package:card_register/pages/register/register.dart';
import 'package:card_register/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// for get the image file
import 'dart:io';

// for conversion of the response
import 'dart:convert';

class ConfirmPage extends StatelessWidget {

  // input
  final String imagePath;
  final CameraDescription camera;
  const ConfirmPage({super.key, required this.imagePath, required this.camera}); 

  // methods
  Future<void> sendCardImage(context) async {
    final url = Uri.parse("http://192.168.1.4:8000/users/detect_nid/");

    // request
    print("sending request...");
    var request = http.MultipartRequest('POST', url);
    request.files.add( await http.MultipartFile.fromPath('image', imagePath));

    // response
    print("getting response...");
    var response  = await request.send();
    var responseBody = await response.stream.bytesToString();
    print("the response = ${responseBody}");
    var decoded = jsonDecode(responseBody); 

    // 200 ?
    if (response.statusCode == 200) {
      print("Done Detect the id");


       Navigator.pushAndRemoveUntil( context, 
        MaterialPageRoute( builder: (context) => RegisterPage(nid: decoded['nid']),),
        (Route<dynamic> route) => false, // remove all previous pages
        );

    }
    else { 
      final errorMessage = decoded['error'] ?? 'Unknown error occurred';
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraPage(
            camera: camera,
            messageError: errorMessage,
          ),
        ),
      );
 }
  }


  // build
  @override Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("التأكيد على الصوره"),),
      body: Stack(
        children: [

          // image
          SizedBox.expand(
            child: Image.file(
              File(imagePath),
              fit: BoxFit.cover,
            ),
          ),

        
          // confirm/cancell button
          Positioned(
            bottom: 40,
            left: 30,
            right: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(txt: "اعادة", fn: (){ Navigator.pushNamed(context, '/camera'); }, bg: Colors.red.shade300,),
                CustomButton(txt: "تأكيد", fn: () => sendCardImage(context)),
              ],
            ))
        ],
      ),
      );
  }

}