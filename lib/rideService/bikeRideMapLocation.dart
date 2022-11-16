import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/rideService/rideDataClass.dart';
import 'package:delivery_on_time/rideService/rideStartingPage.dart';
import 'package:delivery_on_time/screens/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';

class BikeRideMapLocation extends StatefulWidget {

  final String locationType;
  final RideDataStore rideDataStore;

  const BikeRideMapLocation({Key key, this.locationType, this.rideDataStore}) : super(key: key);

  @override
  _BikeRideMapLocationState createState() => _BikeRideMapLocationState(this.locationType, this.rideDataStore);
}

class _BikeRideMapLocationState extends State<BikeRideMapLocation> {

  final String locationType;
  final RideDataStore rideDataStore;

  _BikeRideMapLocationState(this.locationType, this.rideDataStore);

  PickResult selectedPlace;
  var kInitialPosition;

  @override
  void initState() {
    super.initState();
    if(locationType=="pickup"){
      if (rideDataStore.pickUpLocation != null)
        kInitialPosition = LatLng(rideDataStore.pickLat, rideDataStore.pickLng);
      else
        kInitialPosition = LatLng(userLat!=null?userLat:22.601775, userLong!=null?userLong:88.373685);
    }else if(locationType=="destination"){
      if (rideDataStore.dropLocation != null)
        kInitialPosition = LatLng(rideDataStore.dropLat, rideDataStore.dropLng);
      else
        kInitialPosition = LatLng(userLat!=null?userLat:22.601775, userLong!=null?userLong:88.373685);
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          child: PlacePicker(
            hintText: "Search $locationType Location",
            apiKey: mapAPIKey,
            initialPosition: kInitialPosition,
            useCurrentLocation: false,
            selectInitialPosition: true,
            usePinPointingSearch: true,
            usePlaceDetailSearch: true,
            enableMapTypeButton: false,
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
            selectedPlaceWidgetBuilder:
                (_, _selectedPlace, state, isSearchBarFocused) {
              print("state: $state, isSearchBarFocused: $isSearchBarFocused");
              return
                isSearchBarFocused
                    ?
                Container()
                    :
                FloatingCard(
                    bottomPosition: 00.0,
                    // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                    leftPosition: 0.0,
                    rightPosition: 0.0,
                    color: Colors.white.withOpacity(0),
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10.0)
                    ),
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
                            valueColor: AlwaysStoppedAnimation<Color>(
                                circularStrokeCol),
                          ),
                        ),
                      ),
                    )
                        : Container(
                      // height: 200,
                      //   height: 250,
                        color: Colors.white,
                        child: SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("SELECT $locationType LOCATION".toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 10.2,
                                    fontFamily: "Poppins",
                                  ),),
                                SizedBox(height: screenHeight*0.015,),
                                Container(child: Row(
                                  children: [
                                    Icon(Icons.pin_drop_outlined,
                                      size: 25.0,
                                      color: Colors.deepOrange,
                                    ),
                                    SizedBox(width: screenWidth*0.02,),
                                    Flexible(
                                      child: Text("${_selectedPlace.formattedAddress}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400

                                        ),),
                                    ),
                                  ],
                                )),
                                SizedBox(height: screenHeight *0.01,),

                                //Sign In Button.....

                                Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                                  child: ButtonTheme(   //__To Enlarge Button Size__
                                    height: 50.0,
                                    minWidth: screenWidth*.8,
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      onPressed: () {
                                          if(locationType=="pickup"){
                                            rideDataStore.pickUpLocation=_selectedPlace;
                                            rideDataStore.pickLat= _selectedPlace.geometry.location.lat;
                                            rideDataStore.pickLng= _selectedPlace.geometry.location.lng;
                                            print("picker lat long $pickUpLat , $pickUpLong");
                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return HomeController(currentIndex: 0,rideDataStore: rideDataStore);
                                            }));
                                            // Navigator.pop(context);
                                          }else if(locationType=="destination"){
                                            rideDataStore.dropLocation=_selectedPlace;
                                            rideDataStore.dropLat= _selectedPlace.geometry.location.lat;
                                            rideDataStore.dropLng= _selectedPlace.geometry.location.lng;
                                            print("Drop lat long $dropLat , $droplong");
                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return HomeController(currentIndex: 0,rideDataStore: rideDataStore);
                                            }));
                                            // Navigator.pop(context);

                                          }
                                      },
                                      color: orangeCol,
                                      textColor: Colors.white,
                                      child: Text("Select This Location".toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold
                                          )),
                                    ),

                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                );
            },
            pinBuilder: (context, state) {
              if (state == PinState.Idle) {
                return
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Image.asset("assets/images/icons/pin.png",
                      height: 40.0,),
                  );
                // Icon(Icons.location_on,
                // size: 34.0,);
              } else {
                return
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0,left: 12.0),
                    child: Image.asset("assets/images/icons/pin_shadow.png",
                      height: 44.0,),
                  );
                //   Icon(Icons.location_history);
              }
            },
//dfdfh
          ),
        ),
      ),
    );

  }
}
