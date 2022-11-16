import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/pickupDropPage/pickDropPage02.dart';
import 'package:delivery_on_time/pickup_drop_screen/pickupDropPage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapForPickDrop extends StatelessWidget {
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
      home: MapPickDropPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MapPickDropPage extends StatefulWidget {

  final String adressType;
  final int index;
  const MapPickDropPage({Key key, this.adressType, this.index}) : super(key: key);

  static final kInitialPosition = LatLng(22.6244369, 88.39821959999999);


  @override
  _MapHomePageState createState() => _MapHomePageState(adressType,index);
}

class _MapHomePageState extends State<MapPickDropPage> {

  PickResult selectedPlace;
  final String adressType;
  final int index;

  _MapHomePageState(this.adressType,this.index);

  TextEditingController _addressText = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print('This is the value of n :');
    print(index);

    print('This is the value of destination address list :');
    print(destinationAddressList.length);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          child: PlacePicker(
            hintText: "Type Here to Search",
            apiKey: mapAPIKey,
            initialPosition: MapPickDropPage.kInitialPosition,
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
                                Text(adressType=="pickup"?"SELECT PICKUP LOCATION":"SELECT DROP LOCATION",
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
                                Theme(
                                  data: new ThemeData(
                                    primaryColor: orangeCol,
                                    primaryColorDark: Colors.black,
                                  ),
                                  child: TextFormField(
                                    controller: _addressText,
                                    decoration: new InputDecoration(
                                        labelText: "Enter Landmark of Address".toUpperCase(),
                                        labelStyle: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.black38,
                                            fontWeight: FontWeight.bold
                                        ),
                                        fillColor: Colors.white,
                                        focusColor: orangeCol,
                                        hoverColor: orangeCol
                                      /*border: new OutlineInputBorder(
                                            borderRadius: new BorderRadius.circular(25.0),
                                            borderSide: new BorderSide(),
                                          ),*/
                                      //fillColor: Colors.green
                                    ),
                                    validator: (val) {
                                      if (val.trim().length == 0) {
                                        return "Address Field is Required";
                                      } else {
                                        return null;
                                      }
                                    },
                                    keyboardType: TextInputType.streetAddress,
                                    style: new TextStyle(
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                ),

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
                                        /*if(_addressText.text.trim()==""){
                                              Fluttertoast.showToast(
                                                  msg: "Please Enter Your Landmark",
                                                  fontSize: 14,
                                                  backgroundColor: Colors.orange[100],
                                                  textColor: darkThemeBlue,
                                                  toastLength: Toast.LENGTH_LONG);
                                            }else*/
                                        {
                                          if(adressType=="pickup"){
                                            pickupLandMark=_addressText.text;
                                            pickupAddress="${_selectedPlace.formattedAddress}";
                                            pickUpLat= _selectedPlace.geometry.location.lat;
                                            pickUpLong= _selectedPlace.geometry.location.lng;
                                            print("picker lat long $pickUpLat , $pickUpLong");

                                            senderTextControllerList[0].text = _selectedPlace.formattedAddress;

                                            /*
                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return PickDropPage02();
                                            }));

                                             */


                                             Navigator.pop(context);
                                          }

                                          else if(adressType=="user_settings")
                                            {
                                              user_address = _selectedPlace.formattedAddress;
                                              user_lat = '${_selectedPlace.geometry.location.lat}';
                                              user_long = '${_selectedPlace.geometry.location.lng}';

                                              addressController.text = _selectedPlace.formattedAddress;

                                              print('In user settings');
                                              print(user_lat);


                                              Navigator.pop(context);


                                            }

                                          else if(adressType=="destination"){

                                            destinationLandMark=_addressText.text;
                                            destinationLandmarkList.insert(index,_addressText.text);


                                            destinationAddress="${_selectedPlace.formattedAddress}";


                                            /*
                                            if(destinationAddressList.length > index)
                                              {
                                                destinationAddressList.removeAt(index);
                                              }

                                             */



                                            destinationAddressList.insert(index,_selectedPlace.formattedAddress);
                                            receiverdestinationTextControllerList[index].text = _selectedPlace.formattedAddress;


                                            dropLat= _selectedPlace.geometry.location.lat;
                                            dropLatList.insert(index,_selectedPlace.geometry.location.lat);


                                            droplong= _selectedPlace.geometry.location.lng;
                                            droplongList.insert(index,_selectedPlace.geometry.location.lng);



                                            print("Drop lat long $dropLat , $droplong");
                                            print(destinationAddressList);
                                            
                                            print(_addressText.text);

                                            /*
                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return PickDropPage02();
                                            }));

                                             */

                                             Navigator.pop(context);



                                          }
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