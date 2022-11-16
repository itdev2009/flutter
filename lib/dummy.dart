
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyApp001 extends StatelessWidget {
  // Light Theme
  final ThemeData lightTheme = ThemeData.light().copyWith(
    // Background color of the FloatingCard
    cardColor: Colors.white,
    buttonTheme: ButtonThemeData(
      // Select here's button color
      buttonColor: Colors.black,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  // Dark Theme
  final ThemeData darkTheme = ThemeData.dark().copyWith(
    // Background color of the FloatingCard
    cardColor: Colors.grey,
    buttonTheme: ButtonThemeData(
      // Select here's button color
      buttonColor: Colors.yellow,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Map Place Picker Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      home: HomePage001(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage001 extends StatefulWidget {
  const HomePage001({Key key}) : super(key: key);

  static final kInitialPosition = LatLng(-33.8567844, 151.213108);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage001> {
  PickResult selectedPlace;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Google Map Place Picer Demo"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: Text("Load Google Map"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PlacePicker(
                          apiKey: "AIzaSyCuGtIzD0qfGOsZjXtqaIu5syeDVZUrLUI",
                          initialPosition: HomePage001.kInitialPosition,
                          useCurrentLocation: true,
                          selectInitialPosition: true,

                          //usePlaceDetailSearch: true,
                          onPlacePicked: (result) {
                            selectedPlace = result;
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                          //forceSearchOnZoomChanged: true,
                          //automaticallyImplyAppBarLeading: false,
                          //autocompleteLanguage: "ko",
                          //region: 'au',
                          //selectInitialPosition: true,
                          // selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
                          //   print("state: $state, isSearchBarFocused: $isSearchBarFocused");
                          //   return isSearchBarFocused
                          //       ? Container()
                          //       : FloatingCard(
                          //           bottomPosition: 0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                          //           leftPosition: 0.0,
                          //           rightPosition: 0.0,
                          //           width: 500,
                          //           borderRadius: BorderRadius.circular(12.0),
                          //           child: state == SearchingState.Searching
                          //               ? Center(child: CircularProgressIndicator())
                          //               : RaisedButton(
                          //                   child: Text("Pick Here"),
                          //                   onPressed: () {
                          //                     // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                          //                     //            this will override default 'Select here' Button.
                          //                     print("do something with [selectedPlace] data");
                          //                     Navigator.of(context).pop();
                          //                   },
                          //                 ),
                          //         );
                          // },
                          // pinBuilder: (context, state) {
                          //   if (state == PinState.Idle) {
                          //     return Icon(Icons.favorite_border);
                          //   } else {
                          //     return Icon(Icons.favorite);
                          //   }
                          // },
                        );
                      },
                    ),
                  );
                },
              ),
              selectedPlace == null ? Container() : Text(selectedPlace.formattedAddress ?? ""),
            ],
          ),
        ));
  }
}




// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
//
// import 'constants.dart';
//
// class MyAppMap extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Polyline example',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.orange,
//       ),
//       home: MapScreen(),
//     );
//   }
// }
//
// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   GoogleMapController mapController;
//   double _originLatitude = 6.5212402, _originLongitude = 3.3679965;
//   double _destLatitude = 6.849660, _destLongitude = 3.648190;
//   Map<MarkerId, Marker> markers = {};
//   Map<PolylineId, Polyline> polylines = {};
//   List<LatLng> polylineCoordinates = [];
//   PolylinePoints polylinePoints = PolylinePoints();
//   String googleAPiKey = mapAPIKey;
//
//   @override
//   void initState() {
//     super.initState();
//
//     /// origin marker
//     _addMarker(LatLng(_originLatitude, _originLongitude), "origin",
//         BitmapDescriptor.defaultMarker);
//
//     /// destination marker
//     _addMarker(LatLng(_destLatitude, _destLongitude), "destination",
//         BitmapDescriptor.defaultMarkerWithHue(90));
//     _getPolyline();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//           body: GoogleMap(
//             initialCameraPosition: CameraPosition(
//                 target: LatLng(_originLatitude, _originLongitude), zoom: 9),
//             myLocationEnabled: false,
//             tiltGesturesEnabled: false,
//             compassEnabled: true,
//             scrollGesturesEnabled: true,
//             zoomGesturesEnabled: true,
//             mapType: MapType.normal,
//             mapToolbarEnabled: false,
//
//             zoomControlsEnabled: false,
//             onMapCreated: _onMapCreated,
//             markers: Set<Marker>.of(markers.values),
//             polylines: Set<Polyline>.of(polylines.values),
//           )),
//     );
//   }
//
//   void _onMapCreated(GoogleMapController controller) async {
//     mapController = controller;
//   }
//
//   _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
//     MarkerId markerId = MarkerId(id);
//     Marker marker =
//     Marker(markerId: markerId, icon: descriptor, position: position);
//     markers[markerId] = marker;
//   }
//
//   _addPolyLine() {
//     PolylineId id = PolylineId("poly");
//     Polyline polyline = Polyline(
//         polylineId: id, color: orangeCol, points: polylineCoordinates,width: 3);
//     polylines[id] = polyline;
//     setState(() {});
//   }
//
//   _getPolyline() async {
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//         mapAPIKey,
//         PointLatLng(_originLatitude, _originLongitude),
//         PointLatLng(_destLatitude, _destLongitude),
//         travelMode: TravelMode.driving,
//         wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")]
//     );
//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//     }
//     _addPolyLine();
//   }
// }



/*import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/screens/homeStartingPage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';
import 'package:flutter/painting.dart';

import 'loginMobile_screen/otpVerificationPage.dart';

class ClipPainter extends CustomClipper<Path>{
  @override

  Path getClip(Size size) {
    var height = size.height;
    var width = size.width;
    var path = new Path();

    path.lineTo(0, size.height );
    path.lineTo(size.width , height);
    path.lineTo(size.width , 0);

    /// [Top Left corner]
    var secondControlPoint =  Offset(0  ,0);
    var secondEndPoint = Offset(width * .2  , height *.3);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);



    /// [Left Middle]
    var fifthControlPoint =  Offset(width * .3  ,height * .5);
    var fiftEndPoint = Offset(  width * .23, height *.6);
    path.quadraticBezierTo(fifthControlPoint.dx, fifthControlPoint.dy, fiftEndPoint.dx, fiftEndPoint.dy);


    /// [Bottom Left corner]
    var thirdControlPoint =  Offset(0  ,height);
    var thirdEndPoint = Offset(width , height  );
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy, thirdEndPoint.dx, thirdEndPoint.dy);



    path.lineTo(0, size.height  );
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }


}

class BezierContainer extends StatelessWidget {
  const BezierContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Transform.rotate(
          angle: -pi / 3.5,
          child: ClipPath(
            clipper: ClipPainter(),
            child: Container(
              height: MediaQuery.of(context).size.height *.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffe4944f),Color(0xffe36126)]
                  )
              ),
            ),
          ),
        )
    );
  }
}



class LoginPageDemo extends StatefulWidget {
  LoginPageDemo({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPageDemo> {

  TextEditingController _phoneNumberController=new TextEditingController();
  RegExp regExp = new RegExp(r"^[0-9]{10}$");


  Widget _entryField(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 45.0,
            alignment: Alignment.topCenter,
            // margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(7.0)),
            ),
            child: TextField(
              textInputAction: TextInputAction.done,
              controller: _phoneNumberController,
              keyboardType: TextInputType.number,
              // maxLength: 10,
              // maxLengthEnforced: true,
              style: TextStyle(fontSize: 14.0),
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  hintText: "Enter Your Phone number",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                  ),
                  border: InputBorder.none),
            ),
          ),

        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: (){
        if(regExp.hasMatch(_phoneNumberController.text.trim())){
          print("matched");
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
                return OtpVerificationPage(_phoneNumberController.text.trim());
              }));
        }else{
          print("hobe naa");
          Fluttertoast.showToast(
              msg: "Please Enter a Proper Number",
              fontSize: 16,
              backgroundColor: Colors.orange[100],
              textColor: darkThemeBlue,
              toastLength: Toast.LENGTH_LONG);
        }

      },
      child: Container(
        height: 50.0,
        width: MediaQuery.of(context).size.width,
        // padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: darkThemeBlue,
                  // offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xffeb8a35), Color(0xffe36126)])),
        child: Text(
          'Sign In',
          style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
                color: Colors.white,
              ),
            ),
          ),
          Text('or',
          style: TextStyle(color: Colors.white),),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }


  Widget _title() {
    return Column(
      children: [
        Container(
          height: screenHeight * 0.17,
          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Image.asset("assets/images/logos/delivery_icon.png"),
        ),
        // Heading Text.....

        Text(
          "DELIVERY ON TIME",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: textCol,
              fontSize: screenWidth * 0.035,
              fontWeight: font_bold),
        ),

        // Welcome Text.....

        Padding(
          padding: const EdgeInsets.fromLTRB(0, 40, 0, 10),
          child: Text(
            "Welcome",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.05,
              fontWeight: font_bold,
            ),
          ),
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: darkThemeBlue,
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: height*0.56,
                  child: Stack(
                    alignment: Alignment.center,
                    // overflow: Overflow.visible,
                    children: <Widget>[
                      Positioned(
                          top: -height * .15,
                          right: -MediaQuery.of(context).size.width * .4,
                          child: BezierContainer()),
                      Container(
                        width: screenWidth,
                        margin: EdgeInsets.only(top: height*0.2),
                        child: Center(child: _title()),
                      )
                      // Positioned(top: 40, left: 0, child: _backButton()),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20.0,0.0,20.0,20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 20),
                      _entryField("Mobile Number"),
                      SizedBox(height: 10),
                      _submitButton(),
                      _divider(),
                      SizedBox(height: 00),
                      InkWell(
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (BuildContext context) {
                                return HomeStartingPage();
                              }));
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                          child:  Text(
                            "Skip Sign In for now >>>",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: textCol,
                                fontSize: 13,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

              ],
            ),
          )),
    );
  }
}*/



