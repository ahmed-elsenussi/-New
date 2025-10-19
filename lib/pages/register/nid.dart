import 'package:card_register/pages/register/register_utils.dart';
import 'package:flutter/material.dart';

class NidViewEdit extends StatelessWidget {
  // input
  final String nid;
  const NidViewEdit({super.key, required this.nid});
  @override Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200] ,
        borderRadius: BorderRadius.circular(12),
      ) ,
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      Icon(Icons.credit_card,),
      Text("الرقم القومي ", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
      Text(nid),
      CameraNavigator(isTxt: false, icon: Icons.edit, isIcon: true,),
      
    ],),
    );
  }
}