import 'package:delivery_on_time/configDetails/model/configDetailsModel.dart';
import 'package:delivery_on_time/configDetails/repository/configDetailsRepo.dart';
import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/loginMobile_screen/loginByMobile.dart';
import 'package:delivery_on_time/pickupDropPage/pickDropPage04.dart';
import 'package:delivery_on_time/pickup_drop_screen/bloc/mapDistanceBloc.dart';
import 'package:delivery_on_time/pickup_drop_screen/model/mapDistanceModel.dart';
import 'package:delivery_on_time/pickup_drop_screen/repository/pickupDropRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latlong/latlong.dart' as latlong;

import '../customAlertDialog.dart';

class PickDropPage03 extends StatefulWidget {
  @override
  _PickDropPage03State createState() => _PickDropPage03State();
}

class _PickDropPage03State extends State<PickDropPage03> {
  List<RadioModel> vehicleRadioData = new List<RadioModel>();
  List<RadioModel> paymentUserRadioData = new List<RadioModel>();
  List<RadioModel> productPaymentUserRadioData = new List<RadioModel>();

  TextEditingController _productPrice;

  List<String> vehicleTypeName = [
    "Two-Wheeler",
    "Four-Wheeler",
  ];
  List<String> vehicleTypeLimit = [
    "(Upto 20km)",
    "(Upto 50km)",
  ];

  List<String> vehicleLogo = [
    "two_wheeler.png",
    // "edited-3.jpg",
    "edited-5.png"
  ];

  List<String> paymentUserType = [
    "Sender",
    "Receiver",
  ];

  List<String> productPaymentUserType = [
    "Sender",
    "Receiver",
  ];

  List<String> paymentUserLogo = [
    "sender.png",
    "receiver.png",
  ];

//"Cash Payment",
  List<String> _dropdownPaymentType = [
    "Cash Payment",
    "Online Payment",
  ];
  String _selectedPaymentType = "Cash Payment";

  bool mapApiCheck = false;
  List<DropdownMenuItem<String>> _dropdownMenuIPaymentType;

  List<RateChartConfig> twoWheelerMorningRate = [];
  List<RateChartConfig> twoWheelerNightRate = [];
  List<RateChartConfig> fourWheelerRate = [];
  List<RateChartConfig> extraPersonTwoWheelerRate = [];

  bool firstCheck = true;
  bool extraPersonVisibility = true;
  bool extraPersonRequired1 = extraPersonRequired;
  int vehicleIndex1 = vehicleIndex;
  int paymentUserIndex1 = paymentUserIndex;
  int productPaymentUserIndex1 = productPaymentUserIndex;

  // int paymentUserIndex1 = 0;
  // int productPaymentUserIndex1 = 0;

  //final paymentType = 'Online Payment';
  //final paymentType = 'Online Payment';

  TextEditingController _deliveryDateTimeText;

  MapDistanceBloc _mapDistanceBloc;
  ConfigDetailsRepository _configDetailsRepository;

  SharedPreferences prefs;
  SharedPreferences forcake;
  bool itscake = false;
  String userToken;
  Future<ConfigDetailsModel> _configApi;
  bool expiredToken = false;
  PickupDropRepository pickupDropRepository = new PickupDropRepository();

  final latlong.Distance distance = new latlong.Distance();

  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    forcake = await SharedPreferences.getInstance();
    userToken = prefs.getString("user_token");
    itscake = forcake.getBool('cakeprefs');
    print('CAKE VALUE ${itscake}');
    _configApi = _configDetailsRepository.configDetails(userToken);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _configDetailsRepository = new ConfigDetailsRepository();
    createSharedPref();
    vehicleRadioData.add(new RadioModel(vehicleIndex == 0, vehicleTypeName[0]));
    vehicleRadioData.add(new RadioModel(vehicleIndex == 1, vehicleTypeName[1]));
    paymentUserRadioData
        .add(new RadioModel(paymentUserIndex == 0, paymentUserType[0]));
    paymentUserRadioData
        .add(new RadioModel(paymentUserIndex == 1, paymentUserType[1]));
    productPaymentUserRadioData
        .add(new RadioModel(paymentUserIndex == 0, productPaymentUserType[0]));
    productPaymentUserRadioData
        .add(new RadioModel(paymentUserIndex == 1, productPaymentUserType[1]));
    _dropdownMenuIPaymentType = buildDropDownMenuItems(_dropdownPaymentType);
    //_selectedPaymentType = paymentType;
    _selectedPaymentType = 'Cash Payment';
    _deliveryDateTimeText =
        new TextEditingController(text: dateAndTimeFormated);
    _productPrice = new TextEditingController(text: productPrice);
    _mapDistanceBloc = new MapDistanceBloc();
    paymentType = 'Cash Payment';

    copydropLatList.clear();
    copydroplongList.clear();

    print(destinationAddressList.length);

    for (int i = 0; i < (destinationAddressList.length - 150); i++) {
      print(destinationAddressList[i]);
    }

    for (int i = 0; i < numberOfReceivers; i++) {
      print(dropLatList[i]);
    }

    copydropLatList.add(pickUpLat);

    for (int i = 0; i < numberOfReceivers; i++) {
      copydropLatList.add(dropLatList[i]);
    }

    for (int i = 0; i < numberOfReceivers + 1; i++) {
      print(copydropLatList[i]);
    }

    copydroplongList.add(pickUpLong);

    for (int i = 0; i < numberOfReceivers; i++) {
      copydroplongList.add(droplongList[i]);
    }

    for (int i = 0; i < numberOfReceivers + 1; i++) {
      print(copydroplongList[i]);
    }

    print(receivernameControllerList.length);

    for (int i = 0; i < numberOfReceivers; i++) {
      print(receivernameControllerList[i].text);
    }

    totalDistanceInM = 0;
    DistanceInM = 0;
    totalpriceList.clear();
    finalPrice = 0;
    distanceList.clear();
    totalDistanceusingGoogle = 0;

