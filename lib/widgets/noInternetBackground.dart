import 'package:delivery_on_time/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoInternetBackground extends StatelessWidget {
  final double imageHeight;
  final double imageWidth;
  final String errorText;
  final double textSize;
  final Color textColor;
  final FontWeight textWeight;
  final Function onTapButton;

  const NoInternetBackground(
      {this.imageHeight = 40,
      this.imageWidth = 60,
      this.errorText = "Please check internet connection and try again...",
      this.textSize = 14,
      this.textColor = Colors.white,
      this.textWeight = FontWeight.w400,
      this.onTapButton});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          "assets/images/no_internet_bg.png",
          height: imageHeight,
          width: imageWidth,
        ),
        SizedBox(
          height: 20,
        ),
        Text(errorText,
            style: GoogleFonts.poppins(
              color: textColor,
              fontWeight: textWeight,
              fontSize: textSize,
            )),
        SizedBox(
          height: 10,
        ),
        RaisedButton(
          padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          onPressed: onTapButton,
          color: orangeCol,
          textColor: Colors.white,
          child: Text(
            "Try Again",
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.0, letterSpacing: 0.5, fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }
}
