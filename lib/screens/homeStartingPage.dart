import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:delivery_on_time/Animation/FadeAnimation.dart';
import 'package:delivery_on_time/constants.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home.dart';

class HomeStartingPage extends StatefulWidget {
  @override
  _HomeStartingPageState createState() => _HomeStartingPageState();
}

class _HomeStartingPageState extends State<HomeStartingPage> {

  bool locCheckPass=true;
  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight= MediaQuery.of(context).size.height;
    screenWidth= MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: darkThemeBlue,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: screenWidth,
              height: screenHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/mapBody.png",
                  ),
                  fit: BoxFit.fill

                )
              ),

            ),
            Container(
              width: screenWidth,
              height: screenHeight,
              decoration: BoxDecoration(
                color: darkThemeBlue.withOpacity(0.95),
              ),
            ),
            Positioned(
              top: 0,
              child: FadeAnimation(
              delay: 5,
                child: Container(
                  margin: EdgeInsets.only(top: screenHeight*0.15,),
                  width: screenHeight*0.2,
                  height: screenHeight*0.2,
                  decoration: new BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/location_icon.png",
                      ),
                    ),
                    color: Colors.orange.withOpacity(0),
                    shape: BoxShape.circle,
                  ),
                ),
              )
            ),
            Positioned(
              top: screenHeight*0.14,
              child: Container(
                width: screenHeight*025,
                height: screenHeight*0.25,
                decoration: new BoxDecoration(
                  color: Colors.orangeAccent.withOpacity(0.07),
                  shape: BoxShape.circle,
                ),
              )
            ),
            Positioned(
              top: screenHeight*0.42,
              child: Container(
                width: screenWidth*0.9,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    TyperAnimatedTextKit(
                      repeatForever: false,
                      displayFullTextOnTap: true,
                      textStyle:  GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 25
                      ),
                      text: [
                        "Fetching Location..."
                      ],
                      isRepeatingAnimation: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RotateAnimatedTextKit(
                      totalRepeatCount: 4,
                      duration: Duration(milliseconds: 1000),
                        pause: Duration(milliseconds: 250),
                        text: [userAddress??""],
                        textStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 15
                        ),
                        textAlign: TextAlign.center
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  _getLocation() async {

    Position position;
    try{
      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      debugPrint('location: ${position.latitude}');
      final coordinates = new Coordinates(position.latitude, position.longitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      userAddress = "${first.addressLine}";
      userLat=first.coordinates.latitude;
      userLong=first.coordinates.longitude;
      print("${first.featureName} : ${first.addressLine}");
      setState(() {
      });
      Future.delayed(Duration(milliseconds: 2500), () {
        if(userAddress!=null || userAddress==""){
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage()));
        }
      });

    }catch(ex){
      print(ex);
      if(locCheckPass){
        locCheckPass=false;
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return WillPopScope(
                  onWillPop: () async => false,
                  child: AlertDialog(
                    // title: Text("Give the code?"),
                    content: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Please Accept Location Permission for Better Experience",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          // fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    actions: [
                      new FlatButton(
                          child: const Text(
                            "OK",
                            style: TextStyle(
                              color: Colors.deepOrangeAccent,
                              fontSize: 14.0,
                              // fontWeight: FontWeight.bold
                            ),
                          ),
                          onPressed: () {
                            _getLocation();
                            Navigator.pop(context);
                          }),
                      new FlatButton(
                          child: const Text(
                            "No, I Don't",
                            style: TextStyle(
                              color: Colors.deepOrangeAccent,
                              fontSize: 14.0,
                              // fontWeight: FontWeight.bold
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          }),


                    ],
                  ));
            });
      }else{
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage()));
      }

    }

    // setState(() {});
  }
}

