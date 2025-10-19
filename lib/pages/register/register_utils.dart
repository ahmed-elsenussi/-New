import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FormControllers {
  // CONTROLLERS
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final verifyPassword = TextEditingController();
  Map<String, String> extra = {};

  // CLEAN
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    verifyPassword.dispose();
  }

  // SET-EXTRA DATA
  void setExtra(String key, String value){
    extra[key] = value;
  }

  // GET-DATA
  Map<String, String> getData() => {
      "name": name.text,
      "email": email.text,
      "password":password.text,
      ...extra,
  };
  
}

// VALIDATOR FOR TEXTFORMS==========================================
class CustomTextValidator {
  static final RegExp emailFormat =
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[a-zA-Z]{2,10}$');
  static final RegExp longTextFormat =
      RegExp(r'^[\u0600-\u06FFa-zA-Z\s]{1,200}$');
  static final RegExp strongPasswordFormat =
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$');

  static String? emptyFn(String? v) =>
      (v == null || v.trim().isEmpty) ? "مطلوب" : null;

  static String? checkFormat(String? v, RegExp format, String errMsg) =>
      (v == null || !format.hasMatch(v.trim())) ? errMsg : null;

  static String? matchPasswords(String? password, String? verifyPassword) {
    if (password != verifyPassword) return "كلمتا المرور غير متطابقتين";
    return null;
  }

  static String? validate({
    required String? value,
    bool empty = true,
    bool mail = false,
    bool short = true,
    bool long = true,
    bool strongPassword = false,
    bool confirmPassword = false, // ✅ NEW
    String? passwordValue,        // ✅ optional reference for match check
  }) {
    // 1) Empty check
    if (empty) {
      final e = emptyFn(value);
      if (e != null) return e;
    }

    // 2) Email format
    if (mail) {
      final e = checkFormat(value, emailFormat, "تنسيق البريد الإلكتروني خاطئ");
      if (e != null) return e;
    }

    // 3) Minimum length
    if (short && (value == null || value.trim().length < 3)) {
      return "النص قصير جداً";
    }

    // 4) Long text format
    if (long && !mail && !strongPassword) {
      if (value != null && value.trim().length > 200) {
        return "النص طويل جداً";
      }
    }

    // 5) Strong password
    if (strongPassword) {
      final e = checkFormat(value, strongPasswordFormat, "كلمة المرور ضعيفة جداً");
      if (e != null) return e;
    }

    // ✅ 6) Password match
    if (confirmPassword) {
      final e = matchPasswords(passwordValue, value);
      if (e != null) return e;
    }

    return null;
  }
}



// TEXTFORM FIELD [WIDGET]==========================================

class CustomTextFormField extends StatefulWidget {

  // INPUTS
  final TextEditingController controller;
  final String label, hint;
  final Icon prefixIcon;
  final String? Function(String?)? validator;
  final bool secure;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    required this.validator,
    this.secure = false,
  });

  // STATE NAMING
  @override
  State<CustomTextFormField> createState() => CustomTextFormFieldState();

}

class CustomTextFormFieldState extends State<CustomTextFormField> {

  // VARIABLES
  late bool isEyeOpen;

  @override
  void initState() {
    super.initState();
    isEyeOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.secure && !isEyeOpen,
        decoration: InputDecoration(
          // label
          labelText: widget.label,
          labelStyle: TextStyle(color: Colors.blue),

          // hint
          hintText: widget.hint,
          hintStyle: TextStyle(color: Colors.blueGrey),

          // color
          filled: true,
          fillColor: const Color.fromARGB(255, 241, 241, 241),

          // borders
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),

          // prefix icon
          prefixIcon: widget.prefixIcon,


          // suffix icon
          suffixIcon: 
            widget.secure ?  
                IconButton(
                  onPressed: () => setState(() => isEyeOpen = !isEyeOpen), 
                  icon: !isEyeOpen ? 
                    Icon(Icons.remove_red_eye) : 
                    Icon(Icons.remove_red_eye_outlined)) : null 

        ),

        // validation
        validator: widget.validator,
      ),
    );
  }
}



////////////////////////////////////SUBMISSION FORM BUTTON///////////////////////////////////////////////////

// [WIDGET]
class SubmitFormButton extends StatefulWidget {

  // INPUTS
  FormControllers controller;
  final GlobalKey<FormState> formKey;
  final url;

  // rebuild || reuse
  SubmitFormButton({super.key, required this.formKey, required this.url, required this.controller});

  // state naming
  @override State<SubmitFormButton> createState()=> SubmitFormButtonState();
}


class SubmitFormButtonState extends State<SubmitFormButton> {

  // VARIABLES
  String errorMessage = "";

  // METHODS
  Future<void> submit() async {

    // validate
    if(widget.formKey.currentState!.validate()){

      // get data
      final data = widget.controller.getData();
      print('form data = $data');

      // send post request
      print("url = ${widget.url}");
      final parsedUrl = Uri.parse(widget.url);
      final response = await http.post( parsedUrl, headers: { 'Content-Type': 'application/json' }, body: jsonEncode(data),);
      final decoded  = jsonDecode(response.body);


      print("resposne = ${response.body}");

      // check status
      if(response.statusCode == 200){
        print("hello my name is ahmed kamal");
        setState(() { errorMessage = "";});
      } else {
        String msg = '';
        if (decoded is Map<String , dynamic>){
          // get first key
          final firstKey = decoded.keys.first;
          final errors =  decoded[firstKey];
          if (errors is List && errors.isNotEmpty) {
            msg = errors[0]; 
          } else if (errors is String) {
          msg = errors;
        }
      }

      // rebuild the widget
      setState(() {
        errorMessage = msg;
      });

    }


    }

  }

  // BUILD
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Column(
      children: [

        // THE MESSAGE FROM THE BACKEND
        Center(child: Text(errorMessage),),

        // SUBMISSION BUTTON
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
          onPressed: submit, 

          // CSS
          style: ElevatedButton.styleFrom(
            
            // padding
            padding: EdgeInsets.all(18),

            // border
            shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            
            // color
            backgroundColor: Colors.blue,

            // shadow
            elevation: 0,

          ),

          // CHILD
          child: Text(
            "انشاء حساب", 
            style: TextStyle(
              color: Colors.white, 
              fontWeight: FontWeight.w900, 
              fontSize: 16
              ),
            ),
        ),
        )
      ],
      )
    );
  }
}

///////////////////////////CAMERA Navigator////////////////////
///
class CameraNavigator extends StatelessWidget  {
  final String? txt;
  final bool isTxt;
  final IconData? icon;
  final bool isIcon;

  const CameraNavigator({super.key, this.txt, this.isTxt=true, this.icon, this.isIcon = true});

  @override Widget build(BuildContext context){
    return ElevatedButton(
      onPressed: ()=>Navigator.pushNamed(context, '/camera'), 
      style: ElevatedButton.styleFrom(
        // padding
        padding: EdgeInsets.all(24),
        // background color
        backgroundColor: Colors.blue[100],
        // borders
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(12) ),
        // shadow
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        if (isTxt) Text(txt!),
        if (isIcon) Icon(icon),
      ],)
      );
  }
}