import 'package:delivery_on_time/address_screens/addressListPage.dart';
import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/dummy.dart';
import 'package:delivery_on_time/loginMobile_screen/loginByMobile.dart';
import 'package:delivery_on_time/login_screen/login.dart';
import 'package:delivery_on_time/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  String _userToken="";
  Future<void> createSharedPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _userToken=prefs.getString("user_token");
  }


  @override
  void initState() {
    super.initState();
    createSharedPref();
  }

  // List _splashTransition=[SplashTransition.scaleTransition,SplashTransition.sizeTransition,SplashTransition.rotationTransition,]
  @override
  Widget build(BuildContext context) {
    screenHeight= MediaQuery.of(context).size.height;
    screenWidth= MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
        width: screenWidth,
        height: screenHeight,
        child: AnimatedSplashScreen(
            splash: Container(

              // height: screenHeight,
              // width: screenWidth,
              child: Image.asset("assets/images/logos/delivery_icon02.png",
                // fit: BoxFit.fill,
                // width: 300,
                // height: 400,
              ),
            ),
            nextScreen: LoginByMobilePage(),

          backgroundColor: darkThemeBlue,
          duration: 2000,
          animationDuration: Duration(milliseconds: 1500),
          splashTransition: SplashTransition.sizeTransition,
        ),
      ),
    );
  }
}
