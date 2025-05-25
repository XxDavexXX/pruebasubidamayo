import 'package:flutter/material.dart';

class MyIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const MyIcon(this.icon,this.onTap,{super.key});
  @override
  Widget build(BuildContext ctx)=>Container(
    width: 47,
    height: 47,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius:BorderRadius.circular(16),
    ),
    child: IconButton(
      icon: Icon(icon,color:Colors.black,size:30),
      onPressed: onTap,
    ),
  );
}