/*
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class Rating extends StatefulWidget {
  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  final _ratingController = TextEditingController();
  double _rating;
  double _userRating = 3.0;
  int _ratingBarMode = 1;
  bool _isRTLMode = false;
  bool _isVertical = false;
  IconData _selectedIcon;

  @override
  void initState() {
    _ratingController.text = '3.0';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(
            headline6: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Colors.white),
          ),
        ),
      ),
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Flutter Rating Bar'),
            actions: [
              IconButton(
                icon: Icon(Icons.settings),
                color: Colors.white,
                onPressed: () async {
                  _selectedIcon = await showDialog<IconData>(
                    context: context,
                    builder: (context) => IconAlert(),
                  );
                  _ratingBarMode = 1;
                  setState(() {});
                },
              ),
            ],
          ),
          body: Directionality(
            textDirection: _isRTLMode ? TextDirection.rtl : TextDirection.ltr,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 40.0,
                  ),
                  _heading('Rating Bar'),
                  _ratingBar(_ratingBarMode),
                  SizedBox(
                    height: 20.0,
                  ),
                  _rating != null
                      ? Text(
                    'Rating: $_rating',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                      : Container(),
                  SizedBox(
                    height: 40.0,
                  ),
                  _heading('Rating Indicator'),
                  RatingBarIndicator(
                    rating: _userRating,
                    itemBuilder: (context, index) => Icon(
                      _selectedIcon ?? Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 50.0,
                    unratedColor: Colors.amber.withAlpha(50),
                    direction: _isVertical ? Axis.vertical : Axis.horizontal,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: _ratingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter rating',
                        labelText: 'Enter rating',
                        suffixIcon: MaterialButton(
                          onPressed: () {
                            setState(() {
                              _userRating =
                                  double.parse(_ratingController.text ?? '0.0');
                            });
                          },
                          child: Text('Rate'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  _heading('Scrollable Rating Indicator'),
                  RatingBarIndicator(
                    rating: 8.2,
                    itemCount: 20,
                    itemSize: 30.0,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Rating Bar Modes',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Row(
                    children: [
                      _radio(1),
                      _radio(2),
                      _radio(3),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Switch to Vertical Bar',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Switch(
                        value: _isVertical,
                        onChanged: (value) {
                          setState(() {
                            _isVertical = value;
                          });
                        },
                        activeColor: Colors.amber,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Switch to RTL Mode',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Switch(
                        value: _isRTLMode,
                        onChanged: (value) {
                          setState(() {
                            _isRTLMode = value;
                          });
                        },
                        activeColor: Colors.amber,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _radio(int value) {
    return Expanded(
      child: RadioListTile(
        value: value,
        groupValue: _ratingBarMode,
        dense: true,
        title: Text(
          'Mode $value',
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 12.0,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _ratingBarMode = value;
          });
        },
      ),
    );
  }

  Widget _ratingBar(int mode) {
    switch (mode) {
      case 1:
        return RatingBar.builder(
          initialRating: 2,
          minRating: 0,
          direction: _isVertical ? Axis.vertical : Axis.horizontal,
          allowHalfRating: true,
          unratedColor: Colors.amber.withAlpha(50),
          itemCount: 5,
          itemSize: 50.0,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            _selectedIcon ?? Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
          },
          updateOnDrag: true,
        );
      case 2:
        return RatingBar(
          initialRating: 3,
          direction: _isVertical ? Axis.vertical : Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          ratingWidget: RatingWidget(
            full: _image('assets/heart.png'),
            half: _image('assets/heart_half.png'),
            empty: _image('assets/heart_border.png'),
          ),
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
          },
          updateOnDrag: true,
        );
      case 3:
        return RatingBar.builder(
          initialRating: 3,
          direction: _isVertical ? Axis.vertical : Axis.horizontal,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return Icon(
                  Icons.sentiment_very_dissatisfied,
                  color: Colors.red,
                );
              case 1:
                return Icon(
                  Icons.sentiment_dissatisfied,
                  color: Colors.redAccent,
                );
              case 2:
                return Icon(
                  Icons.sentiment_neutral,
                  color: Colors.amber,
                );
              case 3:
                return Icon(
                  Icons.sentiment_satisfied,
                  color: Colors.lightGreen,
                );
              case 4:
                return Icon(
                  Icons.sentiment_very_satisfied,
                  color: Colors.green,
                );
              default:
                return Container();
            }
          },
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
          },
          updateOnDrag: true,
        );
      default:
        return Container();
    }
  }

  Widget _image(String asset) {
    return Image.asset(
      asset,
      height: 30.0,
      width: 30.0,
      color: Colors.amber,
    );
  }

  Widget _heading(String text) => Column(
    children: [
      Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 24.0,
        ),
      ),
      SizedBox(
        height: 20.0,
      ),
    ],
  );
}

class IconAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Select Icon',
        style: TextStyle(
          fontWeight: FontWeight.w300,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      titlePadding: EdgeInsets.all(12.0),
      contentPadding: EdgeInsets.all(0),
      content: Wrap(
        children: [
          _iconButton(context, Icons.home),
          _iconButton(context, Icons.airplanemode_active),
          _iconButton(context, Icons.euro_symbol),
          _iconButton(context, Icons.beach_access),
          _iconButton(context, Icons.attach_money),
          _iconButton(context, Icons.music_note),
          _iconButton(context, Icons.android),
          _iconButton(context, Icons.toys),
          _iconButton(context, Icons.language),
          _iconButton(context, Icons.landscape),
          _iconButton(context, Icons.ac_unit),
          _iconButton(context, Icons.star),
        ],
      ),
    );
  }

  Widget _iconButton(BuildContext context, IconData icon) => IconButton(
    icon: Icon(icon),
    onPressed: () => Navigator.pop(context, icon),
    splashColor: Colors.amberAccent,
    color: Colors.amber,
  );
}*/



