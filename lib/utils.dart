import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  // input
  final Color bg;
  final String txt;
  final Color txtColor;
  final Function fn;

  // constructor
  const CustomButton({
    super.key,
    this.txt = '',
    this.txtColor = Colors.white,
    this.bg= Colors.blue,
    required this.fn}); 

  // build
  @override 
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => fn(), 

        // CSS
        style: ElevatedButton.styleFrom(
          
          // padding
          padding: EdgeInsets.all(18),

          // border
          shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          
          // color
          backgroundColor: bg,

          // shadow
          elevation: 0,

        ),

        // CHILD
        child: Text(
          txt, 
          style: TextStyle(
            color: txtColor ,
            fontWeight: FontWeight.bold, 
            fontSize: 16
            ),
          ),
      );
  }
}