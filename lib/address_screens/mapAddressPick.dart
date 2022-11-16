import 'package:delivery_on_time/address_screens/addressListPage.dart';
import 'package:delivery_on_time/address_screens/bloc/addressAddBloc.dart';
import 'package:delivery_on_time/address_screens/model/addressAddModel.dart';
import 'package:delivery_on_time/cart_screen/cartPage.dart';
import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MapAddressPick extends StatelessWidget {
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
      home: MapAddressPick1(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MapAddressPick1 extends StatefulWidget {

  final String redirectPage;
  static final kInitialPosition = LatLng(22.601859, 88.373795);
  // static final kInitialPosition = LatLng(-33.8567844, 151.213108);

  const MapAddressPick1({Key key, this.redirectPage=""}) : super(key: key);

  @override
  _MapHomePageState createState() => _MapHomePageState();
}

class _MapHomePageState extends State<MapAddressPick1> {
  PickResult selectedPlace;
  String selectedAddress="";

  TextEditingController _houseNo = new TextEditingController();
  TextEditingController _landmark = new TextEditingController();
  TextEditingController _nameAddress = new TextEditingController();


  AddressAddBloc _addressAddBloc;

  String userName = "";
  String userId = "";
  String userToken = "";

  SharedPreferences prefs;


  @override
  void initState() {
    super.initState();
    createSharedPref();
    _addressAddBloc = new AddressAddBloc();
  }

  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    userName = prefs.getString("name");
    userId = prefs.getString("user_id");
    userToken = prefs.getString("user_token");
    print(userToken);
    print(prefs.getString("user_token"));
  }

  navToAttachList(context) async {
    Future.delayed(Duration.zero, () {
      print("push");
      if(widget.redirectPage=="cartPage"){
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
              return CartPageNew();
            }));
      }else{
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
              return AddressListPage();
            }));
      }

    });
  }

  Future<void> managedSharedPref(AddressAddModel data) async {
      prefs.setString("userAddressLat",data.data.latitude);
      prefs.setString("userAddressLong",data.data.longitude);
      prefs.setString("userAddress",data.data.address);
      prefs.setString("userAddressId",data.data.id.toString());
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          child: PlacePicker(
            apiKey: mapAPIKey,
            initialPosition: MapAddressPick1.kInitialPosition,
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
                              // height: 300,
                              color: Colors.white,
                              child: SingleChildScrollView(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(15,15,15,5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "SELECT ADDRESS LOCATION",
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 10.2,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
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
                                            width: 10,
                                          ),
                                          Flexible(
                                            child: Text(
                                              "${_selectedPlace.formattedAddress.substring(_selectedPlace.formattedAddress.indexOf(",")+1).trim()}",
                                              style: TextStyle(color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ],
                                      )),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Theme(
                                        data: new ThemeData(
                                          primaryColor: orangeCol,
                                          primaryColorDark: Colors.black,
                                        ),
                                        child: TextField(
                                          controller: _houseNo,
                                          decoration: new InputDecoration(
                                              labelText: "HOUSE NO./ BLOCK NO.",
                                              labelStyle: TextStyle(
                                                  fontSize: 11.0,
                                                  color: Colors.black38,
                                                  fontWeight: FontWeight.w400
                                              ),
                                              fillColor: Colors.white,
                                              focusColor: orangeCol,
                                              hoverColor: orangeCol
                                          ),
                                          keyboardType: TextInputType.streetAddress,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500
                                        ),),
                                      ),
                                      Theme(
                                        data: new ThemeData(
                                          primaryColor: orangeCol,
                                          primaryColorDark: Colors.black,
                                        ),
                                        child: TextField(
                                          controller: _landmark,
                                          decoration: new InputDecoration(
                                              labelText: "LANDMARK *",
                                              labelStyle: TextStyle(
                                                  fontSize: 11.0,
                                                  color: Colors.black38,
                                                  fontWeight: FontWeight.w400
                                              ),
                                              fillColor: Colors.white,
                                              focusColor: orangeCol,
                                              hoverColor: orangeCol
                                          ),
                                          keyboardType: TextInputType.streetAddress,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500
                                          ),),
                                      ),
                                      Theme(
                                        data: new ThemeData(
                                          primaryColor: orangeCol,
                                          primaryColorDark: Colors.black,
                                        ),
                                        child: TextField(
                                          controller: _nameAddress,
                                          decoration: new InputDecoration(
                                              labelText: "SAVE AS HOME / WORK / OTHER'S NAME *",
                                              labelStyle: TextStyle(
                                                  fontSize: 11.0,
                                                  color: Colors.black38,
                                                  fontWeight: FontWeight.w400
                                              ),
                                              fillColor: Colors.white,
                                              focusColor: orangeCol,
                                              hoverColor: orangeCol
                                          ),
                                          keyboardType: TextInputType.name,
                                          textInputAction: TextInputAction.done,
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500
                                          ),),
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
                                              print("picker lat long ${_selectedPlace.geometry.location.lat} , ${_selectedPlace.geometry.location.lng}");

                                              // print("${_selectedPlace.name}");
                                              // print("${_selectedPlace.formattedAddress}");
                                              // print("${_selectedPlace.adrAddress}");
                                              // for(int i=0;i<_selectedPlace.addressComponents.length;i++){
                                              //   print("${_selectedPlace.addressComponents[i].longName}");
                                              // }

                                              // print("zip : ${_selectedPlace.addressComponents[_selectedPlace.addressComponents.length-1-0].longName}");
                                              // print("state : ${_selectedPlace.addressComponents[_selectedPlace.addressComponents.length-1-2].longName}");
                                              // print("City : ${_selectedPlace.addressComponents[_selectedPlace.addressComponents.length-1-4].longName}");
                                              // selectedAddress="";
                                              // for(int i=1;i<_selectedPlace.addressComponents.length-3;i++){
                                              //   // print("${_selectedPlace.addressComponents[i].longName}, ");
                                              //   selectedAddress+=_selectedPlace.addressComponents[i].longName;
                                              //   if(i<_selectedPlace.addressComponents.length-4)
                                              //   selectedAddress+=", ";
                                              // }
                                              // print("Address : "+selectedAddress);

                                              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
                                              //   return HomeController(currentIndex: pageIndex,);
                                              // }));
                                              try{
                                                if( _landmark.text.trim()=="" ||
                                                    _nameAddress.text.trim()==""
                                                ){
                                                  Fluttertoast.showToast(
                                                      msg: "Please Fill all Required Fields",
                                                      fontSize: 14,
                                                      backgroundColor: Colors.white,
                                                      textColor: darkThemeBlue,
                                                      toastLength: Toast.LENGTH_LONG);
                                                }
                                                else if(700000>=int.parse(_selectedPlace.addressComponents[_selectedPlace.addressComponents.length-1-0].longName)
                                                    || int.parse(_selectedPlace.addressComponents[_selectedPlace.addressComponents.length-1-0].longName)>=749999){
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          // title: Text("Give the code?"),
                                                          content: Padding(
                                                            padding: const EdgeInsets.only(top: 10.0),
                                                            child: Text(
                                                              "Currently We are not Serving at Your Given PIN Code Location",
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 14.0,
                                                                // fontWeight: FontWeight.bold
                                                              ),
                                                            ),
                                                          ),
                                                          actions: [
                                                            new FlatButton(
                                                                child: const Text("Ok, I Understand",
                                                                  style: TextStyle(
                                                                    color: Colors.deepOrangeAccent,
                                                                    fontSize: 14.0,
                                                                    // fontWeight: FontWeight.bold
                                                                  ),),
                                                                onPressed: (){
                                                                  Navigator.pop(context);
                                                                  // setState(() {
                                                                  //   // _zip.text="";
                                                                  // });
                                                                }
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                }
                                                else{
                                                  selectedAddress="";
                                                  for(int i=1;i<_selectedPlace.addressComponents.length-3;i++){
                                                    // print("${_selectedPlace.addressComponents[i].longName}, ");
                                                    selectedAddress+=_selectedPlace.addressComponents[i].longName;
                                                    if(i<_selectedPlace.addressComponents.length-4)
                                                      selectedAddress+=", ";
                                                  }
                                                  Map body = {
                                                    "address": "${_houseNo.text.trim()!=""?_houseNo.text.trim()+", ":""}$selectedAddress",
                                                    "city": "${_selectedPlace.addressComponents[_selectedPlace.addressComponents.length-1-4].longName}",
                                                    "state": "${_selectedPlace.addressComponents[_selectedPlace.addressComponents.length-1-2].longName}",
                                                    "zip": "${_selectedPlace.addressComponents[_selectedPlace.addressComponents.length-1-0].longName}",
                                                    "landmark": "${_landmark.text.trim()}",
                                                    "userid": "$userId",
                                                    "address_name": "${_nameAddress.text.trim().toUpperCase()}",
                                                    "longitude" : "${_selectedPlace.geometry.location.lng}",
                                                    "latitude" : "${_selectedPlace.geometry.location.lat}",
                                                    "is_default":"1"
                                                  };
                                                  print(body);
                                                  // print(_selectedPlace.formattedAddress);

                                                  _addressAddBloc.addressAdd(body, userToken);
                                                }
                                              }catch(ex){
                                                print(ex);
                                                if(ex.toString().contains("FormatException: Invalid radix-10 number")){
                                                  Fluttertoast.showToast(
                                                      msg: "Please Select proper address with valid PIN code",
                                                      fontSize: 14,
                                                      backgroundColor: Colors.orange[100],
                                                      textColor: darkThemeBlue,
                                                      toastLength: Toast.LENGTH_LONG);
                                                }else{
                                                  Fluttertoast.showToast(
                                                      msg: "Please try again!",
                                                      fontSize: 14,
                                                      backgroundColor: Colors.orange[100],
                                                      textColor: darkThemeBlue,
                                                      toastLength: Toast.LENGTH_LONG);
                                                }
                                              }


                                            },
                                            color: orangeCol,
                                            textColor: Colors.white,
                                            child: StreamBuilder<ApiResponse<AddressAddModel>>(
                                              stream: _addressAddBloc.addressAddStream,
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  switch (snapshot.data.status) {
                                                    case Status.LOADING:
                                                      return CircularProgressIndicator(
                                                          backgroundColor: circularBGCol,
                                                          strokeWidth: strokeWidth,
                                                          valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol));                                                      break;
                                                    case Status.COMPLETED:
                                                      print("complete");
                                                      managedSharedPref(snapshot.data.data);
                                                      navToAttachList(context);
                                                      Fluttertoast.showToast(
                                                          msg: "Address Added Successfully",
                                                          fontSize: 14,
                                                          backgroundColor: Colors.white,
                                                          textColor: darkThemeBlue,
                                                          toastLength: Toast.LENGTH_LONG);

                                                      break;
                                                    case Status.ERROR:
                                                      print(snapshot.error);
                                                      Fluttertoast.showToast(
                                                          msg: "Something Happened Wrong. Please try Again!",
                                                          fontSize: 14,
                                                          backgroundColor: Colors.white,
                                                          textColor: darkThemeBlue,
                                                          toastLength: Toast.LENGTH_LONG);
                                                      break;
                                                  }
                                                } else if (snapshot.hasError) {
                                                  print("error");
                                                }

                                                return Text("Select This Address".toUpperCase(),
                                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold));
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