/*
import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/screens/home_controller.dart';
import 'package:delivery_on_time/version_check/model/versionCheckModel.dart';
import 'package:delivery_on_time/version_check/repository/versionCheckRepusitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  VersionCheckRepository _versionCheckRepository=VersionCheckRepository();
  String _projectCode = '';
  List<String> services_name = ["Cake Shops", "Food Delivery", "Grocery Order", "Pickup and Drop"];
  List<String> logo = ["cake2.png", "food_delivery.png", "grocery_order.png", "courier_service.png"];
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          backgroundColor: darkThemeBlue,
          body: FutureBuilder<VersionCheckModel>(
            future: _versionCheckRepository.vCheck(_projectCode),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.update == false) {
                  return ListView(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    children: [
                      // Delivery Logo....
                      Container(
                        height: screenHeight * 0.16,
                        margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: Image.asset("assets/images/logos/delivery_icon.png"),
                      ),

                      // Heading Text.....

                      Text(
                        "DELIVERY ON TIME",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: textCol, fontSize: 14, fontWeight: font_bold),
                      ),

                      SizedBox(
                        height: 50.0,
                      ),
                      Container(
                        height: screenHeight * 0.7,
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeController(index)));
                                },
                                child: Card(
                                  color: lightThemeBlue,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(17.0))),
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
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(17), topRight: Radius.circular(17)),
                                            image: DecorationImage(image: AssetImage("assets/images/logos/${logo[index]}"), fit: BoxFit.fill)),
                                      ),
                                      Text(services_name[index], textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0, color: Colors.white70))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  );
                } else {
                  return Container();
                }
              } else if (snapshot.hasError) {
                print(snapshot.error.toString());
                return Container(
                  child: Center(
                      child: Text(
                        "No Data ",
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      )),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                      backgroundColor: circularBGCol,
                      strokeWidth: strokeWidth,
                      valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol)
                  ),
                );
              }
            },
          )
      ),
    );
  }

  @override
  void initState() {
    _vCode();

  }

  void _vCode() async {
    String projectCode;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectCode = await GetVersion.projectCode;
    } on PlatformException {
      projectCode = 'Failed to get build number.';
    }
    _projectCode = projectCode;

  }
}
*/



