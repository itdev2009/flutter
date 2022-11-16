import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/loginMobile_screen/otpVerificationPage.dart';
import 'package:delivery_on_time/pickup_drop_screen/bloc/mapDistanceBloc.dart';
import 'package:delivery_on_time/pickup_drop_screen/model/mapDistanceModel.dart';
import 'package:delivery_on_time/rideService/rideDataClass.dart';
import 'package:delivery_on_time/rideService/rideRouteScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RideServicePage extends StatefulWidget {
  @override
  _RideServicePageState createState() => _RideServicePageState();
}

class _RideServicePageState extends State<RideServicePage> {
  PickResult selectedPlace;

  // PickResult pickUpLocation;
  // PickResult dropLocation;
  bool isPickup = true;
  String userToken;
  RideDataStore _rideDataStore;
  bool mapApiCheck = false;
  MapDistanceBloc _mapDistanceBloc;

  // TextEditingController _addressText = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _phoneNumberController=new TextEditingController();

  var kInitialPosition;

  @override
  void initState() {
    super.initState();
    _rideDataStore = new RideDataStore();
    _mapDistanceBloc = new MapDistanceBloc();
    if (_rideDataStore.pickUpLocation != null)
      kInitialPosition = LatLng(_rideDataStore.pickLat, _rideDataStore.pickLng);
    else
      kInitialPosition = LatLng(userLat!=null?userLat:22.601775, userLong!=null?userLong:88.373685);
    createSharedPref();
  }

