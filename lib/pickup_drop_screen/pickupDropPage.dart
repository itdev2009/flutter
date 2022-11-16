// import 'package:delivery_on_time/constants.dart';
// import 'package:delivery_on_time/customAlertDialog.dart';
// import 'package:delivery_on_time/help/api_response.dart';
// import 'package:delivery_on_time/pickup_drop_screen/bloc/mapDistanceBloc.dart';
// import 'package:delivery_on_time/pickup_drop_screen/bloc/pickupDropBloc.dart';
// import 'package:delivery_on_time/pickup_drop_screen/mapAddressPicker.dart';
// import 'package:delivery_on_time/pickup_drop_screen/model/mapDistanceModel.dart';
// import 'package:delivery_on_time/pickup_drop_screen/model/pickupDropModel.dart';
// import 'package:delivery_on_time/pickup_drop_screen/pickupOrderDetails_page.dart';
// import 'package:delivery_on_time/screens/home.dart';
// import 'package:delivery_on_time/utility/Error.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geocoder/geocoder.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/intl.dart';
//
// class PickupDropPageEntry extends StatefulWidget {
//   @override
//   _PickupDropPageEntryState createState() => _PickupDropPageEntryState();
// }
//
// class _PickupDropPageEntryState extends State<PickupDropPageEntry> {
//   @override
//   Widget build(BuildContext context) {
//     pickupAddress = userAddress;
//     destinationAddress = "";
//     pickUpLat = userLat;
//     pickUpLong = userLong;
//     dropLat = 0;
//     droplong = 0;
//     sName = userName;
//     sPhone = userPhone;
//     rName = "";
//     rPhone = "";
//     productName = "";
//     productWeight = "";
//     vehicleType = "TWO WHEELER (Max 20km)";
//     productType = "CAKE";
//     productNameVisibility1=false;
//     print(sName);
//     return PickupAndDropPage();
//   }
// }
//
// class PickupAndDropPage extends StatefulWidget {
//   @override
//   _PickupAndDropPageState createState() => _PickupAndDropPageState();
// }
//
// class _PickupAndDropPageState extends State<PickupAndDropPage> {
//   TextEditingController _senderNameText = new TextEditingController();
//   TextEditingController _senderPhoneNumberText = new TextEditingController();
//   TextEditingController _receiverNameText = new TextEditingController();
//   TextEditingController _receiverPhoneNumberText = new TextEditingController();
//   TextEditingController _productNameText = new TextEditingController();
//   TextEditingController _productWeightText = new TextEditingController();
//   TextEditingController _productPriceText = new TextEditingController();
//   TextEditingController _startingPointText = new TextEditingController();
//   TextEditingController _destinationText = new TextEditingController();
//   TextEditingController _dateAndTimeText = new TextEditingController();
//
//   String _address = "";
//
//   PickupDropBloc _pickupDropBloc;
//   MapDistanceBloc _mapDistanceBloc;
//
//   SharedPreferences prefs;
//   String senderName;
//   String senderPhone;
//   String senderToken = "";
//   DateTime dateData;
//
//   // String vehicleType1;
//   // String productType1;
//
//   // bool streamCheck = false;
//   // bool streamCheckSetState = true;
//
//   Future<void> createSharedPref() async {
//     prefs = await SharedPreferences.getInstance();
//     senderName = prefs.getString("name");
//     senderPhone = prefs.getString("user_phone");
//     senderToken = prefs.getString("user_token");
//   }
//
//   List<String> _dropdownItemsType = [
//     "TWO WHEELER (Max 20km)",
//     "FOUR WHEELER (Max 50km)",
//   ];
//   List<String> _dropdownProductType = [
//     "CAKE",
//     "GROCERY",
//     "RESTAURANT",
//     "OTHER",
//   ];
//
//   List<DropdownMenuItem<String>> _dropdownMenuItemsType;
//   List<DropdownMenuItem<String>> _dropdownMenuProductType;
//   String _selectedItemType;
//   String _selectedProductType;
//   bool productNameVisibility = productNameVisibility1;
//
//   @override
//   void initState() {
//     super.initState();
//     createSharedPref();
//     _pickupDropBloc = new PickupDropBloc();
//     _mapDistanceBloc = new MapDistanceBloc();
//     _startingPointText.text = pickupAddress;
//     _destinationText.text = destinationAddress;
//     _senderNameText.text = sName;
//     _senderPhoneNumberText.text = sPhone;
//     _receiverNameText.text = rName;
//     _receiverPhoneNumberText.text = rPhone;
//     _productNameText.text = productName;
//     _productWeightText.text = productWeight;
//     _productPriceText.text = productPrice;
//     _dateAndTimeText.text = dateAndTime;
//
//     // vehicleType1=vehicleType;
//     // productType1=productType;
//     _selectedItemType = vehicleType;
//     _selectedProductType = productType;
//
//     _dropdownMenuItemsType = buildDropDownMenuItems(_dropdownItemsType);
//     _dropdownMenuProductType = buildDropDownMenuItems(_dropdownProductType);
//     // _selectedItemType = _dropdownMenuItemsType[0].value;
//     // _selectedProductType = _dropdownMenuProductType[0].value;
//   }
//
//   List<DropdownMenuItem<String>> buildDropDownMenuItems(List listItems) {
//     List<DropdownMenuItem<String>> items = List();
//     for (String listItem in listItems) {
//       items.add(
//         DropdownMenuItem(
//           child: Text(listItem),
//           value: listItem,
//         ),
//       );
//     }
//     return items;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//             backgroundColor: lightThemeBlue,
//             leading: IconButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 icon: Icon(
//                   Icons.arrow_back,
//                   color: Colors.white,
//                   size: 0,
//                 )),
//             title: Center(
//                 child: Text(
//               "Pickup and Drop",
//               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.045),
//             )),
//             actions: <Widget>[
//               IconButton(
//                 icon: Icon(
//                   Icons.notifications,
//                   color: Colors.white,
//                   size: 0,
//                 ),
//               ),
//             ]),
//         backgroundColor: darkThemeBlue,
//         body: Column(
//           children: [
//             Container(
//               // margin: EdgeInsets.only(top: 40.0),
//               color: orangeCol,
//               height: 35,
//               child: Center(
//                 child: Text(
//                   "Please Fill up Pickup Details",
//                   style: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: font_bold),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 15.0,
//             ),
//             Expanded(
//               child: ListView(
//                 physics: ScrollPhysics(),
//                 shrinkWrap: true,
//                 children: [
//                   Container(
//                     height: 75.0,
//                     alignment: Alignment.topCenter,
//                     margin: EdgeInsets.fromLTRB(15, 25, 15, 15),
//                     padding: EdgeInsets.all(10.0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                     ),
//                     child: Column(
//                       children: [
//                         Expanded(
//                           flex: 1,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                   flex: 1,
//                                   child: Icon(
//                                     Icons.person_outline,
//                                     color: Colors.deepOrange,
//                                   )),
//                               Expanded(
//                                 flex: 7,
//                                 child: Text(
//                                   "Sender Name",
//                                   style: TextStyle(color: Colors.deepOrange, fontSize: 16.0, fontWeight: font_bold),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           flex: 1,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 flex: 1,
//                                 child: Container(),
//                               ),
//                               Expanded(
//                                 flex: 7,
//                                 child: TextField(
//                                   textInputAction: TextInputAction.next,
//                                   controller: _senderNameText,
//                                   style: TextStyle(fontSize: 15.0),
//                                   textAlignVertical: TextAlignVertical.top,
//                                   decoration: InputDecoration(
//                                       // prefixIcon: Icon(Icons.lock_outline),
//                                       hintText: "Sender Full Name *",
//                                       hintStyle: TextStyle(color: Colors.black54, fontSize: 14.0, fontWeight: FontWeight.w300),
//                                       border: InputBorder.none),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     height: 85.0,
//                     alignment: Alignment.topCenter,
//                     margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
//                     padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                     ),
//                     child: Column(
//                       children: [
//                         Expanded(
//                           flex: 1,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                   flex: 1,
//                                   child: Icon(
//                                     Icons.phone_forwarded,
//                                     color: Colors.deepOrange,
//                                     size: 19.0,
//                                   )),
//                               Expanded(
//                                 flex: 7,
//                                 child: Text(
//                                   "Sender Phone Number",
//                                   style: TextStyle(fontSize: 16.0, color: Colors.deepOrange, fontWeight: font_bold),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 flex: 1,
//                                 child: Container(),
//                               ),
//                               Expanded(
//                                 flex: 7,
//                                 child: TextField(
//                                   textInputAction: TextInputAction.next,
//                                   maxLength: 10,
//                                   controller: _senderPhoneNumberText,
//                                   style: TextStyle(fontSize: 15.0),
//                                   textAlignVertical: TextAlignVertical.top,
//                                   keyboardType: TextInputType.number,
//                                   decoration: InputDecoration(
//                                       // prefixIcon: Icon(Icons.lock_outline),
//                                       hintText: "Sender Phone Number *",
//                                       hintStyle: TextStyle(color: Colors.black54, fontSize: 14.0, fontWeight: FontWeight.w300),
//                                       border: InputBorder.none),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     height: 75.0,
//                     alignment: Alignment.topCenter,
//                     margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
//                     padding: EdgeInsets.all(10.0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                     ),
//                     child: Column(
//                       children: [
//                         Expanded(
//                           flex: 1,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                   flex: 1,
//                                   child: Icon(
//                                     Icons.person_pin,
//                                     color: Colors.deepOrange,
//                                   )),
//                               Expanded(
//                                 flex: 7,
//                                 child: Text(
//                                   "Receiver Name",
//                                   style: TextStyle(color: Colors.deepOrange, fontSize: 16.0, fontWeight: font_bold),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           flex: 1,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 flex: 1,
//                                 child: Container(),
//                               ),
//                               Expanded(
//                                 flex: 7,
//                                 child: TextField(
//                                   textInputAction: TextInputAction.next,
//                                   controller: _receiverNameText,
//                                   style: TextStyle(fontSize: 15.0),
//                                   textAlignVertical: TextAlignVertical.top,
//                                   decoration: InputDecoration(
//                                       // prefixIcon: Icon(Icons.lock_outline),
//                                       hintText: "Receiver Full Name *",
//                                       hintStyle: TextStyle(color: Colors.black54, fontSize: 14.0, fontWeight: FontWeight.w300),
//                                       border: InputBorder.none),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     height: 85.0,
//                     alignment: Alignment.topCenter,
//                     margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
//                     padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                     ),
//                     child: Column(
//                       children: [
//                         Expanded(
//                           flex: 1,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                   flex: 1,
//                                   child: Icon(
//                                     Icons.phone_callback_rounded,
//                                     color: Colors.deepOrange,
//                                     size: 19.0,
//                                   )),
//                               Expanded(
//                                 flex: 7,
//                                 child: Text(
//                                   "Receiver Phone Number",
//                                   style: TextStyle(fontSize: 16.0, color: Colors.deepOrange, fontWeight: font_bold),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 flex: 1,
//                                 child: Container(),
//                               ),
//                               Expanded(
//                                 flex: 7,
//                                 child: TextField(
//                                   textInputAction: TextInputAction.next,
//                                   maxLength: 10,
//                                   controller: _receiverPhoneNumberText,
//                                   style: TextStyle(fontSize: 15.0),
//                                   textAlignVertical: TextAlignVertical.top,
//                                   keyboardType: TextInputType.number,
//                                   decoration: InputDecoration(
//                                       // prefixIcon: Icon(Icons.lock_outline),
//                                       hintText: "Receiver Phone Number *",
//                                       hintStyle: TextStyle(color: Colors.black54, fontSize: 14.0, fontWeight: FontWeight.w300),
//                                       border: InputBorder.none),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     height: 75.0,
//                     alignment: Alignment.topCenter,
//                     margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
//                     padding: EdgeInsets.all(10.0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                     ),
//                     child: Column(
//                       children: [
//                         Expanded(
//                           flex: 1,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                   flex: 1,
//                                   child: Icon(
//                                     Icons.shopping_cart_outlined,
//                                     color: Colors.deepOrange,
//                                     size: 20.0,
//                                   )),
//                               Expanded(
//                                 flex: 7,
//                                 child: Text(
//                                   "Product Types",
//                                   style: TextStyle(fontSize: 16.0, color: Colors.deepOrange, fontWeight: font_bold),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           flex: 1,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 flex: 1,
//                                 child: Container(),
//                               ),
//                               Expanded(
//                                 flex: 7,
//                                 child: DropdownButtonHideUnderline(
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(right: 15),
//                                     child: DropdownButton(
//                                       dropdownColor: Colors.white,
//                                       value: _selectedProductType,
//                                       items: _dropdownMenuProductType,
//                                       onChanged: (value) async {
//                                         _selectedProductType = value;
//                                         if (_selectedProductType == "OTHER") {
//                                           productNameVisibility = true;
//                                         } else {
//                                           productNameVisibility = false;
//                                         }
//                                         print(value);
//                                         print(_selectedProductType);
//                                         setState(() {});
//                                       },
//                                       style: new TextStyle(
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Visibility(
//                     visible: productNameVisibility,
//                     child: Container(
//                       height: 75.0,
//                       alignment: Alignment.topCenter,
//                       margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
//                       padding: EdgeInsets.all(10.0),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                       ),
//                       child: Column(
//                         children: [
//                           Expanded(
//                             flex: 1,
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                     flex: 1,
//                                     child: Image.asset(
//                                       "assets/images/icons/laptop.png",
//                                       height: 15.0,
//                                     )),
//                                 Expanded(
//                                   flex: 7,
//                                   child: Text(
//                                     "Product Name",
//                                     style: TextStyle(fontSize: 16.0, color: Colors.deepOrange, fontWeight: font_bold),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   flex: 1,
//                                   child: Container(),
//                                 ),
//                                 Expanded(
//                                   flex: 7,
//                                   child: TextField(
//                                     textInputAction: TextInputAction.next,
//                                     controller: _productNameText,
//                                     style: TextStyle(fontSize: 15.0),
//                                     textAlignVertical: TextAlignVertical.top,
//                                     decoration: InputDecoration(
//                                         // prefixIcon: Icon(Icons.lock_outline),
//                                         hintText: "Ex: Laptop *",
//                                         hintStyle: TextStyle(color: Colors.black54, fontSize: 14.0, fontWeight: FontWeight.w300),
//                                         border: InputBorder.none),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Container(
//                     height: 75.0,
//                     alignment: Alignment.topCenter,
//                     margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
//                     padding: EdgeInsets.all(10.0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                     ),
//                     child: Column(
//                       children: [
//                         Expanded(
//                           flex: 1,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                   flex: 1,
//                                   child: Icon(
//                                     Icons.attach_money_rounded,
//                                     color: Colors.deepOrange,
//                                     size: 20.0,
//                                   )),
//                               Expanded(
//                                 flex: 7,
//                                 child: Text(
//                                   "Product Price",
//                                   style: TextStyle(fontSize: 16.0, color: Colors.deepOrange, fontWeight: font_bold),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           flex: 1,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 flex: 1,
//                                 child: Container(),
//                               ),
//                               Expanded(
//                                 flex: 7,
//                                 child: TextField(
//                                   textInputAction: TextInputAction.next,
//                                   controller: _productPriceText,
//                                   style: TextStyle(fontSize: 15.0),
//                                   keyboardType: TextInputType.numberWithOptions(decimal: true),
//                                   textAlignVertical: TextAlignVertical.top,
//                                   decoration: InputDecoration(
//                                       // prefixIcon: Icon(Icons.lock_outline),
//                                       hintText: "Ex: 250/-",
//                                       hintStyle: TextStyle(color: Colors.black54, fontSize: 14.0, fontWeight: FontWeight.w300),
//                                       border: InputBorder.none),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     height: 80.0,
//                     alignment: Alignment.topCenter,
//                     margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
//                     padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                     ),
//                     child: Column(
//                       children: [
//                         Expanded(
//                           flex: 3,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                   flex: 1,
//                                   child: Image.asset(
//                                     "assets/images/icons/address.png",
//                                     height: 19.0,
//                                   )),
//                               Expanded(
//                                 flex: 6,
//                                 child: Text(
//                                   "Pickup Point",
//                                   style: TextStyle(fontSize: 16.0, color: Colors.deepOrange, fontWeight: font_bold),
//                                 ),
//                               ),
//                               /*Expanded(
//                                 flex: 1,
//                                 child: InkWell(
//                                   onTap: () {
//                                     _getLocation();
//                                     // _startingPointText.text = _address;
//                                     // setState(() {
//                                     //
//                                     // });
//                                   },
//                                   child: Icon(Icons.my_location,
//                                       color: Colors.deepOrange,
//                                       size: screenWidth * 0.05),
//                                 ),
//                               )*/
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           flex: 6,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 flex: 1,
//                                 child: Container(),
//                               ),
//                               Expanded(
//                                 flex: 7,
//                                 child: TextField(
//                                   readOnly: true,
//                                   controller: _startingPointText,
//                                   style: TextStyle(
//                                     fontSize: 15.0,
//                                     color: Colors.black,
//                                   ),
//                                   textAlignVertical: TextAlignVertical.top,
//                                   keyboardType: TextInputType.streetAddress,
//                                   decoration: InputDecoration(
//                                       // prefixIcon: Icon(Icons.lock_outline),
//                                       hintText: "Ex: 71, South Dum Dum, Kol - 700030 *",
//                                       hintStyle: TextStyle(color: Colors.black54, fontSize: 14.0, fontWeight: FontWeight.w300),
//                                       border: InputBorder.none),
//                                   onTap: () {
//                                     rName = _receiverNameText.text;
//                                     productName = _productNameText.text;
//                                     productWeight = _productWeightText.text;
//                                     productPrice = _productPriceText.text;
//                                     dateAndTime = _dateAndTimeText.text;
//                                     rPhone = _receiverPhoneNumberText.text;
//                                     sName = _senderNameText.text;
//                                     sPhone = _senderPhoneNumberText.text;
//                                     vehicleType = _selectedItemType;
//                                     productType = _selectedProductType;
//                                     productNameVisibility1=productNameVisibility;
//                                     Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
//                                       return MapHomePage(
//                                         adressType: "pickup",
//                                       );
//                                     }));
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     height: 80.0,
//                     alignment: Alignment.topCenter,
//                     margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
//                     padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                     ),
//                     child: Column(
//                       children: [
//                         Expanded(
//                           flex: 3,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                   flex: 1,
//                                   child: Image.asset(
//                                     "assets/images/icons/location_icon.png",
//                                     height: 20.0,
//                                   )),
//                               Expanded(
//                                 flex: 7,
//                                 child: Text(
//                                   "Destination",
//                                   style: TextStyle(fontSize: 16.0, color: Colors.deepOrange, fontWeight: font_bold),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           flex: 6,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 flex: 1,
//                                 child: Container(),
//                               ),
//                               Expanded(
//                                 flex: 7,
//                                 child: TextField(
//                                   readOnly: true,
//                                   controller: _destinationText,
//                                   style: TextStyle(fontSize: 15.0),
//                                   textAlignVertical: TextAlignVertical.top,
//                                   keyboardType: TextInputType.streetAddress,
//                                   decoration: InputDecoration(
//                                       // prefixIcon: Icon(Icons.lock_outline),
//                                       hintText: "Ex: 85, Salt Lake, Kol - 700085 *",
//                                       hintStyle: TextStyle(color: Colors.black54, fontSize: 14.0, fontWeight: FontWeight.w300),
//                                       border: InputBorder.none),
//                                   onTap: () {
//                                     rName = _receiverNameText.text;
//                                     productName = _productNameText.text;
//                                     productWeight = _productWeightText.text;
//                                     productPrice = _productPriceText.text;
//                                     dateAndTime = _dateAndTimeText.text;
//                                     rPhone = _receiverPhoneNumberText.text;
//                                     sName = _senderNameText.text;
//                                     sPhone = _senderPhoneNumberText.text;
//                                     vehicleType = _selectedItemType;
//                                     productType = _selectedProductType;
//                                     productNameVisibility1=productNameVisibility;
//                                     Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
//                                       return MapHomePage(
//                                         adressType: "destination",
//                                       );
//                                     }));
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     height: 75.0,
//                     alignment: Alignment.topCenter,
//                     margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
//                     padding: EdgeInsets.all(10.0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                     ),
//                     child: Column(
//                       children: [
//                         Expanded(
//                           flex: 1,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                   flex: 1,
//                                   child: Icon(
//                                     Icons.local_car_wash_outlined,
//                                     color: Colors.deepOrange,
//                                     size: 20.0,
//                                   )),
//                               Expanded(
//                                 flex: 7,
//                                 child: Text(
//                                   "Vehicle Types",
//                                   style: TextStyle(fontSize: 16.0, color: Colors.deepOrange, fontWeight: font_bold),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           flex: 1,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 flex: 1,
//                                 child: Container(),
//                               ),
//                               Expanded(
//                                 flex: 7,
//                                 child: DropdownButtonHideUnderline(
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(right: 15),
//                                     child: DropdownButton(
//                                       dropdownColor: Colors.white,
//                                       value: _selectedItemType,
//                                       items: _dropdownMenuItemsType,
//                                       onChanged: (value) async {
//                                         _selectedItemType = value;
//                                         setState(() {});
//                                       },
//                                       style: new TextStyle(
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     height: 75.0,
//                     alignment: Alignment.topCenter,
//                     margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
//                     padding: EdgeInsets.all(10.0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                     ),
//                     child: Column(
//                       children: [
//                         Expanded(
//                           flex: 1,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                   flex: 1,
//                                   child: Icon(
//                                     Icons.more_time,
//                                     color: Colors.deepOrange,
//                                     size: 20.0,
//                                   )),
//                               Expanded(
//                                 flex: 7,
//                                 child: Text(
//                                   "Delivery Date and Time",
//                                   style: TextStyle(fontSize: 16.0, color: Colors.deepOrange, fontWeight: font_bold),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           flex: 1,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 flex: 1,
//                                 child: Container(),
//                               ),
//                               Expanded(
//                                 flex: 7,
//                                 child: TextField(
//                                   readOnly: true,
//                                   controller: _dateAndTimeText,
//                                   style: TextStyle(fontSize: 14.0),
//                                   textAlignVertical: TextAlignVertical.top,
//                                   decoration: InputDecoration(
//                                       // prefixIcon: Icon(Icons.lock_outline),
//                                       hintText: "Ex: ${DateFormat.yMMMMd().add_jm().format(DateTime.now())} *",
//                                       hintStyle: TextStyle(color: Colors.black54, fontSize: 13.0, fontWeight: FontWeight.w300),
//                                       border: InputBorder.none),
//                                   onTap: () {
//                                     DatePicker.showDateTimePicker(context,
//                                         theme: DatePickerTheme(
//                                             containerHeight: 250,
//                                             backgroundColor: darkThemeBlue,
//                                             itemStyle: TextStyle(color: Colors.white),
//                                             cancelStyle: TextStyle(color: Colors.red[900], fontWeight: FontWeight.w500),
//                                             doneStyle: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w500),
//                                             headerColor: lightThemeBlue,
//                                             itemHeight: 45.0,
//                                             titleHeight: 45.0),
//                                         showTitleActions: true,
//                                         minTime: DateTime.now(),
//                                         maxTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 14),
//                                         onChanged: (date) {
//                                       print('change $date');
//                                     }, onConfirm: (date) {
//                                       print('confirm $date');
//                                       // final String formatted = formatter.format(date);
//                                       // print(formatted);
//                                       _dateAndTimeText.text = DateFormat.yMd().add_Hms().format(date);
//                                       // print(DateFormat.yMMMMd().add_jm().format(date));
//                                       // print(DateFormat.yMd().add_Hms().format(date));
//                                       // print(DateFormat().parse(_dateAndTimeText.text, true).hour);
//                                       print(DateFormat("MM/dd/yyyy HH:mm:ss").parse(_dateAndTimeText.text.trim()).hour);
//                                     }, currentTime: DateTime.now(), locale: LocaleType.en);
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 15.0,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
//                     child: ButtonTheme(
//                       /*__To Enlarge Button Size__*/
//                       height: 50.0,
//                       child: RaisedButton(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12.0),
//                         ),
//                         onPressed: () {
//                           if (senderToken == "") {
//                             Fluttertoast.showToast(
//                                 msg: "Please Login First to Proceed",
//                                 fontSize: 16,
//                                 backgroundColor: Colors.orange[100],
//                                 textColor: darkThemeBlue,
//                                 toastLength: Toast.LENGTH_LONG);
//                           } else if (_startingPointText.text == "" ||
//                               _destinationText.text == "" ||
//                               // _productWeightText.text == "" ||
//                               _receiverPhoneNumberText.text == "" ||
//                               _receiverNameText.text == "" ||
//                               _senderPhoneNumberText.text == "" ||
//                               _senderNameText.text == "" ||
//                               // _productPriceText.text == "" ||
//                               _dateAndTimeText.text == "") {
//                             Fluttertoast.showToast(
//                                 msg: "Please Fill All Required Field *",
//                                 fontSize: 16,
//                                 backgroundColor: Colors.orange[100],
//                                 textColor: darkThemeBlue,
//                                 toastLength: Toast.LENGTH_LONG);
//                           } else if (_receiverPhoneNumberText.text.length < 10) {
//                             Fluttertoast.showToast(
//                                 msg: "Please Enter Correct Phone Number",
//                                 fontSize: 16,
//                                 backgroundColor: Colors.orange[100],
//                                 textColor: darkThemeBlue,
//                                 toastLength: Toast.LENGTH_LONG);
//                           } else {
//                             if (_selectedProductType == "OTHER") {
//                               if (_productNameText.text != "") {
//                                 _mapDistanceBloc.mapDistanceCal(pickUpLat, pickUpLong, dropLat, droplong);
//                               }else{
//                                 Fluttertoast.showToast(
//                                     msg: "Please Enter Other Product Name",
//                                     fontSize: 16,
//                                     backgroundColor: Colors.orange[100],
//                                     textColor: darkThemeBlue,
//                                     toastLength: Toast.LENGTH_LONG);
//                               }
//                             }else{
//                               _mapDistanceBloc.mapDistanceCal(pickUpLat, pickUpLong, dropLat, droplong);
//
//                             }
//                           }
//                         },
//                         color: Colors.deepOrange,
//                         textColor: Colors.white,
//                         child: StreamBuilder<ApiResponse<MapDistanceModel>>(
//                           stream: _mapDistanceBloc.mapDistanceStream,
//                           builder: (context, snapshot) {
//                             if (snapshot.hasData) {
//                               switch (snapshot.data.status) {
//                                 case Status.LOADING:
//                                   return CircularProgressIndicator(
//                                       backgroundColor: circularBGCol,
//                                       strokeWidth: strokeWidth,
//                                       valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol));
//
//                                   break;
//                                 case Status.COMPLETED:
//                                   {
//                                     double pricePerKM;
//                                     bool morningTime=true;
//                                     double minPrice;
//                                     int distance = snapshot.data.data.rows[0].elements[0].distance.value;
//                                     double disKM = distance / 1000;
//                                     double actualDistance=disKM;
//                                     disKM = double.parse("${disKM.ceil()}");
//                                     double price=0;
//
//                                     // String hourTime=DateFormat.H().format(DateFormat().parse(_dateAndTimeText.text, true));
//                                     if (_selectedItemType == "TWO WHEELER (Max 20km)") {
//
//
//                                       morningTime = (DateFormat("MM/dd/yyyy HH:mm:ss").parse(_dateAndTimeText.text.trim()).hour >= 10 &&
//                                               DateFormat("MM/dd/yyyy HH:mm:ss").parse(_dateAndTimeText.text.trim()).hour < 22)
//                                           ? true
//                                           : false;
//
//                                       // pricePerKM = (DateFormat("MM/dd/yyyy HH:mm:ss").parse(_dateAndTimeText.text.trim()).hour >= 10 &&
//                                       //     DateFormat("MM/dd/yyyy HH:mm:ss").parse(_dateAndTimeText.text.trim()).hour < 22)
//                                       //     ? 10
//                                       //     : 15;
//                                       // minPrice = 40;
//
//                                       if(morningTime){
//                                         minPrice=40;
//                                         if(disKM<=5){
//                                           price = 40;
//                                         }else if(disKM>5 && disKM<=(10)){
//                                           price = 40;
//                                           price+= (disKM-5.0)*10;
//                                         }else if(disKM>(10.0) && disKM<=(20.0)){
//                                           price = 40;
//                                           price+= (10.0-5.0) * 10;
//                                           price+= (disKM-(10.0)) * 15;
//                                         }else if(disKM>(20.0)/*&& disKM<=(5+10+20+30)*/){
//                                           price = 40;
//                                           price+= (10.0-5.0) * 10;
//                                           price+= (20.0-10.0) * 15;
//                                           price+= (disKM-(20.0)) * 20;
//                                         }
//                                       }else{
//                                         minPrice=60;
//                                         if(disKM<=5){
//                                           price = 60;
//                                         }else if(disKM>5 && disKM<=(10)){
//                                           price = 60;
//                                           price+= (disKM-5.0)*15;
//                                         }else if(disKM>(10.0) && disKM<=(20.0)){
//                                           price = 60;
//                                           price+= (10.0-5.0) * 15;
//                                           price+= (disKM-(10.0)) * 20;
//                                         }else if(disKM>(20.0)/*&& disKM<=(5+10+20+30)*/){
//                                           price = 60;
//                                           price+= (10.0-5.0) * 15;
//                                           price+= (20.0-10.0) * 20;
//                                           price+= (disKM-(20.0)) * 20;
//                                         }
//                                       }
//                                       // if (DateFormat("MM/dd/yyyy HH:mm:ss").parse(_dateAndTimeText.text.trim()).hour >= 10 &&
//                                       //     DateFormat("MM/dd/yyyy HH:mm:ss").parse(_dateAndTimeText.text.trim()).hour < 22) {
//                                       //   price = (disKM * pricePerKM);
//                                       //   print(price);
//                                       //   price = (price < minPrice) ? minPrice : price.ceilToDouble();
//                                       // } else {
//                                       //   price = (disKM * pricePerKM);
//                                       //   print(price);
//                                       //   price = (price < minPrice) ? minPrice : price.ceilToDouble();
//                                       // }
//                                     } else if (_selectedItemType == "FOUR WHEELER (Max 50km)") {
//                                       pricePerKM = 20;
//                                       minPrice = 300;
//                                       if (disKM < 6) {
//                                         price = minPrice;
//                                       } else {
//                                         price = 300 + ((disKM - 5) * pricePerKM);
//                                       }
//                                     }
//
//                                     print(price);
//                                     print(disKM);
//                                     String productPriceCheck =
//                                         (_productPriceText.text != "") ? " Price : Rs.${_productPriceText.text}/-" : "";
//
//                                     Future.delayed(Duration.zero, () {
//                                       showDialog(
//                                           context: context,
//                                           barrierDismissible: false,
//                                           builder: (context) {
//                                             return AlertDialog(
//                                               // title: Text("Give the code?"),
//                                               content: SingleChildScrollView(
//                                                 child: Column(
//                                                   mainAxisSize: MainAxisSize.min,
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: <Widget>[
//                                                     Flexible(
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.only(top: 10.0),
//                                                         child: RichText(
//                                                           // To Make Different Text Color in single line
//                                                           text: TextSpan(
//                                                               text: "Pickup Address : ",
//                                                               style: TextStyle(color: orangeCol, fontSize: 14, fontWeight: FontWeight.w600),
//                                                               children: [
//                                                                 TextSpan(
//                                                                   text: "${_startingPointText.text}",
//                                                                   style: TextStyle(
//                                                                       color: darkThemeBlue, fontSize: 12, fontWeight: FontWeight.w400),
//                                                                 ),
//                                                               ]),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Flexible(
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.only(top: 10.0),
//                                                         child: RichText(
//                                                           // To Make Different Text Color in single line
//                                                           text: TextSpan(
//                                                               text: "Drop Address : ",
//                                                               style: TextStyle(color: orangeCol, fontSize: 14, fontWeight: FontWeight.w600),
//                                                               children: [
//                                                                 TextSpan(
//                                                                   text: "${_destinationText.text}",
//                                                                   style: TextStyle(
//                                                                       color: darkThemeBlue, fontSize: 12, fontWeight: FontWeight.w400),
//                                                                 ),
//                                                               ]),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Flexible(
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.only(top: 10.0),
//                                                         child: RichText(
//                                                           // To Make Different Text Color in single line
//                                                           text: TextSpan(
//                                                               text: "Total Distance : ",
//                                                               style: TextStyle(color: orangeCol, fontSize: 14, fontWeight: FontWeight.w600),
//                                                               children: [
//                                                                 TextSpan(
//                                                                   text: "$actualDistance k.m.",
//                                                                   style: TextStyle(
//                                                                       color: darkThemeBlue, fontSize: 12, fontWeight: FontWeight.w500),
//                                                                 ),
//                                                               ]),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Flexible(
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.only(top: 10.0),
//                                                         child: RichText(
//                                                           // To Make Different Text Color in single line
//                                                           text: TextSpan(
//                                                               text: "Min Delivery Charge : ",
//                                                               style: TextStyle(color: orangeCol, fontSize: 14, fontWeight: FontWeight.w600),
//                                                               children: [
//                                                                 TextSpan(
//                                                                   text: "Rs.$minPrice/-",
//                                                                   style: TextStyle(
//                                                                       color: darkThemeBlue, fontSize: 12, fontWeight: FontWeight.w500),
//                                                                 ),
//                                                               ]),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     // Flexible(
//                                                     //   child: Padding(
//                                                     //     padding: const EdgeInsets.only(top: 10.0),
//                                                     //     child: RichText(
//                                                     //       // To Make Different Text Color in single line
//                                                     //       text: TextSpan(
//                                                     //           text: "Delivery Charge Per k.m. : ",
//                                                     //           style: TextStyle(color: orangeCol, fontSize: 14, fontWeight: FontWeight.w600),
//                                                     //           children: [
//                                                     //             TextSpan(
//                                                     //               text: "Rs.$pricePerKM/-",
//                                                     //               style: TextStyle(
//                                                     //                   color: darkThemeBlue, fontSize: 12, fontWeight: FontWeight.w500),
//                                                     //             ),
//                                                     //           ]),
//                                                     //     ),
//                                                     //   ),
//                                                     // ),
//                                                     Flexible(
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
//                                                         child: RichText(
//                                                           // To Make Different Text Color in single line
//                                                           text: TextSpan(
//                                                               text: "Your Total Delivery Charge : ",
//                                                               style: TextStyle(color: orangeCol, fontSize: 14, fontWeight: FontWeight.w600),
//                                                               children: [
//                                                                 TextSpan(
//                                                                   text: "Rs.${price.ceilToDouble()}/-",
//                                                                   style: TextStyle(
//                                                                       color: darkThemeBlue, fontSize: 13, fontWeight: FontWeight.w600),
//                                                                 ),
//                                                               ]),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Divider(
//                                                       color: Colors.red,
//                                                     ),
//                                                     Center(
//                                                       child: new FlatButton(
//                                                           shape: RoundedRectangleBorder(
//                                                               side:
//                                                                   BorderSide(color: Colors.deepOrange, width: 1, style: BorderStyle.solid),
//                                                               borderRadius: BorderRadius.circular(5)),
//                                                           onPressed: () {
//                                                             String _vehicleType="2W";
//                                                             if(_selectedItemType=="FOUR WHEELER (Max 50km)") _vehicleType="4W";
//                                                             String productName=_selectedProductType;
//                                                             productName=(productName=="OTHER")?_productNameText.text:productName;
//                                                             Map _body = {
//                                                               "expected_delivery_time": "${_dateAndTimeText.text}",
//                                                               "payment_method": "COD",
//                                                               "payer": "SENDER",
//                                                               "item_type": "$productPriceCheck",
//                                                               "product_name": "$productName",
//                                                               "weight": "${_productWeightText.text}",
//                                                               "distance": "$actualDistance",
//                                                               "cost_per_km": "$pricePerKM",
//                                                               "payable_amount": "${price.ceilToDouble()}",
//                                                               "sender_name": "${_senderNameText.text}",
//                                                               "sender_mobile": "+91${_senderPhoneNumberText.text}",
//                                                               "sender_address": "${_startingPointText.text}",
//                                                               "sender_pin": "",
//                                                               "sender_landmark": "$pickupLandMark",
//                                                               "sender_latitude": "$pickUpLat",
//                                                               "sender_longitude": "$pickUpLong",
//                                                               "receiver_name": "${_receiverNameText.text}",
//                                                               "receiver_mobile": "+91${_receiverPhoneNumberText.text}",
//                                                               "receiver_address": "${_destinationText.text}",
//                                                               "receiver_pin": "",
//                                                               "receiver_landmark": "$destinationLandMark",
//                                                               "receiver_latitude": "$dropLat",
//                                                               "receiver_longitude": "$droplong",
//                                                               "vehicle_type": "$_vehicleType"
//                                                             };
//                                                             // if (streamCheckSetState) {
//                                                             //   Future.delayed(Duration.zero, () {
//                                                             //     setState(() {
//                                                             //       streamCheck = true;
//                                                             //       streamCheckSetState = false;
//                                                             //     });
//                                                             //   });}
//                                                             _pickupDropBloc.pickupDropRequest(senderToken, _body);
//                                                             Future.delayed(Duration.zero, () {
//                                                               showDialog(
//                                                                   context: context,
//                                                                   barrierDismissible: false,
//                                                                   builder: (context) {
//                                                                     return WillPopScope(
//                                                                       onWillPop: () async => false,
//                                                                       child: CustomDialog(
//                                                                         backgroundColor: Colors.white60,
//                                                                         clipBehavior: Clip.hardEdge,
//                                                                         insetPadding: EdgeInsets.all(0),
//                                                                         child: Padding(
//                                                                           padding: const EdgeInsets.all(20.0),
//                                                                           child: SizedBox(
//                                                                             width: 50.0,
//                                                                             height: 50.0,
//                                                                             child: CircularProgressIndicator(
//                                                                                 backgroundColor: circularBGCol,
//                                                                                 strokeWidth: strokeWidth,
//                                                                                 valueColor:
//                                                                                 AlwaysStoppedAnimation<Color>(circularStrokeCol)),
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     );
//                                                                   });
//                                                             });
//                                                           },
//                                                           child: StreamBuilder<ApiResponse<PickupDropModel>>(
//                                                             stream: _pickupDropBloc.pickupDropStream,
//                                                             builder: (context, snapshot) {
//                                                               if (snapshot.hasData) {
//                                                                 switch (snapshot.data.status) {
//                                                                   case Status.LOADING:
//                                                                     // streamCheck = false;
//                                                                     /*return CircularProgressIndicator(
//                                                                       backgroundColor: circularBGCol,
//                                                                       strokeWidth: strokeWidth,
//                                                                       valueColor: AlwaysStoppedAnimation<Color>(
//                                                                           circularStrokeCol));*/
//                                                                     /*Loading(
//                                                                     loadingMessage: snapshot.data.message,
//                                                                   );*/
//                                                                     break;
//                                                                   case Status.COMPLETED:
//                                                                     // managedSharedPref(snapshot.data.data);
//                                                                     navToAttachList(context);
//                                                                     pickupAddress = "";
//                                                                     destinationAddress = "";
//                                                                     pickUpLat = 0;
//                                                                     pickUpLong = 0;
//                                                                     dropLat = 0;
//                                                                     droplong = 0;
//                                                                     rName = "";
//                                                                     rPhone = "";
//                                                                     sName = "";
//                                                                     sPhone = "";
//                                                                     productName = "";
//                                                                     productWeight = "";
//                                                                     dateAndTime = "";
//                                                                     productPrice = "";
//                                                                     productNameVisibility1=false;
//
//                                                                     if (snapshot.data.data.success != null) {
//                                                                       print("complete piickup Drop");
//                                                                       Fluttertoast.showToast(
//                                                                           msg: "Pickup Drop Successfully Placed",
//                                                                           fontSize: 16,
//                                                                           backgroundColor: Colors.orange[100],
//                                                                           textColor: darkThemeBlue,
//                                                                           toastLength: Toast.LENGTH_LONG);
//                                                                     } else {
//                                                                       print("Failed piickup Drop");
//                                                                       Fluttertoast.showToast(
//                                                                           msg: "Pickup Drop Order Failed",
//                                                                           fontSize: 16,
//                                                                           backgroundColor: Colors.orange[100],
//                                                                           textColor: darkThemeBlue,
//                                                                           toastLength: Toast.LENGTH_LONG);
//                                                                     }
//                                                                     break;
//                                                                   case Status.ERROR:
//                                                                     Navigator.pop(context);
//                                                                     Fluttertoast.showToast(
//                                                                         msg: "${snapshot.data.message}",
//                                                                         fontSize: 16,
//                                                                         backgroundColor: Colors.orange[100],
//                                                                         textColor: darkThemeBlue,
//                                                                         toastLength: Toast.LENGTH_LONG);
//                                                                     //   Error(
//                                                                     //   errorMessage: snapshot.data.message,
//                                                                     // );
//                                                                     break;
//                                                                 }
//                                                               } else if (snapshot.hasError) {
//                                                                 Navigator.pop(context);
//                                                                 print("error");
//                                                               }
//
//                                                               return Text(
//                                                                 "Place Pickup Order",
//                                                                 style: TextStyle(
//                                                                   color: Colors.deepOrangeAccent,
//                                                                   fontSize: 14.0,
//                                                                   // fontWeight: FontWeight.bold
//                                                                 ),
//                                                               );
//                                                             },
//                                                           )),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             );
//                                           });
//                                     });
//
//                                     print("map response");
//                                     print(snapshot.data.data.rows[0].elements[0].distance.text);
//                                   }
//                                   break;
//                                 case Status.ERROR:
//                                   return Error(
//                                     errorMessage: snapshot.data.message,
//                                   );
//                                   break;
//                               }
//                             } else if (snapshot.hasError) {
//                               print("error");
//                             }
//
//                             return Text("REQUEST", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 15.0,
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   navToAttachList(context) async {
//     Future.delayed(Duration.zero, () {
//       Navigator.pop(context);
//       Navigator.pop(context);
//       // Navigator.of(context).pushAndRemoveUntil(
//       //     MaterialPageRoute(builder: (context) => PickupOrderDetailsPage()),
//       //         (Route<dynamic> route) => route is HomePage
//       //     // ModalRoute.withName("/HomePage")
//       // );
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
//         return PickupOrderDetailsPage();
//       }));
//     });
//   }
//
//   _getLocation() async {
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     debugPrint('location: ${position.latitude}');
//     final coordinates = new Coordinates(position.latitude, position.longitude);
//     var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
//     var first = addresses.first;
//     _startingPointText.text = "${first.addressLine}";
//     print("${first.featureName} : ${first.addressLine}");
//     setState(() {});
//   }
// }
//
// // class ListItem {
// //   int value;
// //   String name;
// //
// //   ListItem(this.value, this.name);
// // }
//
// // (streamCheck)
// //     ? StreamBuilder<ApiResponse<PickupDropModel>>(
// //         stream: _pickupDropBloc.pickupDropStream,
// //         builder: (context, snapshot) {
// //           if (snapshot.hasData) {
// //             switch (snapshot.data.status) {
// //               case Status.LOADING:
// //                 streamCheck = false;
// //                 /*return CircularProgressIndicator(
// //               backgroundColor: circularBGCol,
// //               strokeWidth: strokeWidth,
// //               valueColor: AlwaysStoppedAnimation<Color>(
// //                   circularStrokeCol));*/
// //                 /*Loading(
// //             loadingMessage: snapshot.data.message,
// //           );*/
// //                 showDialog(
// //                     context: context,
// //                     barrierDismissible: false,
// //                     builder: (context) {
// //                       return WillPopScope(
// //                         onWillPop: () async => false,
// //                         child: CustomDialog(
// //                           backgroundColor: Colors.white60,
// //                           clipBehavior: Clip.hardEdge,
// //                           insetPadding: EdgeInsets.all(0),
// //                           child: Padding(
// //                             padding:
// //                             const EdgeInsets.all(20.0),
// //                             child: SizedBox(
// //                               width: 50.0,
// //                               height: 50.0,
// //                               child: CircularProgressIndicator(
// //                                   backgroundColor:
// //                                   circularBGCol,
// //                                   strokeWidth: strokeWidth,
// //                                   valueColor:
// //                                   AlwaysStoppedAnimation<
// //                                       Color>(
// //                                       circularStrokeCol)),
// //                             ),
// //                           ),
// //                         ),
// //                       );
// //                     });
// //                 break;
// //               case Status.COMPLETED:
// //                 // managedSharedPref(snapshot.data.data);
// //                 navToAttachList(context);
// //                 pickupAddress = "";
// //                 destinationAddress = "";
// //                 pickUpLat = 0;
// //                 pickUpLong = 0;
// //                 dropLat = 0;
// //                 droplong = 0;
// //                 rName = "";
// //                 rPhone = "";
// //                 productName = "";
// //                 productWeight = "";
// //                 dateAndTime="";
// //                 productPrice="";
// //
// //                 if (snapshot.data.data.success != null) {
// //                   print("complete piickup Drop");
// //                   Fluttertoast.showToast(
// //                       msg: "Pickup Drop Successfully Placed",
// //                       fontSize: 16,
// //                       backgroundColor: Colors.orange[100],
// //                       textColor: darkThemeBlue,
// //                       toastLength: Toast.LENGTH_LONG);
// //                 } else {
// //                   print("Failed piickup Drop");
// //                   Fluttertoast.showToast(
// //                       msg: "Pickup Drop Order Failed",
// //                       fontSize: 16,
// //                       backgroundColor: Colors.orange[100],
// //                       textColor: darkThemeBlue,
// //                       toastLength: Toast.LENGTH_LONG);
// //                 }
// //                 break;
// //               case Status.ERROR:
// //                 Navigator.pop(context);
// //                 Fluttertoast.showToast(
// //                     msg: "${snapshot.data.message}",
// //                     fontSize: 16,
// //                     backgroundColor: Colors.orange[100],
// //                     textColor: darkThemeBlue,
// //                     toastLength: Toast.LENGTH_LONG);
// //                 //   Error(
// //                 //   errorMessage: snapshot.data.message,
// //                 // );
// //                 break;
// //             }
// //           } else if (snapshot.hasError) {
// //             Navigator.pop(context);
// //             print("error");
// //           }
// //
// //           return Container();
// //         },
// //       )
// //     : Container(),
