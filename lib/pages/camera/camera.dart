// IMPORT
import 'package:card_register/pages/camera/confirm.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';


class CameraPage extends StatefulWidget {

  // INPUT
  final CameraDescription camera;
  final String? messageError;

  // CONSTURCTOR
  const CameraPage({super.key, required this.camera, this.messageError});

  // STATE NAMING
  @override
  State<CameraPage> createState() => CameraPageState();

}


class CameraPageState extends State<CameraPage> {

  // variables
  late CameraController cameraController;
  late Future<void> initControllerFuture;


  // INITIALIZATION
  @override
  void initState() {
    super.initState();
    cameraController = CameraController(widget.camera, ResolutionPreset.ultraHigh);
    initControllerFuture = cameraController.initialize();
  }

  // CLEAN
  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  // METHOD
  Future<void> takePhote() async {
    // initailize the camera
    await initControllerFuture;
    // take phote
    final photo = await cameraController.takePicture();
    // view the path of the photo
    print("phote saved in ${photo.path}");

    // push me to the confirmationResultPage
    Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmPage(camera: widget.camera,imagePath: photo.path)));
  }


  // BUILD
  @override 
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(title: Text("detect ID from your card"),),
      body: FutureBuilder(
        future: initControllerFuture,
        builder: (context, snapshot) {

          if(snapshot.connectionState == ConnectionState.done){

            // STACK
            return Stack(
              children: [

                // camera layer
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: cameraController.value.previewSize?.height ?? 0,
                      height: cameraController.value.previewSize?.width ?? 0,
                      child: CameraPreview(cameraController),
                    ),
                  ),
                ),

                


                // error message
                if (widget.messageError != null)
                  Positioned(
                    top: 0, // directly under the AppBar
                    left: 0,
                    right: 0,
                    child: Container(
                      width: double.infinity,
                      color: Colors.white, // background
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: Text(
                        widget.messageError!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),


                // floating camera point
                Positioned(
                  bottom: 40,
                  // cover the full width
                  left: 30,
                  right: 30,
                  child: ElevatedButton(
                    onPressed: takePhote,
                    style: ElevatedButton.styleFrom(
                      // padding
                      padding: EdgeInsets.all(24),
                      // border
                      shape: RoundedRectangleBorder(  borderRadius:  BorderRadius.circular(10)),
                      // background color
                      backgroundColor: Colors.white,
                      // shadow
                      elevation: 10  
                    ) ,
                    child: Text("click", style: TextStyle(color: Colors.black, fontSize: 16),),
                  ),
                )

              ],
            );
            
            

            
          } else if (snapshot.hasError) {
            return Center(child: Text("Something wrong happend : ${snapshot.error}"),);         
          } else {
            return Center(child: CircularProgressIndicator(),);
          }

        },
      ),
    );
  }

}
