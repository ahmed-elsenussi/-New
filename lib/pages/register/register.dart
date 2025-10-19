import 'package:card_register/pages/register/nid.dart';
import 'package:flutter/material.dart';
import 'package:card_register/pages/register/register_utils.dart';

class RegisterPage extends StatefulWidget {

  // inputs
  final String? nid;

  // rebuild || reuse
  const RegisterPage({super.key, this.nid});

  // naming the state
  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  // VARIABLES

  // global key : 
  final formKey = GlobalKey<FormState>();
  final controller = FormControllers();

  // METHODS
  @override 
  void initState(){
    super.initState();
    if(widget.nid != null ){
      // add the nid to the controller
      controller.setExtra("nid", widget.nid!);
    }
  }

  // BUILD
  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("انشاء حساب"), centerTitle: true),

      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Form(
            key: formKey,
            child: ListView(
              children: [

                // camera button
                (widget.nid != null) ? NidViewEdit(nid: widget.nid!) : CameraNavigator(txt: "التقط صورة البطاقة", icon: Icons.add,),
                Center(child: Text("سيتم استخدام الرقم القومي للربط بالحساب فقط لاداعي للقلق", style: TextStyle(color: Colors.blue.shade500),), ),

                // name
                CustomTextFormField(
                  controller: controller.name,
                  label: "الاسم",
                  hint: "اكتب اسمك",
                  prefixIcon: Icon(Icons.person),
                  validator: (value) => CustomTextValidator.validate( value: value),
                ),

                // email
                CustomTextFormField(
                  controller: controller.email,
                  label: "البريد الالكتروني",
                  hint: "ادخل بريدك الالكتروني",
                  prefixIcon: Icon(Icons.email),
                  validator: (value) => CustomTextValidator.validate( value: value, mail: true ),
                ),

                // password
                CustomTextFormField(
                  secure: true,
                  controller: controller.password,
                  label: "كلمة المرور",
                  hint: "اكتب كلمة المرور",
                  prefixIcon: Icon(Icons.password),
                  validator: (value) => CustomTextValidator.validate( value: value),
                ),

                // verify password
                CustomTextFormField(
                  secure: true,
                  controller: controller.verifyPassword,
                  label: "اعادة كلمة المرور",
                  hint: "عيد كلمة المرور مره تانيه",
                  prefixIcon: Icon(Icons.password),
                  validator: (value) => CustomTextValidator.validate(
                    value: value,
                    confirmPassword: true,
                    passwordValue: controller.password.text,
                  ),
                ),


                // SUBMISSION
                SubmitFormButton(formKey: formKey, url:"http://172.30.1.123:8000/users/signup/", controller: controller),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
