import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/pickup_drop_screen/pickupDropPage.dart';
import 'package:delivery_on_time/screens/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapCurrentAddressPicker extends StatelessWidget {
  // Light Theme
  final ThemeData lightTheme = ThemeData.light().copyWith(
    // Background color of the FloatingCard
    cardColor: Colors.white,
    buttonTheme: ButtonThemeData(
      // Select here's button color
      buttonColor: orangeCol,
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
      home: MapHomePage1(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MapHomePage1 extends StatefulWidget {
  final int pageIndex;
  static final kInitialPosition = LatLng(22.601859, 88.373795);
  // static final kInitialPosition = LatLng(-33.8567844, 151.213108);

  const MapHomePage1({Key key, this.pageIndex}) : super(key: key);

  @override
  _MapHomePageState createState() => _MapHomePageState(pageIndex);
}

class _MapHomePageState extends State<MapHomePage1> {
  PickResult selectedPlace;
  final int pageIndex;

  _MapHomePageState(this.pageIndex);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          child: PlacePicker(
            apiKey: mapAPIKey,
            initialPosition: MapHomePage1.kInitialPosition,
            useCurrentLocation: true,
            selectInitialPosition: true,
            usePinPointingSearch: true,
            usePlaceDetailSearch: true,
            // myLocationButtonCooldown: 5,
            onPlacePicked: (result) {
              selectedPlace = result;
              Navigator.of(context).pop();
              setState(() {});
            },
//vbdssg
            forceSearchOnZoomChanged: true,
            automaticallyImplyAppBarLeading: false,
            autocompleteLanguage: "en",

            region: 'IN',
            // selectInitialPosition: true,
            selectedPlaceWidgetBuilder: (_, _selectedPlace, state, isSearchBarFocused) {
              print("state: $state, isSearchBarFocused: $isSearchBarFocused");
              return isSearchBarFocused
                  ? Container()
                  : FloatingCard(
                      bottomPosition: 0.0,
                      // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                      leftPosition: 0.0,
                      rightPosition: 0.0,
                      color: Colors.white.withOpacity(0),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                      child: state == SearchingState.Searching
                          ? Container(
                              height: 70.0,
                              child: Center(
                                child: SizedBox(
                                  width: 35.0,
                                  height: 35.0,
                                  child: CircularProgressIndicator(
                                    backgroundColor: circularBGCol,
                                    strokeWidth: 5,
                                    valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              // height: 200,
                              height: 200,
                              color: Colors.white,
                              child: SingleChildScrollView(
                                child: Container(
                                  margin: EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "SELECT LOCATION",
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 10.2,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                      SizedBox(
                                        height: screenHeight * 0.02,
                                      ),
                                      Container(
                                          child: Row(
                                        children: [
                                          Icon(
                                            Icons.pin_drop_outlined,
                                            size: 25.0,
                                            color: Colors.deepOrange,
                                          ),
                                          SizedBox(
                                            width: screenWidth * 0.02,
                                          ),
                                          Flexible(
                                            child: Text(
                                              "${_selectedPlace.formattedAddress}",
                                              style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ],
                                      )),
                                      SizedBox(
                                        height: screenHeight * 0.02,
                                      ),

                                      //Sign In Button.....

                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                                        child: ButtonTheme(
                                          //__To Enlarge Button Size__
                                          height: 50.0,
                                          minWidth: screenWidth * .8,
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12.0),
                                            ),
                                            onPressed: () {
                                              userAddress = "${_selectedPlace.formattedAddress}";
                                              userLat = _selectedPlace.geometry.location.lat;
                                              userLong = _selectedPlace.geometry.location.lng;
                                              print("picker lat long $pickUpLat , $pickUpLong");
                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
                                                return HomeController(currentIndex: pageIndex,);
                                              }));
                                            },
                                            color: orangeCol,
                                            textColor: Colors.white,
                                            child: Text("Select This Location".toUpperCase(),
                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )));
            },
            pinBuilder: (context, state) {
              if (state == PinState.Idle) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Image.asset(
                    "assets/images/icons/pin.png",
                    height: 40.0,
                  ),
                );
                // Icon(Icons.location_on,
                // size: 34.0,);
              } else {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 30.0, left: 12.0),
                  child: Image.asset(
                    "assets/images/icons/pin_shadow.png",
                    height: 44.0,
                  ),
                );
                //   Icon(Icons.location_history);
              }
            },
//dfdfh
          ),
        ),
      ),
    ));
  }
}

/*RaisedButton(
                                child: Text("Pick Here"),
                                onPressed: () {
                                  // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                                  //            this will override default 'Select here' Button.
                                  print(
                                      "do something with [selectedPlace] data");
                                  print(
                                      "place :: ${_selectedPlace.geometry.location.lat}");
                                  print(
                                      "place :: ${_selectedPlace.geometry.location.lng}");
                                  // Navigator.of(context).pop();
                                },
                              ),*/
