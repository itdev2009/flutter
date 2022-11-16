import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

import '../constants.dart';

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          
            
            child: Hero(
              tag: imageurl!=null?imageurl:'customTag',
              child: PinchZoom(
                resetDuration: Duration(milliseconds: 500),
                child: Image.network(
                    "$imageBaseURL${imageurl}",
                ),
              ),
            ),
        
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}