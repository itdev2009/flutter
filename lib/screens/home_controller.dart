import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/pickupDropPage/pickDropConfirmPage.dart';
import 'package:delivery_on_time/pickupDropPage/pickDropPage01.dart';
import 'package:delivery_on_time/rideService/rideDataClass.dart';
import 'package:delivery_on_time/rideService/ridePickDropLocScreen.dart';
import 'package:delivery_on_time/rideService/rideStartingPage.dart';
import 'package:delivery_on_time/screens/differentShops_home.dart';
import 'package:delivery_on_time/screens/profile_page.dart';
import 'package:delivery_on_time/restaurants_screen/food_home.dart';
import 'package:flutter/material.dart';

import '../dummy.dart';
import 'grocery_home.dart';
import 'orderConfirmPage.dart';


class HomeController extends StatefulWidget {
  final int currentIndex;
  RideDataStore rideDataStore;
  HomeController({this.currentIndex=1,this.rideDataStore});

  @override
  _HomeCont createState() => _HomeCont(currentIndex,rideDataStore);
}

class _HomeCont extends State<HomeController> {

  int _currentIndex;
  RideDataStore rideDataStore;

  _HomeCont(this._currentIndex,this.rideDataStore);

  var tabs;

  @override
  void initState() {
    super.initState();
    tabs = [
      RideStartingPage(rideDataStore: rideDataStore,),
      // RideServicePage(),
      // MyApp001(),
      DifferentShopsHome(18),
      FoodHome(2),
      GroceryHome(3),
      PickAndDropPage(),
      ProfilePage(),
    ];
  }



  List<String> services_name = [" Ride   ","Cake   ","Food    ", "Grocery", "Pickup"];

  List<String> logo = [
    "bike_ride.png",
    "cake2.png",
    "food_delivery.png",
    "grocery_order.png",
    "courier_service.png"
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: tabs[_currentIndex],
        bottomNavigationBar: CurvedNavigationBar(
          index: _currentIndex,
          backgroundColor: darkThemeBlue,
          color: lightThemeBlue,
          height: 50.0,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 250),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            // print(_currentIndex);
          },
          
          items: [
            ButtomTabIcons(services_name[0], logo[0]), //for Ride
            ButtomTabIcons(services_name[1], logo[1]), //for Cake
            ButtomTabIcons(services_name[2], logo[2]), //for Food
            ButtomTabIcons(services_name[3], logo[3]), //for Grocery
            ButtomTabIcons(services_name[4], logo[4]), //for Courier

            //for Person Icon Manually Implemented
            Column(
              children: [
                Container(
                  // margin: EdgeInsets.only(bottom: 15),
                  height: 30.0,
                  width: 30.0,
                  child: Icon(
                    Icons.person_outline,
                    size: 20.0,
                    color: Colors.white70,
                  ),
                  decoration: BoxDecoration(
                    color: lightThemeBlue,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18)),
                  ),
                ),
                Text("Profile  ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                        color: Colors.white)),
              ],
            )
            //
          ],
        ),
      ),
    );

  }


  Widget ButtomTabIcons(String name, String logo) {
    return Column(
      children: [
        Container(
          // margin: EdgeInsets.only(bottom: 15),
          height: 30.0,
          width: 30.0,
          decoration: BoxDecoration(
              // color: lightThemeBlue,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18), topRight: Radius.circular(18)),
              image: DecorationImage(
                  image: AssetImage("assets/images/logos/${logo}"),
                  fit: BoxFit.fill)),
        ),
        Text(name,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
                color: Colors.white)),
      ],
    );
  }
}