/*
import 'package:delivery_on_time/constants.dart';
import 'package:flutter/material.dart';

class ShopDetail extends StatefulWidget{
  @override
  _shop createState() => _shop();

}

class _shop extends State<ShopDetail>{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: darkThemeBlue,
        body: ListView(
          shrinkWrap: true,
          children: [
            Container(
              color: Colors.white,
              width: screenWidth,
              height: screenHeight*0.35,

              child: Stack(

                overflow: Overflow.visible,
                // fit: StackFit.expand,
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Positioned(
                    top: screenHeight*0.35,
                    // bottom: 120,
                    left: 1.0,
                    right: 1.0,
                    child: SingleChildScrollView(
                      child: Column(
                        // shrinkWrap: true,
                        children: [
                          Container(
                              color: Colors.red,
                              width: screenWidth,
                              height: screenHeight*0.6,
                              child: ListView(
                                shrinkWrap: true,
                                primary: false,
                                physics: AlwaysScrollableScrollPhysics(),
                                children: [
                                  Text("hiii"),
                                  SizedBox(height: 30.0,),
                                  SizedBox(height: 30.0,),
                                  SizedBox(height: 30.0,),
                                  Text("hiii"),
                                  SizedBox(height: 30.0,),
                                  SizedBox(height: 30.0,),
                                  SizedBox(height: 30.0,),
                                  Text("hiii"),
                                  SizedBox(height: 30.0,),
                                  SizedBox(height: 30.0,),
                                  Text("hiii"),
                                  SizedBox(height: 30.0,),
                                  SizedBox(height: 30.0,),
                                  Text("hiii"),SizedBox(height: 30.0,),
                                  SizedBox(height: 30.0,),
                                  Text("hiii"),SizedBox(height: 30.0,),
                                  SizedBox(height: 30.0,),
                                  Text("hiii"),
                                ],
                              )

                          ),



                        ],
                      ),
                    ),
                  )
                ],

              ),

            ),



          ],
        ),
      ),
    );
  }

}*/
