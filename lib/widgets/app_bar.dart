import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AppBar mainAppBar(BuildContext context, String title){
  return AppBar(
    title: Text(title),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 18,
    ),
    backgroundColor: Colors.white60,
    centerTitle: false,
    leading: IconButton(onPressed: (){ Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: Colors.black, size: 24,)),
  );
}