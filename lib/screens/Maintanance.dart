import 'package:delivery_on_time/constants.dart';
import 'package:flutter/material.dart';

class Maintanance extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: darkThemeBlue,
        body: Center(
          child: Text("Coming Soon",
          style: TextStyle(
            fontSize: 40.0,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),),
        ),
      ),
    );
  }

}