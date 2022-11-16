import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/screens/home_controller.dart';
import 'package:delivery_on_time/version_check/model/versionCheckModel.dart';
import 'package:delivery_on_time/version_check/repository/versionCheckRepusitory.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_version/get_version.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;

/*
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<String> services_name = [
    "Bike Ride",
    "Food Delivery",
    "Grocery Order",
    "Courier Service"
  ];
  List<String> logo = [
    "bike_ride.png",
    "food_delivery.png",
    "grocery_order.png",
    "courier_service.png"
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: darkThemeBlue,
        body: ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: [
            // Delivery Logo.....

            Container(
              height: screenHeight*0.16,
              margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Image.asset("assets/images/logos/delivery_icon.png"),
            ),

            // Heading Text.....

            Text(
              "DELIVERY ON TIME",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: textCol, fontSize: 14, fontWeight: font_bold),
            ),

            SizedBox(
              height: 50.0,
            ),
            Container(
              height: screenHeight*0.7,
              padding: EdgeInsets.all(11.0),
              child: GridView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: logo.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 40 / 45,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeController()));
                      },
                      child: Card(
                        color: lightThemeBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(17.0))),
                        elevation: 5,
                        shadowColor: Color.fromRGBO(190, 255, 255, 0.1),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 15),
                              height: 120.0,
                              width: 120.0,
                              decoration: BoxDecoration(
                                // color: lightThemeBlue,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(17),
                                      topRight: Radius.circular(17)),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/logos/${logo[index]}"),
                                      fit: BoxFit.fill)),
                            ),
                            Text(services_name[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.0,
                                    color: Colors.white70))
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
*/

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences prefs;
  String _projectCode = '';
  String userId = '';
  VersionCheckRepository _versionCheckRepository;
  Future<VersionCheckModel> _versionmCheck;
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);
  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    userName = prefs.getString("name");
    try{
      userPhone = prefs.getString("user_phone").substring(3);
      userName = prefs.getString("name");
      userId = prefs.getString("user_id");
      initAnalytics(userName,userId);
      //userId = prefs.getString("user_id");
    }catch(ex){
      print(ex);
    }
  }


  @override
  void initState() {
    super.initState();
    // if(userAddress==null || userAddress=="") _getLocation();
    _versionCheckRepository=VersionCheckRepository();
    _vCode();
    createSharedPref();

  }


  List<String> services_name = [
    "Ride",
    "Cake",
    "Food",
    "Pickup & Drop"
  ];
  List<String> logo = [
    "bike_ride.png",
    "cake2.png",
    "food_delivery.png",
    "courier_service.png"
  ];

  // _getLocation() async {
  //
  //   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   debugPrint('location: ${position.latitude}');
  //   final coordinates = new Coordinates(position.latitude, position.longitude);
  //   var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   var first = addresses.first;
  //   userAddress = "${first.addressLine}";
  //   userLat=first.coordinates.latitude;
  //   userLong=first.coordinates.longitude;
  //   print("${first.featureName} : ${first.addressLine}");
  //   // setState(() {});
  // }

  void _vCode() async {

    String projectCode;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectCode = await GetVersion.projectCode;
    } on PlatformException {
      projectCode = 'Failed to get build number.';
    }
    _projectCode = projectCode;
    var platform = Theme.of(context).platform;
    if(platform == TargetPlatform.android){
      _versionmCheck =_versionCheckRepository.vCheck();
      setState(() {});
      print("check");

    }

  }


  @override
  Widget build(BuildContext context) {
    screenHeight= MediaQuery.of(context).size.height;
    screenWidth= MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: darkThemeBlue,
        body: ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: [
            FutureBuilder<VersionCheckModel>(
              future: _versionmCheck,
              builder: (context, snapshot) {
                if (snapshot.hasData) {

                  print('THIS IS THE PROJECT CODE:');
                  print(_projectCode);
                  print('THIS IS THE VERSIONCHECK');
                  print(snapshot.data.data.version);
                  if (snapshot.data.data.version >int.parse(_projectCode)) {

                    Future.delayed(Duration.zero, (){
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
                                  "You are using an old version of this app.\n"
                                      "Please update our app for better performance",
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
                                      "Update Now",
                                      style: TextStyle(
                                        color: Colors.deepOrangeAccent,
                                        fontSize: 14.0,
                                        // fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    onPressed: () {
                                      StoreRedirect.redirect(
                                          androidAppId: "com.inceptory.delivery_on_time");
                                    }),

                              ],
                            ));
                          });
                    });

                    return Container();
                  } else {
                    return Container();
                  }
                } else if (snapshot.hasError) {
                  print(snapshot.error.toString());
                  return Container(
                    child: Center(
                        child: Text(
                          "",
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        )),
                  );
                } else {
                  return Container();
                  // return Center(
                  //   child: CircularProgressIndicator(
                  //       backgroundColor: circularBGCol,
                  //       strokeWidth: strokeWidth,
                  //       valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol)
                  //   ),
                  // );
                }
              },
            ),
            // Delivery Logo.....

            Container(
              height: screenHeight*0.16,
              margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Image.asset("assets/images/logos/delivery_icon.png"),
            ),

            // Heading Text.....

            Text(
              "DELIVERY ON TIME",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: textCol, fontSize: 14, fontWeight: font_bold),
            ),

            SizedBox(
              height: 50.0,
            ),
            Container(
              height: screenHeight*0.7,
              padding: EdgeInsets.all(11.0),
              child: GridView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: logo.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 40 / 45,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeController(currentIndex: (index==3)?4:index,)));
                      },
                      child: Card(
                        color: lightThemeBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(17.0))),
                        elevation: 5,
                        shadowColor: Color.fromRGBO(190, 255, 255, 0.1),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              height: 110.0,
                              width: 120.0,
                              decoration: BoxDecoration(
                                // color: lightThemeBlue,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(17),
                                      topRight: Radius.circular(17)),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/logos/${logo[index]}"),
                                      fit: BoxFit.fill)),
                            ),
                            index==3?  Text(services_name[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'BoldItalic',
                                    //fontWeight: FontWeight.bold,
                                    fontSize: screenWidth*0.05,
                                    color: Colors.white70))
                                :
                            Text(services_name[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'BoldItalic',
                                    //fontWeight: FontWeight.bold,
                                    fontSize: screenWidth*0.07,
                                    color: Colors.white70))
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> initAnalytics(String user_name,String user_id) async {
    print("check1$user_name$user_id");
    //print("check2$userId}");
    await analytics.logEvent(
      name: "customer_activity",
      parameters: {
        "user_name": user_name,
        "user_id": user_id,
      },
    );

  }


}