  Future<void> createSharedPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString("user_token");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight * .9,
          child: PlacePicker(
            hintText: "Type Here to Search",
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

            selectedPlaceWidgetBuilder: (_, _selectedPlace, state, isSearchBarFocused) {
              if (isPickup == true) {
                _rideDataStore.pickUpLocation = _selectedPlace;
                if (_selectedPlace != null) {
                  _rideDataStore.pickLat = _selectedPlace.geometry.location.lat;
                  _rideDataStore.pickLng = _selectedPlace.geometry.location.lng;
                }
              } else if (isPickup == false) {
                _rideDataStore.dropLocation = _selectedPlace;
                _rideDataStore.dropLat = _selectedPlace.geometry.location.lat;
                _rideDataStore.dropLng = _selectedPlace.geometry.location.lng;
              }
              print("state: $state, isSearchBarFocused: $isSearchBarFocused");
              return isSearchBarFocused
                  ? Container()
                  : FloatingCard(
                      bottomPosition: 00.0,
                      // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                      leftPosition: 0.0,
                      rightPosition: 0.0,
                      color: Colors.white.withOpacity(0),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                      child: state == SearchingState.Searching
                          ? SizedBox(
                              height: 200,
                              child: Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: circularBGCol,
                                  strokeWidth: 5,
                                  valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol),
                                ),
                              ),
                            )
                          : Container(
                              // height: 200,
                              //   height: 250,
                              color: Colors.white,
                              child: SingleChildScrollView(
                                child: Container(
                                  margin: EdgeInsets.only(top: 15, bottom: 30),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10.0),
                                        child: Text(
                                          "SELECT PICKUP LOCATION",
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 10.2,
                                            fontFamily: "Poppins",
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          print("pick location");
                                          isPickup = true;
                                          if (_rideDataStore.pickUpLocation != null)
                                            kInitialPosition = LatLng(_rideDataStore.pickLat, _rideDataStore.pickLng);

                                          setState(() {});
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                                          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            border: Border.all(color: isPickup ? lightOrangeCol : Colors.grey[300]),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.pin_drop_outlined,
                                                size: 25.0,
                                                color: Colors.green,
                                              ),
                                              SizedBox(
                                                width: screenWidth * 0.02,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    isPickup
                                                        ? Text(
                                                            "${_selectedPlace.formattedAddress}",
                                                            overflow: TextOverflow.ellipsis,
                                                            style:
                                                                TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w400),
                                                          )
                                                        : Text(
                                                            _rideDataStore.pickUpLocation.formattedAddress,
                                                            style:
                                                                TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w400),
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: screenHeight * 0.015,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10.0),
                                        child: Text(
                                          "SELECT DROP LOCATION",
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 10.2,
                                            fontFamily: "Poppins",
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          isPickup = false;
                                          if (_rideDataStore.dropLocation != null)
                                            kInitialPosition = LatLng(_rideDataStore.dropLat, _rideDataStore.dropLng);

                                          setState(() {});
                                        },
                                        child: Container(
                                            padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                                            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              border: Border.all(color: !isPickup ? lightOrangeCol : Colors.grey[300]),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.pin_drop_outlined,
                                                  size: 25.0,
                                                  color: Colors.red,
                                                ),
                                                SizedBox(
                                                  width: screenWidth * 0.02,
                                                ),
                                                Expanded(
                                                  child: _rideDataStore.dropLocation != null
                                                      ? Text(
                                                          _rideDataStore.dropLocation.formattedAddress,
                                                          overflow: TextOverflow.ellipsis,
                                                          style:
                                                              TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w400),
                                                        )
                                                      : Text(
                                                          "Enter  Drop Location",
                                                          style:
                                                              TextStyle(color: Colors.black54, fontSize: 14.0, fontWeight: FontWeight.w400),
                                                        ),
                                                )
                                              ],
                                            )),
                                      ),

                                      //Proceed Button.....

                                      Container(
                                        margin: EdgeInsets.only(top: 10),
                                        alignment: Alignment.center,
                                        child: ButtonTheme(
                                          //__To Enlarge Button Size__
                                          height: 50.0,
                                          minWidth: screenWidth * .8,
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12.0),
                                            ),
                                            onPressed: () {
                                              {
                                                if (userToken == "" || userToken==null) {
                                                  modalSheetToLogin();
                                                }else if (_rideDataStore.pickUpLocation != null && _rideDataStore.dropLocation != null) {
                                                  mapApiCheck = true;
                                                  _mapDistanceBloc.mapDistanceCal(_rideDataStore.pickLat, _rideDataStore.pickLng,
                                                      _rideDataStore.dropLat, _rideDataStore.dropLng);
                                                }else{
                                                  Fluttertoast.showToast(
                                                      msg: "Please Select Pickup and Drop Location",
                                                      fontSize: 15,
                                                      backgroundColor: Colors.orange[100],
                                                      textColor: darkThemeBlue,
                                                      toastLength: Toast.LENGTH_LONG);
                                                }
                                              }
                                            },
                                            color: orangeCol,
                                            textColor: Colors.white,
                                            child: StreamBuilder<ApiResponse<MapDistanceModel>>(
                                              stream: _mapDistanceBloc.mapDistanceStream,
                                              builder: (context, snapshot) {
                                                if (mapApiCheck) {
                                                  if (snapshot.hasData) {
                                                    switch (snapshot.data.status) {
                                                      case Status.LOADING:
                                                        return CircularProgressIndicator(
                                                            backgroundColor: circularBGCol,
                                                            strokeWidth: strokeWidth,
                                                            valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol));

                                                        break;
                                                      case Status.COMPLETED:
                                                        {
                                                          if (snapshot.data.data.rows[0].elements[0].status == "ZERO_RESULTS") {
                                                            mapApiCheck = false;
                                                            Fluttertoast.showToast(
                                                                msg: "Please Select a Proper Pickup or Drop Place",
                                                                fontSize: 14,
                                                                backgroundColor: Colors.orange[100],
                                                                textColor: darkThemeBlue,
                                                                toastLength: Toast.LENGTH_LONG);
                                                          } else {
                                                            mapApiCheck = false;
                                                            int distance = snapshot.data.data.rows[0].elements[0].distance.value;
                                                            _rideDataStore.distance = distance / 1000;
                                                            _rideDataStore.travellingTime = snapshot.data.data.rows[0].elements[0].duration.text;
                                                            _rideDataStore.distanceText = snapshot.data.data.rows[0].elements[0].distance.text;

                                                            Future.delayed(Duration.zero, () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (BuildContext context) => RideRouteScreen(
                                                                            userToken: userToken,
                                                                            rideDataStore: _rideDataStore,
                                                                          )));
                                                            });
                                                          }
                                                        }
                                                        break;
                                                      case Status.ERROR:
                                                        mapApiCheck = false;
                                                        Fluttertoast.showToast(
                                                            msg: "Please try again!",
                                                            fontSize: 14,
                                                            backgroundColor: Colors.orange[100],
                                                            textColor: darkThemeBlue,
                                                            toastLength: Toast.LENGTH_LONG);
                                                        print(snapshot.data.message);
                                                        break;
                                                    }
                                                  } else if (snapshot.hasError) {
                                                    mapApiCheck = false;
                                                    print(snapshot.error);
                                                  }
                                                }
                                                return Text("Proceed",
                                                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500));
                                              },
                                            ),
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
    );
  }

  modalSheetToLogin() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0),),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Please Login to Proceed",
                  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 6.0,
                ),
                Theme(
                  data: new ThemeData(
                    primaryColor: orangeCol,
                    primaryColorDark: Colors.black,
                  ),
                  child: TextFormField(
                    validator: (value)=> value.isEmpty?"*Phone Number Required":value.length<10?"*Please Enter Proper Phone Number":null,
                    controller: _phoneNumberController,
                    decoration: new InputDecoration(
                        labelText: "Enter Mobile Number",
                        prefixText: "+91 ",
                        prefixStyle: GoogleFonts.poppins(
                            fontSize: 13.0,
                            color: orangeCol,
                            fontWeight: FontWeight.w500
                        ),
                        labelStyle: GoogleFonts.poppins(
                            fontSize: 14.0,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400
                        ),
                        fillColor: Colors.white,
                        focusColor: orangeCol,
                        hoverColor: orangeCol
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      LengthLimitingTextInputFormatter(10),
                    ],
                    textInputAction: TextInputAction.done,
                    style: GoogleFonts.poppins(
                        fontSize: 13.0,
                        color: orangeCol,
                        fontWeight: FontWeight.w500
                    ),),
                ),
                SizedBox(
                  height: 16.0,
                ),
                InkWell(
                  onTap: (){
                    final FormState form = _formKey.currentState;
                    if (form.validate()) {
                      print('Form is valid');
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return OtpVerificationPage(phoneNumber: _phoneNumberController.text.trim(),
                              redirectPage: "bikeRide",);

                          }));
                    } else {
                      print('Form is invalid');
                    }
                  },
                  child: Container(
                      height: 40.0,
                      width: MediaQuery.of(context).size.width,
                      // margin: EdgeInsets.all(2),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.white70,
                                // offset: Offset(2, 4),
                                blurRadius: 5,
                                spreadRadius: 2)
                          ],
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xffeb8a35), Color(0xffe36126)])),
                      child: Text(
                        'Continue',
                        style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w500, color: Colors.white),
                      )

                  ),
                ),
                // SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        );
      },
    );
  }
}