    print('INIT STATE');
  }

  List<DropdownMenuItem<String>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<String>> items = List();
    for (String listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem),
          value: listItem,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: lightThemeBlue,
      appBar: AppBar(
        backgroundColor: darkerThemeBlue,
        title: Text(
          "Pickup Request",
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<ConfigDetailsModel>(
          future: _configApi,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.message
                  .toString()
                  .contains("Token has been expired")) {
                print('token expired');
                //  modalSheetToLogin();

                //  Navigator.pop(context);

                userLogin = false;
                prefs.clear();
                // signOutUser();
                // logout();
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (BuildContext context) {
                //       return Login();

                //     }));

                Fluttertoast.showToast(
                    msg: "Your login session has expired, please re-login!",
                    fontSize: 14,
                    backgroundColor: Colors.orange[100],
                    textColor: darkThemeBlue,
                    toastLength: Toast.LENGTH_LONG);

                //Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);

                // Navigator.pop(context);

                Future.delayed(Duration.zero, () {
                  //  Navigator. ...

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              LoginByMobilePage()),
                      ModalRoute.withName('/home'));
                });

                expiredToken = true;
              }

              if (firstCheck && expiredToken == false) {
                for (int i = 0;
                    i < snapshot.data.data.rateChartConfig.length;
                    i++) {
                  // for all list iterate
                  if (snapshot.data.data.rateChartConfig[i].vehicleType ==
                      "2W") {
                    // for 2W checking
                    if (snapshot.data.data.rateChartConfig[i].timeFrom
                        .contains("10:00")) {
                      // for 2W morning timing
                      twoWheelerMorningRate
                          .add(snapshot.data.data.rateChartConfig[i]);
                    } else if (snapshot.data.data.rateChartConfig[i].timeFrom
                        .contains("22:00")) {
                      // for 2W night timing
                      twoWheelerNightRate
                          .add(snapshot.data.data.rateChartConfig[i]);
                    }
                  } else if (snapshot
                          .data.data.rateChartConfig[i].vehicleType ==
                      "4W") {
                    // for 4W checking
                    fourWheelerRate.add(snapshot.data.data.rateChartConfig[i]);
                  } else if (snapshot
                          .data.data.rateChartConfig[i].vehicleType ==
                      "ExtraPerson") {
                    // for 2W extra person checking
                    extraPersonTwoWheelerRate
                        .add(snapshot.data.data.rateChartConfig[i]);
                  }
                }

                firstCheck = false;
              }
              return ListView(
                shrinkWrap: true,
                padding: EdgeInsets.fromLTRB(11.0, 0.0, 11.0, 0.0),
                physics: ScrollPhysics(),
                children: [
                  //Vehicle
                  Padding(
                    padding: EdgeInsets.fromLTRB(5.0, 12.0, 0.0, 12.0),
                    child: Text("Vehicle Types",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: screenWidth * 0.04,
                            color: Colors.white70)),
                  ),
                  Padding(
                    // height: screenHeight*0.7,
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 11.0),
                    child: GridView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: vehicleLogo.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 60 / 68,
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            vehicleRadioData.forEach(
                                (element) => element.isSelected = false);
                            vehicleRadioData[index].isSelected = true;
                            vehicleType = vehicleRadioData[index].text;
                            if (index == 1) {
                              extraPersonRequired = false;
                              extraPersonRequired1 = false;
                            }

                            setState(() {
                              this.vehicleIndex1 = index;
                              vehicleIndex = index;
                            });
                          },
                          child: Card(
                            color: darkThemeBlue,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0))),
                            elevation: 5,
                            shadowColor: darkThemeBlue,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 20,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                          right: 10,
                                          top: 0,
                                          child: Icon(
                                            Icons.check_circle,
                                            color: (vehicleRadioData[index]
                                                    .isSelected)
                                                ? orangeCol
                                                : Colors.white30,
                                            size: 21,
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Image.asset(
                                  "assets/images/icons/pickup_icons/${vehicleLogo[index]}",
                                  height: 70,
                                  width: 70,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(vehicleTypeName[index],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: screenWidth * 0.038,
                                        color: Colors.white70)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(vehicleTypeLimit[index],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: screenWidth * 0.038,
                                        color: Colors.white70)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 10.0, 10.0, 15.0),
                    child: Visibility(
                      visible: vehicleIndex == 0,
                      child: Row(
                        children: [
                          Visibility(
                            visible: itscake == false,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "ADD EXTRA PERSON/SCOOTY",
                                    textAlign: TextAlign.start,
                                    //  style: GoogleFonts.romanesco(

                                    //  fontWeight: FontWeight.w500, fontSize: screenWidth * 0.06, color: Colors.white70)),

                                    style: TextStyle(
                                        //fontFamily: 'BoldItalic',
                                        fontWeight: FontWeight.w500,
                                        fontSize: screenWidth * 0.05,
                                        color: Colors.white70),
                                  ),
                                ),
                                /*   Text("",
                                    textAlign: TextAlign.start,
                                     style: GoogleFonts.poppins(

                                         fontWeight: FontWeight.w400, fontSize: screenWidth * 0.06, color: Colors.white70)),

                               */
                              ],
                            ),
                          ),
                          Spacer(),
                          Visibility(
                            visible: itscake == false,
                            child: FlutterSwitch(
                              width: 45.0,
                              height: 23.0,
                              valueFontSize: 0.0,
                              toggleSize: 16.0,
                              value: extraPersonRequired1,
                              borderRadius: 30.0,
                              padding: 3.0,
                              showOnOff: true,
                              activeColor: darkThemeBlue,
                              inactiveToggleColor:
                                  Color.fromRGBO(78, 121, 151, 1),
                              activeToggleColor: Colors.lightGreen[200],
                              inactiveColor: darkThemeBlue,
                              switchBorder: Border.all(
                                color: Color.fromRGBO(78, 121, 151, 1),
                                width: 1.0,
                              ),
                              onToggle: (val) {
                                setState(() {
                                  extraPersonRequired1 = val;
                                  extraPersonRequired = val;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //Payable Person
                  Padding(
                    padding: EdgeInsets.fromLTRB(12.0, 0.0, 0.0, 12.0),
                    child: Text("Who will pay the delivery charge?",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: screenWidth * 0.04,
                            color: Colors.white70)),
                  ),
                  Padding(
                    // height: screenHeight*0.7,
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 11.0),
                    child: GridView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: paymentUserType.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 60 / 62,
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            paymentUserRadioData.forEach(
                                (element) => element.isSelected = false);
                            paymentUserRadioData[index].isSelected = true;
                            this.paymentUserIndex1 = index;
                            paymentUser = paymentUserRadioData[index].text;
                            paymentUserIndex = index;
                            // paymentType = 'Online Payment';

                            if (index == 0) {
                              _selectedPaymentType = "Cash Payment";
                              paymentType = "Cash Payment";

                              setState(() {});
                            }

                            if (index == 1) {
                              //  _selectedPaymentType = "Online Payment";
                              // paymentType = "Online Payment";

                              setState(() {});
                            }

                            print('THIS IS THE PAYMENT TYPE AFTER TAP:');
                            print(paymentType);
                          },
                          child: Card(
                            color: darkThemeBlue,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0))),
                            elevation: 5,
                            shadowColor: darkThemeBlue,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 20,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                          right: 10,
                                          top: 0,
                                          child: Icon(
                                            Icons.check_circle,
                                            color: (paymentUserRadioData[index]
                                                    .isSelected)
                                                ? orangeCol
                                                : Colors.white30,
                                            size: 21,
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Image.asset(
                                  "assets/images/icons/pickup_icons/${paymentUserLogo[index]}",
                                  height: 70,
                                  width: 70,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(paymentUserType[index],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: screenWidth * 0.038,
                                        color: Colors.white70))
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  Visibility(
                    visible: paymentUser == "Sender",
                    // visible: paymentUserIndex == 0,
                    child: Container(
                      height: 55.0,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 0, left: 15, right: 15),
                      margin: EdgeInsets.only(left: 4, right: 4, bottom: 15),
                      decoration: BoxDecoration(
                        color: darkThemeBlue,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 0),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            iconEnabledColor: Colors.white70,
                            dropdownColor: darkThemeBlue,

                            /*    value: 'Online Payment',

                            items: <String>['Online Payment'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) async {

                              setState(() {
                                _selectedPaymentType = value;
                                paymentType = value;

                              });
                            },
*/

                            value: _selectedPaymentType,
                            items: _dropdownMenuIPaymentType,
                            onChanged: (value) async {
                              _selectedPaymentType = value;
                              paymentType = value;
                              setState(() {});
                            },
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth * 0.038,
                                color: Colors.white70),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Container(
                    height: 55.0,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 3, left: 15),
                    margin: EdgeInsets.only(left: 4, right: 4),
                    decoration: BoxDecoration(
                      color: darkThemeBlue,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: TextField(
                      onTap: () {
                        DatePicker.showDateTimePicker(context,
                            theme: DatePickerTheme(
                                containerHeight: 250,
                                backgroundColor: darkThemeBlue,
                                itemStyle: TextStyle(color: Colors.white),
                                cancelStyle: TextStyle(
                                    color: Colors.red[900],
                                    fontWeight: FontWeight.w500),
                                doneStyle: TextStyle(
                                    color: Colors.deepOrange,
                                    fontWeight: FontWeight.w500),
                                headerColor: lightThemeBlue,
                                itemHeight: 45.0,
                                titleHeight: 45.0),
                            showTitleActions: true,
                            minTime: DateTime.now(),
                            maxTime: DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day + 14), onChanged: (date) {
                          print('change $date');
                        }, onConfirm: (date) {
                          print('confirm $date');
                          // final String formatted = formatter.format(date);
                          // print(formatted);
                          dateAndTime = DateFormat.yMd().add_Hms().format(date);
                          print('THIS IS THE SELCTED TIME:');
                          print(dateAndTime);
                          dateAndTimeFormated =
                              DateFormat.yMMMd().add_Hms().format(date);
                          _deliveryDateTimeText.text = dateAndTimeFormated;
                          // print(DateFormat.yMMMMd().add_jm().format(date));
                          // print(DateFormat.yMd().add_Hms().format(date));
                          // print(DateFormat().parse(_dateAndTimeText.text, true).hour);
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      textInputAction: TextInputAction.next,
                      controller: _deliveryDateTimeText,
                      readOnly: true,
                      // maxLength: 10,
                      // maxLengthEnforced: true,
                      style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.038,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500),
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.white60,
                              size: 20,
                            ),
                          ),
                          hintText: "Select Pickup Date and Time",
                          hintStyle: GoogleFonts.poppins(
                              color: Colors.white30,
                              fontSize: screenWidth * 0.039,
                              fontWeight: FontWeight.w400),
                          border: InputBorder.none),
                    ),
                  ),

                  //product payment requirement
                  Padding(
                    padding: const EdgeInsets.fromLTRB(7.0, 25.0, 10.0, 15.0),
                    child: Row(
                      children: [
                        Text("Required to Pay Product Amount ?",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: screenWidth * 0.04,
                                color: Colors.white70)),
                        Spacer(),
                        FlutterSwitch(
                          width: 45.0,
                          height: 23.0,
                          valueFontSize: 0.0,
                          toggleSize: 16.0,
                          value: productPaymentRequired ?? false,
                          borderRadius: 30.0,
                          padding: 3.0,
                          showOnOff: true,
                          activeColor: darkThemeBlue,
                          inactiveToggleColor: Color.fromRGBO(78, 121, 151, 1),
                          activeToggleColor: Colors.lightGreen[200],
                          inactiveColor: darkThemeBlue,
                          switchBorder: Border.all(
                            color: Color.fromRGBO(78, 121, 151, 1),
                            width: 1.0,
                          ),
                          onToggle: (val) {
                            setState(() {
                              productPaymentRequired = val;
                              if (!val) {
                                productPaymentUserRadioData.forEach(
                                    (element) => element.isSelected = false);
                                productPaymentUserRadioData[0].isSelected =
                                    true;
                                this.productPaymentUserIndex1 = 0;
                                productPaymentUser =
                                    productPaymentUserRadioData[0].text;
                                productPaymentUserIndex = 0;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  //Item Amount Payable Person
                  Visibility(
                    visible: productPaymentRequired ?? false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /*Padding(
                          padding: EdgeInsets.fromLTRB(5.0, 10.0, 0.0, 12.0),
                          child: Text("Who will pay the product amount?",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: screenWidth * 0.04, color: Colors.white70)),
                        ),
                        Padding(
                          // height: screenHeight*0.7,
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 11.0),
                          child: GridView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: paymentUserType.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 10 / 5,
                            ),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  productPaymentUserRadioData.forEach((element) => element.isSelected = false);
                                  productPaymentUserRadioData[index].isSelected = true;
                                  this.productPaymentUserIndex1 = index;
                                  productPaymentUser = productPaymentUserRadioData[index].text;
                                  productPaymentUserIndex = index;
                                  setState(() {});
                                },
                                child: Card(
                                  color: darkThemeBlue,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
                                  elevation: 5,
                                  shadowColor: darkThemeBlue,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        // margin: EdgeInsets.only(top: 20,bottom: 20),
                                        padding: EdgeInsets.all(3),
                                        height: screenWidth * 0.11,
                                        width: screenWidth * 0.11,
                                        decoration: BoxDecoration(
                                          color: (productPaymentUserRadioData[index].isSelected) ? darkOrangeCol : Colors.white38,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Container(
                                          height: screenWidth * 0.1,
                                          width: screenWidth * 0.1,
                                          clipBehavior: Clip.hardEdge,
                                          padding: EdgeInsets.all(screenWidth * 0.018),
                                          decoration: BoxDecoration(color: darkThemeBlue, shape: BoxShape.circle),
                                          child: Image.asset(
                                            "assets/images/icons/pickup_icons/${paymentUserLogo[index]}",
                                            height: screenWidth * 0.1,
                                            width: screenWidth * 0.1,
                                            fit: BoxFit.contain,
                                          ),
                                          // child: Image.asset("asset/blank-profile-picture-973460_1280.webp")
                                        ),
                                      ),
                                      Text("    ${productPaymentUserType[index]}",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14.0, color: Colors.white70))
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),*/
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 5, left: 6, top: 10),
                          child: Text(
                            "Product Amount",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: screenWidth * 0.037,
                                color: Colors.white70),
                          ),
                        ),
                        Container(
                          height: 50.0,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 3, right: 12),
                          decoration: BoxDecoration(
                            color: darkThemeBlue,
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0)),
                          ),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: _productPrice,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9]")),
                              LengthLimitingTextInputFormatter(5),
                            ],
                            // maxLength: 10,
                            // maxLengthEnforced: true,
                            style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.038,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500),
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Icon(
                                    Icons.add_comment_outlined,
                                    color: lightTextGrey,
                                    size: 19,
                                  ),
                                ),
                                hintText: "Product Amount",
                                hintStyle: GoogleFonts.poppins(
                                  color: lightTextGrey,
                                  fontSize: screenWidth * 0.038,
                                ),
                                border: InputBorder.none),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 25, 0, 20),
                    child: ButtonTheme(
                      /*__To Enlarge Button Size__*/
                      height: 50.0,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        onPressed: () async {
                          if (itscake == true) {
                            extraPersonRequired = true;
                            extraPersonRequired1 = true;
                          }
                          if (_deliveryDateTimeText.text.trim() == "") {
                            Fluttertoast.showToast(
                                msg: "Please Select Delivery Date & Time",
                                fontSize: 14,
                                backgroundColor: Colors.orange[100],
                                textColor: darkThemeBlue,
                                toastLength: Toast.LENGTH_LONG);
                          } else if (productPaymentRequired ?? false) {
                            if (_productPrice.text.trim() == "") {
                              Fluttertoast.showToast(
                                  msg: "Please Enter Product Amount",
                                  fontSize: 14,
                                  backgroundColor: Colors.orange[100],
                                  textColor: darkThemeBlue,
                                  toastLength: Toast.LENGTH_LONG);
                            } else {
                              mapApiCheck = true;
                              productPrice = _productPrice.text.trim();

                              Future.delayed(Duration.zero, () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return WillPopScope(
                                        onWillPop: () async => false,
                                        child: CustomDialog(
                                          backgroundColor: Colors.white60,
                                          clipBehavior: Clip.hardEdge,
                                          insetPadding: EdgeInsets.all(0),
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: SizedBox(
                                              width: 50.0,
                                              height: 50.0,
                                              child: CircularProgressIndicator(
                                                  backgroundColor:
                                                      circularBGCol,
                                                  strokeWidth: strokeWidth,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          circularStrokeCol)),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              });

                              for (int i = 0; i < numberOfReceivers; i++) {
                                DistanceInM = 0;

                                totalDistanceInM += distance(
                                        latlong.LatLng(copydropLatList[i],
                                            copydroplongList[i]),
                                        latlong.LatLng(copydropLatList[i + 1],
                                            copydroplongList[i + 1]))
                                    .toInt();

                                DistanceInM = distance(
                                        latlong.LatLng(copydropLatList[i],
                                            copydroplongList[i]),
                                        latlong.LatLng(copydropLatList[i + 1],
                                            copydroplongList[i + 1]))
                                    .toInt();

                                await pickupDropRepository.mapDistanceCalculate(
                                    copydropLatList[i],
                                    copydroplongList[i],
                                    copydropLatList[i + 1],
                                    copydroplongList[i + 1]);

                                double pricePerKM;
                                bool morningTime = true;
                                double minPrice;
                                double baseKM;

                                double disKM = distanceList[i] / 1000;
                                // double actualDistance = disKM;
                                disKM = double.parse("${disKM.ceil()}");
                                double price = 0;

                                print(disKM);

                                // String hourTime=DateFormat.H().format(DateFormat().parse(_dateAndTimeText.text, true));
                                if (vehicleType == "Two-Wheeler") {
                                  morningTime =
                                      (DateFormat("MM/dd/yyyy HH:mm:ss")
                                                      .parse(dateAndTime.trim())
                                                      .hour >=
                                                  10 &&
                                              DateFormat("MM/dd/yyyy HH:mm:ss")
                                                      .parse(dateAndTime.trim())
                                                      .hour <
                                                  22)
                                          ? true
                                          : false;

                                  // pricePerKM = (DateFormat("MM/dd/yyyy HH:mm:ss").parse(_dateAndTimeText.text.trim()).hour >= 10 &&
                                  //     DateFormat("MM/dd/yyyy HH:mm:ss").parse(_dateAndTimeText.text.trim()).hour < 22)
                                  //     ? 10
                                  //     : 15;
                                  // minPrice = 40;

                                  if (extraPersonRequired1) {
                                    /// for two wheeler extra person

                                    if (extraPersonTwoWheelerRate.isNotEmpty) {
                                      minPrice = double.parse(
                                          extraPersonTwoWheelerRate[0]
                                              .pricePerKm
                                              .toString());
                                      price = double.parse(
                                          extraPersonTwoWheelerRate[0]
                                              .pricePerKm
                                              .toString());
                                      if (disKM >
                                          double.parse(
                                              extraPersonTwoWheelerRate[0]
                                                  .uptoKm
                                                  .toString())) {
                                        for (int i = 1;
                                            i <
                                                extraPersonTwoWheelerRate
                                                    .length;
                                            i++) {
                                          print("$price index : $i");
                                          if (disKM -
                                                  double.parse(
                                                      extraPersonTwoWheelerRate[
                                                              i]
                                                          .uptoKm
                                                          .toString()) >=
                                              0) {
                                            print(
                                                " eta majh er gulo ${double.parse(extraPersonTwoWheelerRate[i].uptoKm.toString())}-${double.parse(extraPersonTwoWheelerRate[i - 1].uptoKm.toString())} * ${double.parse(extraPersonTwoWheelerRate[i].pricePerKm.toString())} index : $i");

                                            price += (double.parse(
                                                        extraPersonTwoWheelerRate[
                                                                i]
                                                            .uptoKm
                                                            .toString()) -
                                                    double.parse(
                                                        extraPersonTwoWheelerRate[
                                                                i - 1]
                                                            .uptoKm
                                                            .toString())) *
                                                double.parse(
                                                    extraPersonTwoWheelerRate[i]
                                                        .pricePerKm
                                                        .toString());
                                          } else if (double.parse(
                                                      extraPersonTwoWheelerRate[
                                                              i]
                                                          .uptoKm
                                                          .toString()) -
                                                  disKM >=
                                              0) {
                                            print(
                                                "eta ekdom last er ta $disKM - ${double.parse(extraPersonTwoWheelerRate[i - 1].uptoKm.toString())} * ${double.parse(extraPersonTwoWheelerRate[i].pricePerKm.toString())} index : $i");
                                            price += (disKM -
                                                    double.parse(
                                                        extraPersonTwoWheelerRate[
                                                                i - 1]
                                                            .uptoKm
                                                            .toString())) *
                                                double.parse(
                                                    extraPersonTwoWheelerRate[i]
                                                        .pricePerKm
                                                        .toString());
                                            break;
                                          }
                                        }
                                        if (disKM -
                                                double.parse(
                                                    extraPersonTwoWheelerRate[
                                                            extraPersonTwoWheelerRate
                                                                    .length -
                                                                1]
                                                        .uptoKm
                                                        .toString()) >
                                            0) {
                                          price += (disKM -
                                                  double.parse(
                                                      extraPersonTwoWheelerRate[
                                                              extraPersonTwoWheelerRate
                                                                      .length -
                                                                  1]
                                                          .uptoKm
                                                          .toString())) *
                                              double.parse(
                                                  extraPersonTwoWheelerRate[
                                                          extraPersonTwoWheelerRate
                                                                  .length -
                                                              1]
                                                      .pricePerKm
                                                      .toString());
                                        }
                                        print(
                                            "extra person price for auto : $price");
                                      }
                                    } else {
                                      print('Entered extra person required');
                                      minPrice = 150;
                                      if (disKM <= 5) {
                                        price = 150;
                                      } else if (disKM > 5) {
                                        price = 150;
                                        price += (disKM - 5.0) * 15;
                                      }
                                    }
                                  } else {
                                    if (morningTime) {
                                      /// for two wheeler morning time

                                      if (twoWheelerMorningRate.isNotEmpty) {
                                        print('not empty');
                                        print(twoWheelerMorningRate[0]
                                            .pricePerKm
                                            .toString());
                                        print(twoWheelerMorningRate[0]
                                            .uptoKm
                                            .toString());

                                        minPrice = double.parse(
                                            twoWheelerMorningRate[0]
                                                .pricePerKm
                                                .toString());
                                        price = double.parse(
                                            twoWheelerMorningRate[0]
                                                .pricePerKm
                                                .toString());

                                        if (disKM >
                                            double.parse(
                                                twoWheelerMorningRate[0]
                                                    .uptoKm
                                                    .toString())) {
                                          for (int i = 1;
                                              i < twoWheelerMorningRate.length;
                                              i++) {
                                            print("$price index : $i");

                                            if (disKM -
                                                    double.parse(
                                                        twoWheelerMorningRate[i]
                                                            .uptoKm
                                                            .toString()) >=
                                                0) {
                                              print(
                                                  " eta majh er gulo ${double.parse(twoWheelerMorningRate[i].uptoKm.toString())}-${double.parse(twoWheelerMorningRate[i - 1].uptoKm.toString())} * ${double.parse(twoWheelerMorningRate[i].pricePerKm.toString())} index : $i");

                                              price += (double.parse(
                                                          twoWheelerMorningRate[
                                                                  i]
                                                              .uptoKm
                                                              .toString()) -
                                                      double.parse(
                                                          twoWheelerMorningRate[
                                                                  i - 1]
                                                              .uptoKm
                                                              .toString())) *
                                                  double.parse(
                                                      twoWheelerMorningRate[i]
                                                          .pricePerKm
                                                          .toString());
                                            } else if (double.parse(
                                                        twoWheelerMorningRate[i]
                                                            .uptoKm
                                                            .toString()) -
                                                    disKM >=
                                                0) {
                                              print(
                                                  "eta ekdom last er ta $disKM - ${double.parse(twoWheelerMorningRate[i - 1].uptoKm.toString())} * ${double.parse(twoWheelerMorningRate[i].pricePerKm.toString())} index : $i");
                                              price += (disKM -
                                                      double.parse(
                                                          twoWheelerMorningRate[
                                                                  i - 1]
                                                              .uptoKm
                                                              .toString())) *
                                                  double.parse(
                                                      twoWheelerMorningRate[i]
                                                          .pricePerKm
                                                          .toString());
                                              break;
                                            }
                                          }
                                          if (disKM -
                                                  double.parse(
                                                      twoWheelerMorningRate[
                                                              twoWheelerMorningRate
                                                                      .length -
                                                                  1]
                                                          .uptoKm
                                                          .toString()) >
                                              0) {
                                            price += (disKM -
                                                    double.parse(
                                                        twoWheelerMorningRate[
                                                                twoWheelerMorningRate
                                                                        .length -
                                                                    1]
                                                            .uptoKm
                                                            .toString())) *
                                                double.parse(
                                                    twoWheelerMorningRate[
                                                            twoWheelerMorningRate
                                                                    .length -
                                                                1]
                                                        .pricePerKm
                                                        .toString());
                                          }
                                          print(
                                              "2W price morning for auto : $price");
                                        }
                                      } else {
                                        print("Entered 2w morning");
                                        minPrice = 40;
                                        if (disKM <= 3) {
                                          price = 40;
                                        } else if (disKM > 3 && disKM <= (10)) {
                                          price = 40;
                                          price += (disKM - 3.0) * 10;
                                        } else if (disKM > (10.0) &&
                                            disKM <= (20.0)) {
                                          price = 40;
                                          price += (10.0 - 3.0) * 10;
                                          price += (disKM - (10.0)) * 15;
                                        } else if (disKM >
                                            (20.0) /*&& disKM<=(5+10+20+30)*/) {
                                          price = 40;
                                          price += (10.0 - 3.0) * 10;
                                          price += (20.0 - 10.0) * 15;
                                          price += (disKM - (20.0)) * 20;
                                        }
                                      }
                                    } else {
                                      /// for two wheeler night time

                                      if (twoWheelerNightRate.isNotEmpty) {
                                        minPrice = double.parse(
                                            twoWheelerNightRate[0]
                                                .pricePerKm
                                                .toString());
                                        price = double.parse(
                                            twoWheelerNightRate[0]
                                                .pricePerKm
                                                .toString());
                                        if (disKM >
                                            double.parse(twoWheelerNightRate[0]
                                                .uptoKm
                                                .toString())) {
                                          for (int i = 1;
                                              i < twoWheelerNightRate.length;
                                              i++) {
                                            print("$price index : $i");
                                            if (disKM -
                                                    double.parse(
                                                        twoWheelerNightRate[i]
                                                            .uptoKm
                                                            .toString()) >=
                                                0) {
                                              print(
                                                  " eta majh er gulo ${double.parse(twoWheelerNightRate[i].uptoKm.toString())}-${double.parse(twoWheelerNightRate[i - 1].uptoKm.toString())} * ${double.parse(twoWheelerNightRate[i].pricePerKm.toString())} index : $i");

                                              price += (double.parse(
                                                          twoWheelerNightRate[i]
                                                              .uptoKm
                                                              .toString()) -
                                                      double.parse(
                                                          twoWheelerNightRate[
                                                                  i - 1]
                                                              .uptoKm
                                                              .toString())) *
                                                  double.parse(
                                                      twoWheelerNightRate[i]
                                                          .pricePerKm
                                                          .toString());
                                            } else if (double.parse(
                                                        twoWheelerNightRate[i]
                                                            .uptoKm
                                                            .toString()) -
                                                    disKM >=
                                                0) {
                                              print(
                                                  "eta ekdom last er ta $disKM - ${double.parse(twoWheelerNightRate[i - 1].uptoKm.toString())} * ${double.parse(twoWheelerNightRate[i].pricePerKm.toString())} index : $i");
                                              price += (disKM -
                                                      double.parse(
                                                          twoWheelerNightRate[
                                                                  i - 1]
                                                              .uptoKm
                                                              .toString())) *
                                                  double.parse(
                                                      twoWheelerNightRate[i]
                                                          .pricePerKm
                                                          .toString());
                                              break;
                                            }
                                          }
                                          if (disKM -
                                                  double.parse(
                                                      twoWheelerNightRate[
                                                              twoWheelerNightRate
                                                                      .length -
                                                                  1]
                                                          .uptoKm
                                                          .toString()) >
                                              0) {
                                            price += (disKM -
                                                    double.parse(
                                                        twoWheelerNightRate[
                                                                twoWheelerNightRate
                                                                        .length -
                                                                    1]
                                                            .uptoKm
                                                            .toString())) *
                                                double.parse(
                                                    twoWheelerNightRate[
                                                            twoWheelerNightRate
                                                                    .length -
                                                                1]
                                                        .pricePerKm
                                                        .toString());
                                          }
                                          print(
                                              "2W price night for auto: $price");
                                        }
                                      } else {
                                        print(
                                            'Entered else for two wheeler night');
                                        minPrice = 60;
                                        if (disKM <= 3) {
                                          price = 60;
                                        } else if (disKM > 3 && disKM <= (10)) {
                                          price = 60;
                                          price += (disKM - 3.0) * 15;
                                        } else if (disKM > (10.0) &&
                                            disKM <= (20.0)) {
                                          price = 60;
                                          price += (10.0 - 3.0) * 15;
                                          price += (disKM - (10.0)) * 20;
                                        } else if (disKM >
                                            (20.0) /*&& disKM<=(5+10+20+30)*/) {
                                          price = 60;
                                          price += (10.0 - 3.0) * 15;
                                          price += (20.0 - 10.0) * 20;
                                          price += (disKM - (20.0)) * 20;
                                        }
                                      }
                                    }
                                  }
                                } else if (vehicleType == "Four-Wheeler") {
                                  /// for four wheeler

                                  if (fourWheelerRate.isNotEmpty) {
                                    minPrice = double.parse(fourWheelerRate[0]
                                        .pricePerKm
                                        .toString());
                                    price = double.parse(fourWheelerRate[0]
                                        .pricePerKm
                                        .toString());
                                    if (disKM >
                                        double.parse(fourWheelerRate[0]
                                            .uptoKm
                                            .toString())) {
                                      for (int i = 1;
                                          i < fourWheelerRate.length;
                                          i++) {
                                        print("$price index : $i");
                                        if (disKM -
                                                double.parse(fourWheelerRate[i]
                                                    .uptoKm
                                                    .toString()) >=
                                            0) {
                                          print(
                                              " eta majh er gulo ${double.parse(fourWheelerRate[i].uptoKm.toString())}-${double.parse(fourWheelerRate[i - 1].uptoKm.toString())} * ${double.parse(fourWheelerRate[i].pricePerKm.toString())} index : $i");

                                          price += (double.parse(
                                                      fourWheelerRate[i]
                                                          .uptoKm
                                                          .toString()) -
                                                  double.parse(
                                                      fourWheelerRate[i - 1]
                                                          .uptoKm
                                                          .toString())) *
                                              double.parse(fourWheelerRate[i]
                                                  .pricePerKm
                                                  .toString());
                                        } else if (double.parse(
                                                    fourWheelerRate[i]
                                                        .uptoKm
                                                        .toString()) -
                                                disKM >=
                                            0) {
                                          print(
                                              "eta ekdom last er ta $disKM - ${double.parse(fourWheelerRate[i - 1].uptoKm.toString())} * ${double.parse(fourWheelerRate[i].pricePerKm.toString())} index : $i");
                                          price += (disKM -
                                                  double.parse(
                                                      fourWheelerRate[i - 1]
                                                          .uptoKm
                                                          .toString())) *
                                              double.parse(fourWheelerRate[i]
                                                  .pricePerKm
                                                  .toString());
                                          break;
                                        }
                                      }
                                      if (disKM -
                                              double.parse(fourWheelerRate[
                                                      fourWheelerRate.length -
                                                          1]
                                                  .uptoKm
                                                  .toString()) >
                                          0) {
                                        price += (disKM -
                                                double.parse(fourWheelerRate[
                                                        fourWheelerRate.length -
                                                            1]
                                                    .uptoKm
                                                    .toString())) *
                                            double.parse(fourWheelerRate[
                                                    fourWheelerRate.length - 1]
                                                .pricePerKm
                                                .toString());
                                      }
                                      print("4W price for auto : $price");
                                    }
                                  } else {
                                    print('Entered else for 4w');
                                    pricePerKM = 20;
                                    minPrice = 300;
                                    if (disKM <= 5.0) {
                                      price = minPrice;
                                    } else {
                                      price = 300 + ((disKM - 5) * pricePerKM);
                                    }
                                  }
                                }

                                print(price);
                                print(disKM);

                                totalpriceList.add(price);
                                print('Prices :');
                                print(totalpriceList[i]);

                                // print("map response");
                                //print(snapshot.data.data.rows[0].elements[0].distance.text);

                                /*
                              Future.delayed(Duration.zero, () {
                              mapApiCheck = false;
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                              return PickDropPage04(
                              deliveryCharge: price,
                              distance: actualDistance,
                              );
                              }));

                              print('THIS IS THE PAYMENT TYPE:');
                              print(paymentType);
                              });

                                 */

                                print(totalDistanceInM);
                              }

                              print('Total distance in m :');
                              print(totalDistanceInM);

                              //_mapDistanceBloc.mapDistanceCal(pickUpLat, pickUpLong, dropLatList[0], droplongList[0]);

                              for (int i = 0; i < numberOfReceivers; i++) {
                                finalPrice = finalPrice + totalpriceList[i];
                                totalDistanceusingGoogle =
                                    totalDistanceusingGoogle + distanceList[i];
                              }

                              double actualDistance =
                                  totalDistanceusingGoogle / 1000;

                              Future.delayed(Duration.zero, () {
                                mapApiCheck = false;
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return PickDropPage04(
                                    deliveryCharge: finalPrice,
                                    distance: actualDistance,
                                  );
                                }));

                                print('THIS IS THE PAYMENT TYPE:');
                                print(paymentType);
                              });
                            }
                          } else {
                            mapApiCheck = true;
                            productPrice = _productPrice.text.trim();

                            /*

                            for(int i =0; i<=numberOfReceivers ; i++)
                              {
                                pickupDropRepository.mapDistanceCalculate(pickUpLat, pickUpLong, dropLatList[i], droplongList[i]);

                                // _mapDistanceBloc.mapDistanceCal(pickUpLat, pickUpLong, dropLatList[i], droplongList[i]);
                              }

                           */
                            Future.delayed(Duration.zero, () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return WillPopScope(
                                      onWillPop: () async => false,
                                      child: CustomDialog(
                                        backgroundColor: Colors.white60,
                                        clipBehavior: Clip.hardEdge,
                                        insetPadding: EdgeInsets.all(0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: SizedBox(
                                            width: 50.0,
                                            height: 50.0,
                                            child: CircularProgressIndicator(
                                                backgroundColor: circularBGCol,
                                                strokeWidth: strokeWidth,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        circularStrokeCol)),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            });

                            for (int i = 0; i < numberOfReceivers; i++) {
                              DistanceInM = 0;

                              totalDistanceInM += distance(
                                      latlong.LatLng(copydropLatList[i],
                                          copydroplongList[i]),
                                      latlong.LatLng(copydropLatList[i + 1],
                                          copydroplongList[i + 1]))
                                  .toInt();

                              DistanceInM = distance(
                                      latlong.LatLng(copydropLatList[i],
                                          copydroplongList[i]),
                                      latlong.LatLng(copydropLatList[i + 1],
                                          copydroplongList[i + 1]))
                                  .toInt();

                              await pickupDropRepository.mapDistanceCalculate(
                                  copydropLatList[i],
                                  copydroplongList[i],
                                  copydropLatList[i + 1],
                                  copydroplongList[i + 1]);

                              double pricePerKM;
                              bool morningTime = true;
                              double minPrice;
                              double baseKM;

                              double disKM = distanceList[i] / 1000;
                              // double actualDistance = disKM;
                              disKM = double.parse("${disKM.ceil()}");
                              double price = 0;

                              print(disKM);

                              // String hourTime=DateFormat.H().format(DateFormat().parse(_dateAndTimeText.text, true));
                              if (vehicleType == "Two-Wheeler") {
                                morningTime = (DateFormat("MM/dd/yyyy HH:mm:ss")
                                                .parse(dateAndTime.trim())
                                                .hour >=
                                            10 &&
                                        DateFormat("MM/dd/yyyy HH:mm:ss")
                                                .parse(dateAndTime.trim())
                                                .hour <
                                            22)
                                    ? true
                                    : false;

                                // pricePerKM = (DateFormat("MM/dd/yyyy HH:mm:ss").parse(_dateAndTimeText.text.trim()).hour >= 10 &&
                                //     DateFormat("MM/dd/yyyy HH:mm:ss").parse(_dateAndTimeText.text.trim()).hour < 22)
                                //     ? 10
                                //     : 15;
                                // minPrice = 40;

                                if (extraPersonRequired1) {
                                  /// for two wheeler extra person

                                  if (extraPersonTwoWheelerRate.isNotEmpty) {
                                    minPrice = double.parse(
                                        extraPersonTwoWheelerRate[0]
                                            .pricePerKm
                                            .toString());
                                    price = double.parse(
                                        extraPersonTwoWheelerRate[0]
                                            .pricePerKm
                                            .toString());
                                    if (disKM >
                                        double.parse(
                                            extraPersonTwoWheelerRate[0]
                                                .uptoKm
                                                .toString())) {
                                      for (int i = 1;
                                          i < extraPersonTwoWheelerRate.length;
                                          i++) {
                                        print("$price index : $i");
                                        if (disKM -
                                                double.parse(
                                                    extraPersonTwoWheelerRate[i]
                                                        .uptoKm
                                                        .toString()) >=
                                            0) {
                                          print(
                                              " eta majh er gulo ${double.parse(extraPersonTwoWheelerRate[i].uptoKm.toString())}-${double.parse(extraPersonTwoWheelerRate[i - 1].uptoKm.toString())} * ${double.parse(extraPersonTwoWheelerRate[i].pricePerKm.toString())} index : $i");

                                          price += (double.parse(
                                                      extraPersonTwoWheelerRate[
                                                              i]
                                                          .uptoKm
                                                          .toString()) -
                                                  double.parse(
                                                      extraPersonTwoWheelerRate[
                                                              i - 1]
                                                          .uptoKm
                                                          .toString())) *
                                              double.parse(
                                                  extraPersonTwoWheelerRate[i]
                                                      .pricePerKm
                                                      .toString());
                                        } else if (double.parse(
                                                    extraPersonTwoWheelerRate[i]
                                                        .uptoKm
                                                        .toString()) -
                                                disKM >=
                                            0) {
                                          print(
                                              "eta ekdom last er ta $disKM - ${double.parse(extraPersonTwoWheelerRate[i - 1].uptoKm.toString())} * ${double.parse(extraPersonTwoWheelerRate[i].pricePerKm.toString())} index : $i");
                                          price += (disKM -
                                                  double.parse(
                                                      extraPersonTwoWheelerRate[
                                                              i - 1]
                                                          .uptoKm
                                                          .toString())) *
                                              double.parse(
                                                  extraPersonTwoWheelerRate[i]
                                                      .pricePerKm
                                                      .toString());
                                          break;
                                        }
                                      }
                                      if (disKM -
                                              double.parse(
                                                  extraPersonTwoWheelerRate[
                                                          extraPersonTwoWheelerRate
                                                                  .length -
                                                              1]
                                                      .uptoKm
                                                      .toString()) >
                                          0) {
                                        price += (disKM -
                                                double.parse(
                                                    extraPersonTwoWheelerRate[
                                                            extraPersonTwoWheelerRate
                                                                    .length -
                                                                1]
                                                        .uptoKm
                                                        .toString())) *
                                            double.parse(
                                                extraPersonTwoWheelerRate[
                                                        extraPersonTwoWheelerRate
                                                                .length -
                                                            1]
                                                    .pricePerKm
                                                    .toString());
                                      }
                                      print(
                                          "extra person price for auto : $price");
                                    }
                                  } else {
                                    print('Entered extra person required');
                                    minPrice = 150;
                                    if (disKM <= 5) {
                                      price = 150;
                                    } else if (disKM > 5) {
                                      price = 150;
                                      price += (disKM - 5.0) * 15;
                                    }
                                  }
                                } else {
                                  if (morningTime) {
                                    /// for two wheeler morning time

                                    if (twoWheelerMorningRate.isNotEmpty) {
                                      print('not empty');
                                      print(twoWheelerMorningRate[0]
                                          .pricePerKm
                                          .toString());
                                      print(twoWheelerMorningRate[0]
                                          .uptoKm
                                          .toString());

                                      minPrice = double.parse(
                                          twoWheelerMorningRate[0]
                                              .pricePerKm
                                              .toString());
                                      price = double.parse(
                                          twoWheelerMorningRate[0]
                                              .pricePerKm
                                              .toString());

                                      if (disKM >
                                          double.parse(twoWheelerMorningRate[0]
                                              .uptoKm
                                              .toString())) {
                                        for (int i = 1;
                                            i < twoWheelerMorningRate.length;
                                            i++) {
                                          print("$price index : $i");

                                          if (disKM -
                                                  double.parse(
                                                      twoWheelerMorningRate[i]
                                                          .uptoKm
                                                          .toString()) >=
                                              0) {
                                            print(
                                                " eta majh er gulo ${double.parse(twoWheelerMorningRate[i].uptoKm.toString())}-${double.parse(twoWheelerMorningRate[i - 1].uptoKm.toString())} * ${double.parse(twoWheelerMorningRate[i].pricePerKm.toString())} index : $i");

                                            price += (double.parse(
                                                        twoWheelerMorningRate[i]
                                                            .uptoKm
                                                            .toString()) -
                                                    double.parse(
                                                        twoWheelerMorningRate[
                                                                i - 1]
                                                            .uptoKm
                                                            .toString())) *
                                                double.parse(
                                                    twoWheelerMorningRate[i]
                                                        .pricePerKm
                                                        .toString());
                                          } else if (double.parse(
                                                      twoWheelerMorningRate[i]
                                                          .uptoKm
                                                          .toString()) -
                                                  disKM >=
                                              0) {
                                            print(
                                                "eta ekdom last er ta $disKM - ${double.parse(twoWheelerMorningRate[i - 1].uptoKm.toString())} * ${double.parse(twoWheelerMorningRate[i].pricePerKm.toString())} index : $i");
                                            price += (disKM -
                                                    double.parse(
                                                        twoWheelerMorningRate[
                                                                i - 1]
                                                            .uptoKm
                                                            .toString())) *
                                                double.parse(
                                                    twoWheelerMorningRate[i]
                                                        .pricePerKm
                                                        .toString());
                                            break;
                                          }
                                        }
                                        if (disKM -
                                                double.parse(
                                                    twoWheelerMorningRate[
                                                            twoWheelerMorningRate
                                                                    .length -
                                                                1]
                                                        .uptoKm
                                                        .toString()) >
                                            0) {
                                          price += (disKM -
                                                  double.parse(
                                                      twoWheelerMorningRate[
                                                              twoWheelerMorningRate
                                                                      .length -
                                                                  1]
                                                          .uptoKm
                                                          .toString())) *
                                              double.parse(
                                                  twoWheelerMorningRate[
                                                          twoWheelerMorningRate
                                                                  .length -
                                                              1]
                                                      .pricePerKm
                                                      .toString());
                                        }
                                        print(
                                            "2W price morning for auto : $price");
                                      }
                                    } else {
                                      print("Entered 2w morning");
                                      minPrice = 40;
                                      if (disKM <= 3) {
                                        price = 40;
                                      } else if (disKM > 3 && disKM <= (10)) {
                                        price = 40;
                                        price += (disKM - 3.0) * 10;
                                      } else if (disKM > (10.0) &&
                                          disKM <= (20.0)) {
                                        price = 40;
                                        price += (10.0 - 3.0) * 10;
                                        price += (disKM - (10.0)) * 15;
                                      } else if (disKM >
                                          (20.0) /*&& disKM<=(5+10+20+30)*/) {
                                        price = 40;
                                        price += (10.0 - 3.0) * 10;
                                        price += (20.0 - 10.0) * 15;
                                        price += (disKM - (20.0)) * 20;
                                      }
                                    }
                                  } else {
                                    /// for two wheeler night time

                                    if (twoWheelerNightRate.isNotEmpty) {
                                      minPrice = double.parse(
                                          twoWheelerNightRate[0]
                                              .pricePerKm
                                              .toString());
                                      price = double.parse(
                                          twoWheelerNightRate[0]
                                              .pricePerKm
                                              .toString());
                                      if (disKM >
                                          double.parse(twoWheelerNightRate[0]
                                              .uptoKm
                                              .toString())) {
                                        for (int i = 1;
                                            i < twoWheelerNightRate.length;
                                            i++) {
                                          print("$price index : $i");
                                          if (disKM -
                                                  double.parse(
                                                      twoWheelerNightRate[i]
                                                          .uptoKm
                                                          .toString()) >=
                                              0) {
                                            print(
                                                " eta majh er gulo ${double.parse(twoWheelerNightRate[i].uptoKm.toString())}-${double.parse(twoWheelerNightRate[i - 1].uptoKm.toString())} * ${double.parse(twoWheelerNightRate[i].pricePerKm.toString())} index : $i");

                                            price += (double.parse(
                                                        twoWheelerNightRate[i]
                                                            .uptoKm
                                                            .toString()) -
                                                    double.parse(
                                                        twoWheelerNightRate[
                                                                i - 1]
                                                            .uptoKm
                                                            .toString())) *
                                                double.parse(
                                                    twoWheelerNightRate[i]
                                                        .pricePerKm
                                                        .toString());
                                          } else if (double.parse(
                                                      twoWheelerNightRate[i]
                                                          .uptoKm
                                                          .toString()) -
                                                  disKM >=
                                              0) {
                                            print(
                                                "eta ekdom last er ta $disKM - ${double.parse(twoWheelerNightRate[i - 1].uptoKm.toString())} * ${double.parse(twoWheelerNightRate[i].pricePerKm.toString())} index : $i");
                                            price += (disKM -
                                                    double.parse(
                                                        twoWheelerNightRate[
                                                                i - 1]
                                                            .uptoKm
                                                            .toString())) *
                                                double.parse(
                                                    twoWheelerNightRate[i]
                                                        .pricePerKm
                                                        .toString());
                                            break;
                                          }
                                        }
                                        if (disKM -
                                                double.parse(
                                                    twoWheelerNightRate[
                                                            twoWheelerNightRate
                                                                    .length -
                                                                1]
                                                        .uptoKm
                                                        .toString()) >
                                            0) {
                                          price += (disKM -
                                                  double.parse(
                                                      twoWheelerNightRate[
                                                              twoWheelerNightRate
                                                                      .length -
                                                                  1]
                                                          .uptoKm
                                                          .toString())) *
                                              double.parse(twoWheelerNightRate[
                                                      twoWheelerNightRate
                                                              .length -
                                                          1]
                                                  .pricePerKm
                                                  .toString());
                                        }
                                        print(
                                            "2W price night for auto: $price");
                                      }
                                    } else {
                                      print(
                                          'Entered else for two wheeler night');
                                      minPrice = 60;
                                      if (disKM <= 3) {
                                        price = 60;
                                      } else if (disKM > 3 && disKM <= (10)) {
                                        price = 60;
                                        price += (disKM - 3.0) * 15;
                                      } else if (disKM > (10.0) &&
                                          disKM <= (20.0)) {
                                        price = 60;
                                        price += (10.0 - 3.0) * 15;
                                        price += (disKM - (10.0)) * 20;
                                      } else if (disKM >
                                          (20.0) /*&& disKM<=(5+10+20+30)*/) {
                                        price = 60;
                                        price += (10.0 - 3.0) * 15;
                                        price += (20.0 - 10.0) * 20;
                                        price += (disKM - (20.0)) * 20;
                                      }
                                    }
                                  }
                                }
                              } else if (vehicleType == "Four-Wheeler") {
                                /// for four wheeler

                                if (fourWheelerRate.isNotEmpty) {
                                  minPrice = double.parse(
                                      fourWheelerRate[0].pricePerKm.toString());
                                  price = double.parse(
                                      fourWheelerRate[0].pricePerKm.toString());
                                  if (disKM >
                                      double.parse(fourWheelerRate[0]
                                          .uptoKm
                                          .toString())) {
                                    for (int i = 1;
                                        i < fourWheelerRate.length;
                                        i++) {
                                      print("$price index : $i");
                                      if (disKM -
                                              double.parse(fourWheelerRate[i]
                                                  .uptoKm
                                                  .toString()) >=
                                          0) {
                                        print(
                                            " eta majh er gulo ${double.parse(fourWheelerRate[i].uptoKm.toString())}-${double.parse(fourWheelerRate[i - 1].uptoKm.toString())} * ${double.parse(fourWheelerRate[i].pricePerKm.toString())} index : $i");

                                        price += (double.parse(
                                                    fourWheelerRate[i]
                                                        .uptoKm
                                                        .toString()) -
                                                double.parse(
                                                    fourWheelerRate[i - 1]
                                                        .uptoKm
                                                        .toString())) *
                                            double.parse(fourWheelerRate[i]
                                                .pricePerKm
                                                .toString());
                                      } else if (double.parse(fourWheelerRate[i]
                                                  .uptoKm
                                                  .toString()) -
                                              disKM >=
                                          0) {
                                        print(
                                            "eta ekdom last er ta $disKM - ${double.parse(fourWheelerRate[i - 1].uptoKm.toString())} * ${double.parse(fourWheelerRate[i].pricePerKm.toString())} index : $i");
                                        price += (disKM -
                                                double.parse(
                                                    fourWheelerRate[i - 1]
                                                        .uptoKm
                                                        .toString())) *
                                            double.parse(fourWheelerRate[i]
                                                .pricePerKm
                                                .toString());
                                        break;
                                      }
                                    }
                                    if (disKM -
                                            double.parse(fourWheelerRate[
                                                    fourWheelerRate.length - 1]
                                                .uptoKm
                                                .toString()) >
                                        0) {
                                      price += (disKM -
                                              double.parse(fourWheelerRate[
                                                      fourWheelerRate.length -
                                                          1]
                                                  .uptoKm
                                                  .toString())) *
                                          double.parse(fourWheelerRate[
                                                  fourWheelerRate.length - 1]
                                              .pricePerKm
                                              .toString());
                                    }
                                    print("4W price for auto : $price");
                                  }
                                } else {
                                  print('Entered else for 4w');
                                  pricePerKM = 20;
                                  minPrice = 300;
                                  if (disKM <= 5.0) {
                                    price = minPrice;
                                  } else {
                                    price = 300 + ((disKM - 5) * pricePerKM);
                                  }
                                }
                              }

                              print(price);
                              print(disKM);

                              totalpriceList.add(price);
                              print('Prices :');
                              print(totalpriceList[i]);

                              // print("map response");
                              //print(snapshot.data.data.rows[0].elements[0].distance.text);

                              /*
                              Future.delayed(Duration.zero, () {
                              mapApiCheck = false;
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                              return PickDropPage04(
                              deliveryCharge: price,
                              distance: actualDistance,
                              );
                              }));

                              print('THIS IS THE PAYMENT TYPE:');
                              print(paymentType);
                              });

                                 */

                              print(totalDistanceInM);
                            }

                            print('Total distance in m :');
                            print(totalDistanceInM);

                            //_mapDistanceBloc.mapDistanceCal(pickUpLat, pickUpLong, dropLatList[0], droplongList[0]);

                            for (int i = 0; i < numberOfReceivers; i++) {
                              finalPrice = finalPrice + totalpriceList[i];
                              totalDistanceusingGoogle =
                                  totalDistanceusingGoogle + distanceList[i];
                            }

                            double actualDistance =
                                totalDistanceusingGoogle / 1000;

                            Future.delayed(Duration.zero, () {
                              mapApiCheck = false;
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return PickDropPage04(
                                  deliveryCharge: finalPrice,
                                  distance: actualDistance,
                                );
                              }));

                              print('THIS IS THE PAYMENT TYPE:');
                              print(paymentType);
                            });
                          }
                        },
                        color: orangeCol,
                        textColor: Colors.white,
                        child: Text("Request Pickup",
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.w500)),

                        /*
                        StreamBuilder<ApiResponse<MapDistanceModel>>(
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
                                        Navigator.pop(context);
                                      } else {
                                        double pricePerKM;
                                        bool morningTime = true;
                                        double minPrice;
                                        double baseKM;


                                        /*
                                        for(int i =0; i<dropLatList.length ; i++)
                                        {

                                        distanceList.add(snapshot.data.data.rows[i].elements[i].distance.value);

                                        }

                                         */

                                      //  distanceList.add(snapshot.data.data.rows[0].elements[0].distance.value);
                                     //   distanceList.add(snapshot.data.data.rows[1].elements[1].distance.value);



                                        /*
                                        int distance = snapshot.data.data.rows[0].elements[0].distance.value;
                                        double disKM = distance / 1000;
                                        double actualDistance = disKM;
                                        disKM = double.parse("${disKM.ceil()}");
                                        double price = 0;

                                         */



                                        /*
                                        int distance = snapshot.data.data.rows[0].elements[0].distance.value;
                                        double disKM = distance / 1000;

                                         */



                                        double disKM = totalDistanceInM / 1000;
                                        double actualDistance = disKM;
                                        disKM = double.parse("${disKM.ceil()}");
                                        double price = 0;

                                        print(disKM);





                                        // String hourTime=DateFormat.H().format(DateFormat().parse(_dateAndTimeText.text, true));
                                        if (vehicleType == "Two-Wheeler") {
                                          morningTime = (DateFormat("MM/dd/yyyy HH:mm:ss").parse(dateAndTime.trim()).hour >= 10 &&
                                                  DateFormat("MM/dd/yyyy HH:mm:ss").parse(dateAndTime.trim()).hour < 22)
                                              ? true
                                              : false;

                                          // pricePerKM = (DateFormat("MM/dd/yyyy HH:mm:ss").parse(_dateAndTimeText.text.trim()).hour >= 10 &&
                                          //     DateFormat("MM/dd/yyyy HH:mm:ss").parse(_dateAndTimeText.text.trim()).hour < 22)
                                          //     ? 10
                                          //     : 15;
                                          // minPrice = 40;

                                          if (extraPersonRequired1) {
                                            /// for two wheeler extra person

                                            if (extraPersonTwoWheelerRate.isNotEmpty) {
                                              minPrice = double.parse(extraPersonTwoWheelerRate[0].pricePerKm.toString());
                                              price = double.parse(extraPersonTwoWheelerRate[0].pricePerKm.toString());
                                              if (disKM > double.parse(extraPersonTwoWheelerRate[0].uptoKm.toString())) {
                                                for (int i = 1; i < extraPersonTwoWheelerRate.length; i++) {
                                                  print("$price index : $i");
                                                  if (disKM - double.parse(extraPersonTwoWheelerRate[i].uptoKm.toString()) >= 0) {
                                                    print(
                                                        " eta majh er gulo ${double.parse(extraPersonTwoWheelerRate[i].uptoKm.toString())}-${double.parse(extraPersonTwoWheelerRate[i - 1].uptoKm.toString())} * ${double.parse(extraPersonTwoWheelerRate[i].pricePerKm.toString())} index : $i");

                                                    price += (double.parse(extraPersonTwoWheelerRate[i].uptoKm.toString()) -
                                                            double.parse(extraPersonTwoWheelerRate[i - 1].uptoKm.toString())) *
                                                        double.parse(extraPersonTwoWheelerRate[i].pricePerKm.toString());
                                                  } else if (double.parse(extraPersonTwoWheelerRate[i].uptoKm.toString()) - disKM >= 0) {
                                                    print(
                                                        "eta ekdom last er ta $disKM - ${double.parse(extraPersonTwoWheelerRate[i - 1].uptoKm.toString())} * ${double.parse(extraPersonTwoWheelerRate[i].pricePerKm.toString())} index : $i");
                                                    price += (disKM - double.parse(extraPersonTwoWheelerRate[i - 1].uptoKm.toString())) *
                                                        double.parse(extraPersonTwoWheelerRate[i].pricePerKm.toString());
                                                    break;
                                                  }
                                                }
                                                if (disKM -
                                                        double.parse(extraPersonTwoWheelerRate[extraPersonTwoWheelerRate.length - 1]
                                                            .uptoKm
                                                            .toString()) >
                                                    0) {
                                                  price += (disKM -
                                                          double.parse(extraPersonTwoWheelerRate[extraPersonTwoWheelerRate.length - 1]
                                                              .uptoKm
                                                              .toString())) *
                                                      double.parse(extraPersonTwoWheelerRate[extraPersonTwoWheelerRate.length - 1]
                                                          .pricePerKm
                                                          .toString());
                                                }
                                                print("extra person price for auto : $price");
                                              }
                                            } else {
                                              print('Entered extra person required');
                                              minPrice = 150;
                                              if (disKM <= 5) {
                                                price = 150;
                                              } else if (disKM > 5) {
                                                price = 150;
                                                price += (disKM - 5.0) * 15;
                                              }
                                            }
                                          } else {
                                            if (morningTime) {
                                              /// for two wheeler morning time

                                              if (twoWheelerMorningRate.isNotEmpty) {

                                                minPrice = double.parse(twoWheelerMorningRate[0].pricePerKm.toString());
                                                price = double.parse(twoWheelerMorningRate[0].pricePerKm.toString());

                                                if (disKM > double.parse(twoWheelerMorningRate[0].uptoKm.toString())) {

                                                  for (int i = 1; i < twoWheelerMorningRate.length; i++) {
                                                    print("$price index : $i");

                                                    if (disKM - double.parse(twoWheelerMorningRate[i].uptoKm.toString()) >= 0) {
                                                      print(
                                                          " eta majh er gulo ${double.parse(twoWheelerMorningRate[i].uptoKm.toString())}-${double.parse(twoWheelerMorningRate[i - 1].uptoKm.toString())} * ${double.parse(twoWheelerMorningRate[i].pricePerKm.toString())} index : $i");

                                                      price += (double.parse(twoWheelerMorningRate[i].uptoKm.toString()) -
                                                              double.parse(twoWheelerMorningRate[i - 1].uptoKm.toString())) *
                                                          double.parse(twoWheelerMorningRate[i].pricePerKm.toString());
                                                    } else if (double.parse(twoWheelerMorningRate[i].uptoKm.toString()) - disKM >= 0) {
                                                      print(
                                                          "eta ekdom last er ta $disKM - ${double.parse(twoWheelerMorningRate[i - 1].uptoKm.toString())} * ${double.parse(twoWheelerMorningRate[i].pricePerKm.toString())} index : $i");
                                                      price += (disKM - double.parse(twoWheelerMorningRate[i - 1].uptoKm.toString())) *
                                                          double.parse(twoWheelerMorningRate[i].pricePerKm.toString());
                                                      break;
                                                    }
                                                  }
                                                  if (disKM -
                                                          double.parse(
                                                              twoWheelerMorningRate[twoWheelerMorningRate.length - 1].uptoKm.toString()) >
                                                      0) {
                                                    price += (disKM -
                                                            double.parse(twoWheelerMorningRate[twoWheelerMorningRate.length - 1]
                                                                .uptoKm
                                                                .toString())) *
                                                        double.parse(
                                                            twoWheelerMorningRate[twoWheelerMorningRate.length - 1].pricePerKm.toString());
                                                  }
                                                  print("2W price morning for auto : $price");
                                                }
                                              } else {
                                                print("Entered 2w morning");
                                                minPrice = 40;
                                                if (disKM <= 3) {
                                                  price = 40;
                                                } else if (disKM > 3 && disKM <= (10)) {
                                                  price = 40;
                                                  price += (disKM - 3.0) * 10;
                                                } else if (disKM > (10.0) && disKM <= (20.0)) {
                                                  price = 40;
                                                  price += (10.0 - 3.0) * 10;
                                                  price += (disKM - (10.0)) * 15;
                                                } else if (disKM > (20.0) /*&& disKM<=(5+10+20+30)*/) {
                                                  price = 40;
                                                  price += (10.0 - 3.0) * 10;
                                                  price += (20.0 - 10.0) * 15;
                                                  price += (disKM - (20.0)) * 20;
                                                }
                                              }
                                            } else {
                                              /// for two wheeler night time

                                              if (twoWheelerNightRate.isNotEmpty) {
                                                minPrice = double.parse(twoWheelerNightRate[0].pricePerKm.toString());
                                                price = double.parse(twoWheelerNightRate[0].pricePerKm.toString());
                                                if (disKM > double.parse(twoWheelerNightRate[0].uptoKm.toString())) {
                                                  for (int i = 1; i < twoWheelerNightRate.length; i++) {
                                                    print("$price index : $i");
                                                    if (disKM - double.parse(twoWheelerNightRate[i].uptoKm.toString()) >= 0) {
                                                      print(
                                                          " eta majh er gulo ${double.parse(twoWheelerNightRate[i].uptoKm.toString())}-${double.parse(twoWheelerNightRate[i - 1].uptoKm.toString())} * ${double.parse(twoWheelerNightRate[i].pricePerKm.toString())} index : $i");

                                                      price += (double.parse(twoWheelerNightRate[i].uptoKm.toString()) -
                                                              double.parse(twoWheelerNightRate[i - 1].uptoKm.toString())) *
                                                          double.parse(twoWheelerNightRate[i].pricePerKm.toString());
                                                    } else if (double.parse(twoWheelerNightRate[i].uptoKm.toString()) - disKM >= 0) {
                                                      print(
                                                          "eta ekdom last er ta $disKM - ${double.parse(twoWheelerNightRate[i - 1].uptoKm.toString())} * ${double.parse(twoWheelerNightRate[i].pricePerKm.toString())} index : $i");
                                                      price += (disKM - double.parse(twoWheelerNightRate[i - 1].uptoKm.toString())) *
                                                          double.parse(twoWheelerNightRate[i].pricePerKm.toString());
                                                      break;
                                                    }
                                                  }
                                                  if (disKM -
                                                          double.parse(
                                                              twoWheelerNightRate[twoWheelerNightRate.length - 1].uptoKm.toString()) >
                                                      0) {
                                                    price += (disKM -
                                                            double.parse(
                                                                twoWheelerNightRate[twoWheelerNightRate.length - 1].uptoKm.toString())) *
                                                        double.parse(
                                                            twoWheelerNightRate[twoWheelerNightRate.length - 1].pricePerKm.toString());
                                                  }
                                                  print("2W price night for auto: $price");
                                                }
                                              } else {
                                                print('Entered else for two wheeler night');
                                                minPrice = 60;
                                                if (disKM <= 3) {
                                                  price = 60;
                                                } else if (disKM > 3 && disKM <= (10)) {
                                                  price = 60;
                                                  price += (disKM - 3.0) * 15;
                                                } else if (disKM > (10.0) && disKM <= (20.0)) {
                                                  price = 60;
                                                  price += (10.0 - 3.0) * 15;
                                                  price += (disKM - (10.0)) * 20;
                                                } else if (disKM > (20.0) /*&& disKM<=(5+10+20+30)*/) {
                                                  price = 60;
                                                  price += (10.0 - 3.0) * 15;
                                                  price += (20.0 - 10.0) * 20;
                                                  price += (disKM - (20.0)) * 20;
                                                }
                                              }
                                            }
                                          }
                                        } else if (vehicleType == "Four-Wheeler") {
                                          /// for four wheeler

                                          if (fourWheelerRate.isNotEmpty) {
                                            minPrice = double.parse(fourWheelerRate[0].pricePerKm.toString());
                                            price = double.parse(fourWheelerRate[0].pricePerKm.toString());
                                            if (disKM > double.parse(fourWheelerRate[0].uptoKm.toString())) {
                                              for (int i = 1; i < fourWheelerRate.length; i++) {
                                                print("$price index : $i");
                                                if (disKM - double.parse(fourWheelerRate[i].uptoKm.toString()) >= 0) {
                                                  print(
                                                      " eta majh er gulo ${double.parse(fourWheelerRate[i].uptoKm.toString())}-${double.parse(fourWheelerRate[i - 1].uptoKm.toString())} * ${double.parse(fourWheelerRate[i].pricePerKm.toString())} index : $i");

                                                  price += (double.parse(fourWheelerRate[i].uptoKm.toString()) -
                                                          double.parse(fourWheelerRate[i - 1].uptoKm.toString())) *
                                                      double.parse(fourWheelerRate[i].pricePerKm.toString());
                                                } else if (double.parse(fourWheelerRate[i].uptoKm.toString()) - disKM >= 0) {
                                                  print(
                                                      "eta ekdom last er ta $disKM - ${double.parse(fourWheelerRate[i - 1].uptoKm.toString())} * ${double.parse(fourWheelerRate[i].pricePerKm.toString())} index : $i");
                                                  price += (disKM - double.parse(fourWheelerRate[i - 1].uptoKm.toString())) *
                                                      double.parse(fourWheelerRate[i].pricePerKm.toString());
                                                  break;
                                                }
                                              }
                                              if (disKM - double.parse(fourWheelerRate[fourWheelerRate.length - 1].uptoKm.toString()) > 0) {
                                                price +=
                                                    (disKM - double.parse(fourWheelerRate[fourWheelerRate.length - 1].uptoKm.toString())) *
                                                        double.parse(fourWheelerRate[fourWheelerRate.length - 1].pricePerKm.toString());
                                              }
                                              print("4W price for auto : $price");
                                            }
                                          } else {
                                            print('Entered else for 4w');
                                            pricePerKM = 20;
                                            minPrice = 300;
                                            if (disKM <= 5.0) {
                                              price = minPrice;
                                            } else {
                                              price = 300 + ((disKM - 5) * pricePerKM);
                                            }
                                          }
                                        }

                                        print(price);
                                        print(disKM);

                                        print("map response");
                                        print(snapshot.data.data.rows[0].elements[0].distance.text);
                                        Future.delayed(Duration.zero, () {
                                          mapApiCheck = false;
                                          Navigator.pop(context);
                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                            return PickDropPage04(
                                              deliveryCharge: price,
                                              distance: actualDistance,
                                            );
                                          }));

                                          print('THIS IS THE PAYMENT TYPE:');
                                          print(paymentType);
                                        });
                                      }
                                    }
                                    break;
                                  case Status.ERROR:
                                    mapApiCheck = false;
                                    Navigator.pop(context);

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
                                Navigator.pop(context);
                                print("error");
                              }
                            }
                            return Text("Request Pickup", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500));
                          },
                        ),


                            */

                        // },
                        // ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Center(
                  child: Text(
                "Please Check Your Connectivity",
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.045,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ));
            } else {
              return Center(
                child: CircularProgressIndicator(
                    backgroundColor: circularBGCol,
                    strokeWidth: strokeWidth,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(circularStrokeCol)),
              );
            }
          }),
    ));
  }
}

class RadioModel {
  bool isSelected;
  final String text;

  RadioModel(this.isSelected, this.text);
}
