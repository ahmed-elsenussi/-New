import 'package:flutter/material.dart';
import 'package:card_register/pages/register/register_utils.dart';

class RegisterPage extends StatefulWidget {
  // rebuild || reuse
  const RegisterPage({super.key});

  // naming the state
  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  // VARIABLES

  // global key : make you access state widget from anywhere in the widget tree
  final formKey = GlobalKey<FormState>();
  final controller = FormControllers();

  // METHODS

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
                CameraNavigator(),

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
                SubmitFormButton(formKey: formKey, url:"", controller: controller),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
