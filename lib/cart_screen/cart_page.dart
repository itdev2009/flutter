// import 'package:delivery_on_time/address_screens/addressListPage.dart';
// import 'package:delivery_on_time/cart_screen/bloc/cartItemsUpdateBloc.dart';
// import 'package:delivery_on_time/cart_screen/model/cartItemsDetailsModel.dart';
// import 'package:delivery_on_time/cart_screen/model/cartItemsUpdateModel.dart';
// import 'package:delivery_on_time/cart_screen/promoCode_page.dart';
// import 'package:delivery_on_time/cart_screen/repository/cartRepository.dart';
// import 'package:delivery_on_time/constants.dart';
// import 'package:delivery_on_time/help/api_response.dart';
// import 'package:delivery_on_time/loginMobile_screen/loginByMobile.dart';
// import 'package:delivery_on_time/login_screen/login.dart';
// import 'package:delivery_on_time/pickup_drop_screen/bloc/mapDistanceBloc.dart';
// import 'package:delivery_on_time/pickup_drop_screen/model/mapDistanceModel.dart';
// import 'package:delivery_on_time/profile_screen/bloc/profileUpdateBloc.dart';
// import 'package:delivery_on_time/profile_screen/model/profileUpdateModel.dart';
// import 'package:delivery_on_time/utility/Error.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:io';
//
// import '../customAlertDialog.dart';
//
// class CartPage extends StatefulWidget {
//   @override
//   _CartPageState createState() => _CartPageState();
// }
//
// class _CartPageState extends State<CartPage> {
//   List _productAmount = new List();
//   CartRepository _cartRepository;
//   CartItemsUpdateBloc _cartItemsUpdateBloc;
//   SharedPreferences prefs;
//   Map _body;
//   Future<CartItemsDetailsModel> _cartApi;
//
//   TextEditingController _nameController = new TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   ProfileUpdateBloc _profileUpdateBloc;
//   bool updateCheck = false;
//   bool mapApiCheck = false;
//
//   bool cartChangeCheck = false;
//   String _userToken = "";
//   String name = "";
//   String email = "";
//   String cart_id = "";
//   String user_id = "";
//   String coupon_code = "";
//   int notAvailableCount = 0;
//   double shopDistance;
//
//   MapDistanceBloc _mapDistanceBloc;
//
//   double shopLat = 0.0;
//   double shopLong = 0.0;
//
//   // double userLat=0.0;
//   // double userLong=0.0;
//
//   int index2;
//   bool indexCheck = false;
//   bool indexCheckStream = false;
//   bool first = true;
//
//   List<bool> _moreLessVisibility = new List<bool>();
//   List<bool> _outOfStockVisibility = new List<bool>();
//   List<bool> _deleteVisibility = new List<bool>();
//
//   @override
//   void initState() {
//     super.initState();
//     _mapDistanceBloc = new MapDistanceBloc();
//     _cartRepository = new CartRepository();
//     _cartItemsUpdateBloc = CartItemsUpdateBloc();
//     _profileUpdateBloc = new ProfileUpdateBloc();
//     createSharedPref();
//     // if(prefs.getString("cart_id")!="")
//     // print("cartId at Cart page"+prefs.getString("cart_id"));
//   }
//
//   Future<void> managedSharedPref(CartItemsDetailsModel data) async {
//     prefs.setString("Total_cart_amount", data.data.totalIncludingTaxDelivery);
//     // cartId=data.data.cartItems[0].cartId;
//   }
//
//   Future<void> createSharedPref() async {
//     prefs = await SharedPreferences.getInstance();
//     // print("cartId at Cart page1" + prefs.getString("cart_id")??"");
//     cart_id = prefs.getString("cart_id") ?? "";
//     user_id = prefs.getString("user_id") ?? "";
//     _userToken = prefs.getString("user_token") ?? "";
//     coupon_code = prefs.getString("coupon_code") ?? "";
//
//     shopDistance = prefs.getDouble("shopDistance") ?? 0;
//
//     name = prefs.getString("name");
//     email = prefs.getString("email");
//
//     shopLat = prefs.getDouble("shopLat")??userLat;
//     shopLong = prefs.getDouble("shopLong")??userLong;
//
//     if (coupon_code == null) coupon_code = "";
//
//     _body = {"cartid": cart_id, "userid": user_id, "coupon_code": coupon_code, "distance": "$shopDistance"};
//     print("data cart");
//     print(_body);
//
//     mapApiCheck = true;
//     _mapDistanceBloc.mapDistanceCal(shopLat, shopLong, userLat, userLong);
//     Future.delayed(Duration.zero, () {
//       showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (context) {
//             return WillPopScope(
//               onWillPop: () async => false,
//               child: CustomDialog(
//                 backgroundColor: Colors.white60,
//                 clipBehavior: Clip.hardEdge,
//                 insetPadding: EdgeInsets.all(0),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: SizedBox(
//                     width: 50.0,
//                     height: 50.0,
//                     child: CircularProgressIndicator(
//                         backgroundColor: circularBGCol,
//                         strokeWidth: strokeWidth,
//                         valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol)),
//                   ),
//                 ),
//               ),
//             );
//           });
//     });
//     // _cartApi = _cartRepository.cartItemsDetails(_body);
//     // setState(() {});
//   }
//
//   navToAttachList(context) async {
//     Future.delayed(Duration.zero, () {
//       Navigator.pop(context);
//       Navigator.push(context, MaterialPageRoute(builder: (context) => AddressListPage()));
//     });
//   }
//
//   // if(prefs.getString("cart_id")!="")
//   // {
// // };
//
//   @override
//   Widget build(BuildContext context) {
//     // print("cartId at Cart page"+prefs.getString("cart_id"));
//     /* Map _body={
//       "cartid": "${prefs.getString("cart_id")}",
//       "userid": "${prefs.getString("user_id")}"
//     };*/
//     /*Map _body = {
//       "cartid": "${prefs.get("cart_id")}"
//     };*/
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
//                 )),
//             title: Center(
//                 child: Text(
//               "CART",
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
//         body: Container(
//           height: screenHeight,
//           color: Color.fromRGBO(8, 35, 54, 1.0),
//           child: ListView(
//             physics: ScrollPhysics(),
//             shrinkWrap: true,
//             children: [
//               StreamBuilder<ApiResponse<MapDistanceModel>>(
//                 stream: _mapDistanceBloc.mapDistanceStream,
//                 builder: (context, snapshot) {
//                   if (mapApiCheck) {
//                     if (snapshot.hasData) {
//                       switch (snapshot.data.status) {
//                         case Status.LOADING:
//                           break;
//                         case Status.COMPLETED:
//                           {
//                             if (snapshot.data.data.rows[0].elements[0].status == "ZERO_RESULTS") {
//                               Fluttertoast.showToast(
//                                   msg: "Please Select a Proper User Location",
//                                   fontSize: 14,
//                                   backgroundColor: Colors.orange[100],
//                                   textColor: darkThemeBlue,
//                                   toastLength: Toast.LENGTH_LONG);
//                               Navigator.pop(context);
//                               return Center(
//                                 child: Text("Please Select a Proper Restaurant or Proper user Location",
//                                 textAlign: TextAlign.center,
//                                 style: GoogleFonts.poppins(
//                                   color: Colors.white,
//                                   fontSize: screenWidth*0.05,
//                                   fontWeight: FontWeight.w500
//                                 ),),
//                               );
//                             } else {
//                               mapApiCheck = false;
//                               shopDistance = snapshot.data.data.rows[0].elements[0].distance.value / 1000;
//                               prefs.setDouble("shopDistance", shopDistance);
//                               Future.delayed(Duration.zero, () {
//                                 Navigator.pop(context);
//                                 _cartApi = _cartRepository.cartItemsDetails(
//                                     {"cartid": cart_id, "userid": user_id, "coupon_code": coupon_code, "distance": "$shopDistance"});
//                                 setState(() {});
//                               });
//                             }
//                           }
//                           break;
//                         case Status.ERROR:
//                           mapApiCheck = false;
//                           Navigator.pop(context);
//
//                           Fluttertoast.showToast(
//                               msg: "Please try again!",
//                               fontSize: 14,
//                               backgroundColor: Colors.orange[100],
//                               textColor: darkThemeBlue,
//                               toastLength: Toast.LENGTH_LONG);
//                           print(snapshot.data.message);
//                           break;
//                       }
//                     } else if (snapshot.hasError) {
//                       mapApiCheck = false;
//                       Navigator.pop(context);
//                       print("error");
//                     }
//                   }
//                   return Container();
//                 },
//               ),
//               StreamBuilder<ApiResponse<CartItemsUpdateModel>>(
//                 stream: _cartItemsUpdateBloc.cartItemsUpdateStream,
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     switch (snapshot.data.status) {
//                       case Status.LOADING:
//                         return Container();
//                         break;
//                       case Status.COMPLETED:
//                         {
//                           print("data update +++in cart page");
//                           if (cartChangeCheck) {
//                             _cartApi = _cartRepository.cartItemsDetails(_body);
//                             if (indexCheckStream) {
//                               indexCheck = true;
//                               // _productAmount.removeAt(index1);
//                               // _outOfStockVisibility.removeAt(index1);
//                               // _deleteVisibility.removeAt(index1);
//                               // _moreLessVisibility.removeAt(index1);
//                               indexCheckStream = false;
//                             }
//                             Future.delayed(Duration(seconds: 1), () {
//                               setState(() {
//                                 cartChangeCheck = false;
//                               });
//                             });
//                           }
//                         }
//                         break;
//                       case Status.ERROR:
//                         return Error(
//                           errorMessage: snapshot.data.message,
//                         );
//                         break;
//                     }
//                   } else if (snapshot.hasError) {
//                     print("error");
//                   }
//
//                   return Container();
//                 },
//               ),
//               FutureBuilder<CartItemsDetailsModel>(
//                 future: _cartApi,
//                 builder: (context, snapshot) {
//
//                   if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
//                     if (snapshot.data.data.totalIncludingTaxDelivery != null) {
//                       if (first) {
//                         for (int i = 0; i < int.parse(snapshot.data.data.cartItemCount); i++) {
//                           _productAmount.add(int.parse(snapshot.data.data.cartItems[i].quantity));
//                           // print("product amount $index ${_productAmount[index]}");
//                           _outOfStockVisibility.add(false);
//                           _deleteVisibility.add(false);
//                           _moreLessVisibility.add(true);
//                           // if(snapshot.data.data.cartItems[i].isOutOfStock == "1") notAvailableCount += 1;
//                         }
//                         first = false;
//                       }
//                       notAvailableCount = 0;
//                       // if(index1==2){
//                       //   print("index set $index1");
//                       //   _productAmount.clear();
//                       //   print(_productAmount.length);
//                       //   _outOfStockVisibility.clear();
//                       //   _deleteVisibility.clear();
//                       //   _moreLessVisibility.clear();
//                       //   index1=0;
//                       // }
//                       if (indexCheck) {
//                         print("hit delete");
//                         _productAmount.removeAt(index2);
//                         // print("product amount $index2 ${_productAmount[index2]}");
//                         _outOfStockVisibility.removeAt(index2);
//                         _deleteVisibility.removeAt(index2);
//                         _moreLessVisibility.removeAt(index2);
//                         // index1=2;
//                         print("index change $index2");
//                         indexCheck = false;
//                       }
//                       managedSharedPref(snapshot.data);
//                       return ListView(
//                         shrinkWrap: true,
//                         physics: ScrollPhysics(),
//                         children: [
//                           ListView.builder(
//                               itemCount: int.parse(snapshot.data.data.cartItemCount),
//                               physics: ScrollPhysics(),
//                               shrinkWrap: true,
//                               itemBuilder: (context, index) {
//                                 if (snapshot.data.data.cartItems[index].isOutOfStock == "1") {
//                                   _productAmount[index] = 0;
//                                   print("product amount in builder $index ${_productAmount[index]}");
//                                   _outOfStockVisibility[index] = true;
//                                   _deleteVisibility[index] = true;
//                                   _moreLessVisibility[index] = false;
//                                   notAvailableCount += 1;
//                                 } else {
//                                   // _productAmount[index]=int.parse(snapshot.data.data.cartItems[index].quantity);
//
//                                   print("product amount in builder $index ${_productAmount[index]}");
//                                   _outOfStockVisibility[index] = false;
//                                   _deleteVisibility[index] = false;
//                                   _moreLessVisibility[index] = true;
//                                 }
//                                 return Container(
//                                   margin: EdgeInsets.all(6.0),
//                                   padding: EdgeInsets.all(5.0),
//                                   decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)), color: Colors.white),
//                                   // height: screenHeight * .14,
//                                   child: Row(children: [
//                                     Expanded(
//                                       flex: 2,
//                                       child: Container(
//                                         height: screenWidth * 0.2,
//                                         // width: screenWidth * 0.20,
//                                         // height: double.infinity,
//                                         clipBehavior: Clip.hardEdge,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.all(Radius.circular(12.0)),
//                                         ),
//                                         child: FadeInImage(
//                                           image: NetworkImage(
//                                             "$imageBaseURL${snapshot.data.data.cartItems[index].detailedProductImages}",
//                                           ),
//                                           placeholder: AssetImage("assets/images/placeHolder/square_white.png"),
//                                           fit: BoxFit.fill,
//                                         ),
//                                       ),
//                                     ),
//                                     Expanded(
//                                       flex: 7,
//                                       child: Container(
//                                         // color: Colors.red,
//                                         // padding: EdgeInsets.only(
//                                         //     left: screenWidth * .03,
//                                         //     top: screenHeight * .020,
//                                         //     bottom: screenHeight * .016),
//                                         margin: EdgeInsets.only(left: 15.0, top: 0.0, bottom: 0.0, right: 10.0),
//                                         // color: Colors.blue,
//                                         height: screenHeight * .1,
//                                         // width: screenWidth * .68,
//                                         child: Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           mainAxisAlignment: MainAxisAlignment.start,
//                                           children: [
//                                             Expanded(
//                                               flex: 3,
//                                               child: Row(
//                                                 children: [
//                                                   Expanded(
//                                                     flex: 8,
//                                                     child: Text(
//                                                       "${snapshot.data.data.cartItems[index].skuName}",
//                                                       overflow: TextOverflow.fade,
//                                                       style: TextStyle(
//                                                           fontSize: screenWidth * .04, fontWeight: FontWeight.bold, fontFamily: 'pop'),
//                                                     ),
//                                                   ),
//                                                   Expanded(
//                                                     flex: 1,
//                                                     child: Visibility(
//                                                       visible: _deleteVisibility[index],
//                                                       child: InkWell(
//                                                         onTap: () {
//                                                           // int _quantity=_productAmount[index]-1;
//
//                                                           Map body = {
//                                                             "cart_item_id": "${snapshot.data.data.cartItems[index].cartItemId}",
//                                                             "quantity": "0"
//                                                           };
//
//                                                           //for product delete
//                                                           _cartItemsUpdateBloc.cartItemsUpdate(body);
//                                                           setState(() {
//                                                             // _productAmount[index]--;
//                                                             index2 = index;
//                                                             indexCheckStream = true;
//                                                             cartChangeCheck = true;
//                                                           });
//                                                         },
//                                                         child: Icon(
//                                                           Icons.delete_forever_outlined,
//                                                           size: 25,
//                                                           color: Colors.red[900],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                             Expanded(
//                                               flex: 2,
//                                               child: Row(
//                                                 children: [
//                                                   Text(
//                                                     "RS. ${snapshot.data.data.cartItems[index].totalprice}",
//                                                     style: TextStyle(
//                                                         fontSize: screenWidth * .036,
//                                                         fontWeight: FontWeight.bold,
//                                                         color: Colors.deepOrange,
//                                                         fontFamily: 'pop'),
//                                                   ),
//                                                   Spacer(),
//                                                   Visibility(
//                                                     visible: _outOfStockVisibility[index],
//                                                     child: Container(
//                                                       // width: 60,
//                                                       padding: EdgeInsets.all(3),
//                                                       decoration: BoxDecoration(
//                                                           border: Border.all(
//                                                             color: Colors.black54,
//                                                           ),
//                                                           borderRadius: BorderRadius.all(Radius.circular(5))),
//                                                       child: Text(
//                                                         "OUT OF STOCK",
//                                                         textAlign: TextAlign.center,
//                                                         style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10, color: Colors.black54),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Visibility(
//                                                     visible: _moreLessVisibility[index],
//                                                     child: Row(
//                                                       children: [
//                                                         InkWell(
//                                                           onTap: () {
//                                                             int _quantity = _productAmount[index] - 1;
//
//                                                             if (_quantity > -1) {
//                                                               Map body = {
//                                                                 "cart_item_id": "${snapshot.data.data.cartItems[index].cartItemId}",
//                                                                 "quantity": "$_quantity"
//                                                               };
//                                                               _cartItemsUpdateBloc.cartItemsUpdate(body);
//                                                               if (_quantity == 0) {
//                                                                 index2 = index;
//                                                                 indexCheckStream = true;
//                                                               }
//                                                               _productAmount[index]--;
//                                                               cartChangeCheck = true;
//                                                               setState(() {});
//                                                             }
//                                                           },
//                                                           child: Icon(
//                                                             Icons.remove_circle_outline,
//                                                             color: Colors.deepOrange,
//                                                             size: screenWidth * .07,
//                                                           ),
//                                                         ),
//                                                         SizedBox(width: screenWidth * .007),
//                                                         Center(
//                                                             child: Text(
//                                                           "${_productAmount[index]}",
//                                                           style: TextStyle(fontSize: screenWidth * .04, fontFamily: 'pop'),
//                                                         )),
//                                                         SizedBox(width: screenWidth * .007),
//                                                         InkWell(
//                                                           onTap: () {
//                                                             int _quantity = _productAmount[index] + 1;
//
//                                                             Map body = {
//                                                               "cart_item_id": "${snapshot.data.data.cartItems[index].cartItemId}",
//                                                               "quantity": "$_quantity"
//                                                             };
//                                                             _cartItemsUpdateBloc.cartItemsUpdate(body);
//                                                             _productAmount[index]++;
//                                                             cartChangeCheck = true;
//                                                             setState(() {});
//                                                           },
//                                                           child: Icon(
//                                                             Icons.add_circle_outline,
//                                                             color: Colors.deepOrange,
//                                                             size: screenWidth * .07,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ]),
//                                 );
//                               }),
//                           (coupon_code == "")
//                               ? Padding(
//                                   padding: EdgeInsets.only(top: screenHeight * .16, right: 5, left: 5),
//                                   child: InkWell(
//                                     onTap: () {
//                                       (_userToken != "")
//                                           ? Navigator.push(context, MaterialPageRoute(builder: (context) => PromoCodePage()))
//                                           : Fluttertoast.showToast(
//                                               msg: "Please Login First to apply Coupon",
//                                               fontSize: 16,
//                                               backgroundColor: Colors.white,
//                                               textColor: darkThemeBlue,
//                                               toastLength: Toast.LENGTH_LONG);
//                                     },
//                                     child: Container(
//                                       padding: EdgeInsets.all(15),
//                                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.redAccent[400]),
//                                       width: screenWidth * .92,
//                                       height: 50,
//                                       child: Row(
//                                         children: [
//                                           Icon(
//                                             Icons.local_offer,
//                                             color: Colors.white,
//                                             size: screenWidth * 0.05,
//                                           ),
//                                           SizedBox(
//                                             width: screenWidth * 0.03,
//                                           ),
//                                           Text(
//                                             "Add Promo Code",
//                                             style:
//                                                 TextStyle(color: Colors.white, fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
//                                           ),
//                                           Spacer(),
//                                           Icon(Icons.keyboard_arrow_right, color: Colors.white, size: screenWidth * 0.05),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               : Padding(
//                                   padding: EdgeInsets.only(top: screenHeight * .16, right: 5, left: 5),
//                                   child: Container(
//                                     padding: EdgeInsets.only(left: 15, right: 5, top: 1, bottom: 1),
//                                     decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.white),
//                                     width: screenWidth * .92,
//                                     height: 50,
//                                     child: Row(
//                                       children: [
//                                         Icon(
//                                           Icons.local_offer,
//                                           color: Colors.deepOrange,
//                                           size: screenWidth * 0.05,
//                                         ),
//                                         SizedBox(
//                                           width: screenWidth * 0.03,
//                                         ),
//                                         Column(
//                                           mainAxisSize: MainAxisSize.min,
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "1 Coupon Applied",
//                                               style:
//                                                   TextStyle(color: Colors.black, fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500),
//                                             ),
//                                             Padding(
//                                               padding: const EdgeInsets.only(top: 2.0),
//                                               child: Text(
//                                                 " $coupon_code".toUpperCase(),
//                                                 style: TextStyle(
//                                                     color: Colors.green[500], fontSize: screenWidth * 0.04, fontWeight: FontWeight.w600),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         Spacer(),
//                                         IconButton(
//                                           onPressed: () {
//                                             prefs.setString("coupon_code", "");
//                                             // Future.delayed(Duration.zero, (){
//                                             //   _body={
//                                             //     "cartid": cart_id,
//                                             //     "userid": user_id,
//                                             //     "coupon_code": coupon_code
//                                             //   };
//                                             //   _cartApi=_cartRepository.cartItemsDetails(_body);
//                                             //   setState(() {
//                                             //   });
//                                             // });
//
//                                             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CartPage()));
//                                             Fluttertoast.showToast(
//                                                 msg: "Coupon Code Cleared Successfully",
//                                                 fontSize: 16,
//                                                 backgroundColor: Colors.white,
//                                                 textColor: darkThemeBlue,
//                                                 toastLength: Toast.LENGTH_LONG);
//                                           },
//                                           icon: Icon(Icons.cancel, color: Colors.red[800], size: 28),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                           Padding(
//                             padding: EdgeInsets.only(top: screenHeight * .02, right: 5, left: 5),
//                             child: Container(
//                               padding: EdgeInsets.all(screenWidth * .03),
//                               decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)), color: Colors.white),
//                               width: screenWidth * .94,
//                               // height: screenHeight * .25,
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.fromLTRB(1.0, 5.0, 1.0, 5.0),
//                                     child: Row(
//                                       children: [
//                                         Text(
//                                           "Total Amount",
//                                           style: TextStyle(
//                                             fontSize: screenWidth * 0.04,
//                                             color: Colors.black54,
//                                           ),
//                                         ),
//                                         Spacer(),
//                                         Text(
//                                           "₹${snapshot.data.data.cartTotalAmount}",
//                                           style: TextStyle(fontWeight: FontWeight.w400, fontSize: screenWidth * 0.04, color: Colors.black),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   (snapshot.data.data.totalAfterDiscount != null)
//                                       ? Padding(
//                                           padding: const EdgeInsets.fromLTRB(1.0, 5.0, 1.0, 5.0),
//                                           child: Row(
//                                             children: [
//                                               Text(
//                                                 "Discount Amount",
//                                                 style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.black54),
//                                               ),
//                                               Spacer(),
//                                               Text(
//                                                 "[ - ] ₹${(double.parse(snapshot.data.data.cartTotalAmount) - double.parse(snapshot.data.data.totalAfterDiscount.replaceAll(",", ""))).toStringAsFixed(2)}",
//                                                 style: TextStyle(
//                                                     fontWeight: FontWeight.w400, fontSize: screenWidth * 0.04, color: Colors.green),
//                                               )
//                                             ],
//                                           ),
//                                         )
//                                       : Container(),
//                                   (snapshot.data.data.totalAfterDiscount != null)
//                                       ? Column(
//                                         children: [
//                                           Divider(
//                                             thickness: 1,
//                                           ),
//                                           Padding(
//                                               padding: const EdgeInsets.fromLTRB(1.0, 5.0, 1.0, 5.0),
//                                               child: Row(
//                                                 children: [
//                                                   Text(
//                                                     "Amount After Discount",
//                                                     style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.black54),
//                                                   ),
//                                                   Spacer(),
//                                                   Text(
//                                                     "₹${snapshot.data.data.totalAfterDiscount}",
//                                                     style: TextStyle(
//                                                         fontWeight: FontWeight.w400, fontSize: screenWidth * 0.04, color: Colors.black),
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                         ],
//                                       )
//                                       : Container(),
//                                   (snapshot.data.data.packingCharges =="0.00")?
//                                   Padding(
//                                     padding: const EdgeInsets.fromLTRB(1.0, 5.0, 1.0, 5.0),
//                                     child: Row(
//                                       children: [
//                                         Text(
//                                           "Packaging charge",
//                                           style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.black54),
//                                         ),
//                                         Spacer(),
//                                         Text(
//                                           "₹${snapshot.data.data.packingCharges}",
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.w400, fontSize: screenWidth * 0.04, color: Colors.black),
//                                         )
//                                       ],
//                                     ),
//                                   )
//                                       :Container(),
//
//                                   (snapshot.data.data.orderSurcharge ==0)?
//                                   Padding(
//                                     padding: const EdgeInsets.fromLTRB(1.0, 5.0, 1.0, 5.0),
//                                     child: Row(
//                                       children: [
//                                         Text(
//                                           "Order surcharge",
//                                           style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.black54),
//                                         ),
//                                         Spacer(),
//                                         Text(
//                                           "₹${snapshot.data.data.orderSurcharge}",
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.w400, fontSize: screenWidth * 0.04, color: Colors.black),
//                                         )
//                                       ],
//                                     ),
//                                   )
//                                       :Container(),
//
//
//                                   Padding(
//                                     padding: const EdgeInsets.fromLTRB(1.0, 5.0, 1.0, 5.0),
//                                     child: Row(
//                                       children: [
//                                         Text(
//                                           "GST (${snapshot.data.data.gst}%)",
//                                           style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.black54),
//                                         ),
//                                         Spacer(),
//                                         Text(
//                                           "₹${snapshot.data.data.taxAmount}",
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.w400, fontSize: screenWidth * 0.04, color: Colors.black),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.fromLTRB(1.0, 5.0, 1.0, 5.0),
//                                     child: Row(
//                                       children: [
//                                         Text(
//                                           "Delivery partner fee",
//                                           style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.black54),
//                                         ),
//                                         Spacer(),
//                                         Text(
//                                           "₹${snapshot.data.data.deliveryFee}",
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.w400, fontSize: screenWidth * 0.04, color: Colors.black),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   Divider(
//                                     thickness: 1,
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.fromLTRB(1.0, 5.0, 1.0, 5.0),
//                                     child: Row(
//                                       children: [
//                                         Text(
//                                           "Total Amount + Charges",
//                                           style: TextStyle(
//                                             fontSize: screenWidth * 0.04,
//                                             color: Colors.black54,
//                                             fontWeight: FontWeight.w500
//                                           ),
//                                         ),
//                                         Spacer(),
//                                         Text(
//                                           "₹${snapshot.data.data.totalIncludingTaxDelivery}",
//                                           style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth * 0.04, color: Colors.black),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(top: screenHeight * .02, right: 5, left: 5),
//                             child: InkWell(
//                               onTap: () {
//                                 if (_userToken == "") {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => LoginByMobilePage(
//                                                 cartId: cart_id,
//                                               )));
//                                   Fluttertoast.showToast(
//                                       msg: "Please Login First",
//                                       fontSize: 16,
//                                       backgroundColor: Colors.white,
//                                       textColor: darkThemeBlue,
//                                       toastLength: Toast.LENGTH_LONG);
//                                 } else if (notAvailableCount > 0) {
//                                   Fluttertoast.showToast(
//                                       msg: "Please Remove OUT OF STOCK Product to Proceed",
//                                       fontSize: 16,
//                                       backgroundColor: Colors.white,
//                                       textColor: darkThemeBlue,
//                                       toastLength: Toast.LENGTH_LONG);
//                                 } else {
//                                   if (name == "") {
//                                     print("hiii");
//                                     modalSheet();
//                                     // _modalBottomSheetMenu();
//                                   } else
//                                     // Navigator.of(context).pushNamedAndRemoveUntil('/orderDetails', ModalRoute.withName('/home'));
//                                     Navigator.push(context, MaterialPageRoute(builder: (context) => AddressListPage()));
//                                 }
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.all(screenWidth * .025),
//                                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: orangeCol),
//                                 width: screenWidth * .94,
//                                 height: 70,
//                                 child: Row(
//                                   children: [
//                                     Column(
//                                       children: [
//                                         Expanded(
//                                           flex: 1,
//                                           child: Text(
//                                             " Total Amount",
//                                             style: TextStyle(color: Colors.white, fontSize: 16),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           flex: 1,
//                                           child: Text(
//                                             "Rs.${snapshot.data.data.totalIncludingTaxDelivery}",
//                                             style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                     Spacer(),
//                                     Row(
//                                       children: [
//                                         Padding(
//                                           padding: EdgeInsets.only(top: 0.0),
//                                           child: Text(
//                                             "Checkout",
//                                             style: TextStyle(color: Colors.white, fontSize: 16),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: EdgeInsets.only(right: 10.0),
//                                           child: Icon(
//                                             Icons.arrow_forward,
//                                             color: Colors.white,
//                                             size: 18,
//                                           ),
//                                         )
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: screenHeight * .1)
//                         ],
//                       );
//                     } else {
//                       return Column(
//                         children: [
//                           Container(
//                               margin: EdgeInsets.fromLTRB(15, 15, 10, 30),
//                               alignment: Alignment.topLeft,
//                               child: Text(
//                                 "".toUpperCase(),
//                                 // textAlign: TextAlign.start,
//                                 style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14.0),
//                               )),
//                           Image.asset(
//                             "assets/images/cart.png",
//                             height: 150.0,
//                           ),
//                           SizedBox(
//                             height: 16,
//                           ),
//                           Text(
//                             "You Don't Have Any Item in Your Cart",
//                             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0),
//                           )
//                         ],
//                       );
//                     }
//                   } else if (snapshot.hasError) {
//                     print(snapshot.error);
//                     return Text("No Data Found");
//                   } else if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(
//                       heightFactor: 5,
//                       widthFactor: 10,
//                       child: CircularProgressIndicator(
//                           backgroundColor: circularBGCol,
//                           strokeWidth: strokeWidth,
//                           valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol)),
//                     );
//                   } else
//                     return Container();
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   modalSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(15.0),
//         ),
//       ),
//       builder: (BuildContext context) {
//         return Padding(
//           padding: const EdgeInsets.all(18.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Text(
//                   "Please Save Your Name to Proceed",
//                   style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
//                 ),
//                 SizedBox(
//                   height: 6.0,
//                 ),
//                 Theme(
//                   data: new ThemeData(
//                     primaryColor: orangeCol,
//                     primaryColorDark: Colors.black,
//                   ),
//                   child: TextFormField(
//                     validator: (value) => value.isEmpty ? "*Name Required" : null,
//                     controller: _nameController,
//                     decoration: new InputDecoration(
//                         labelText: "Full Name",
//                         labelStyle: GoogleFonts.poppins(fontSize: 14.0, color: Colors.black54, fontWeight: FontWeight.w400),
//                         fillColor: Colors.white,
//                         focusColor: orangeCol,
//                         hoverColor: orangeCol),
//                     keyboardType: TextInputType.name,
//                     textInputAction: TextInputAction.done,
//                     style: GoogleFonts.poppins(fontSize: 13.0, color: orangeCol, fontWeight: FontWeight.w500),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 16.0,
//                 ),
//                 InkWell(
//                   onTap: () {
//                     final FormState form = _formKey.currentState;
//                     if (form.validate()) {
//                       print('Form is valid');
//                       File imageFile1;
//                       Map body;
//                       {
//                         body = {"name": "${_nameController.text.trim()}", "user_id": "$user_id"};
//                         updateCheck = true;
//                         _profileUpdateBloc.profileUpdate(body, imageFile1, _userToken);
//                       }
//                     } else {
//                       print('Form is invalid');
//                     }
//                   },
//                   child: Container(
//                     height: 40.0,
//                     width: MediaQuery.of(context).size.width,
//                     // margin: EdgeInsets.all(2),
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         boxShadow: <BoxShadow>[
//                           BoxShadow(
//                               color: Colors.white70,
//                               // offset: Offset(2, 4),
//                               blurRadius: 5,
//                               spreadRadius: 2)
//                         ],
//                         gradient: LinearGradient(
//                             begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color(0xffeb8a35), Color(0xffe36126)])),
//                     child: StreamBuilder<ApiResponse<ProfileUpdateModel>>(
//                       stream: _profileUpdateBloc.profileUpdateStream,
//                       builder: (context, snapshot) {
//                         if (updateCheck) {
//                           if (snapshot.hasData) {
//                             switch (snapshot.data.status) {
//                               case Status.LOADING:
//                                 return CircularProgressIndicator(
//                                     backgroundColor: circularBGCol,
//                                     strokeWidth: strokeWidth,
//                                     valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol));
//                                 /*Loading(
//                                 loadingMessage: snapshot.data.message,
//                               );*/
//                                 break;
//                               case Status.COMPLETED:
//                                 if (snapshot.data.data.message == "Profile updated successfully") {
//                                   print("complete");
//                                   updateCheck = false;
//                                   prefs.setString("name", "${snapshot.data.data.data.name}");
//                                   name = snapshot.data.data.data.name;
//                                   navToAttachList(context);
//                                   Fluttertoast.showToast(
//                                       msg: "Profile Updated",
//                                       fontSize: 16,
//                                       backgroundColor: Colors.white,
//                                       textColor: darkThemeBlue,
//                                       toastLength: Toast.LENGTH_SHORT);
//                                 } else {
//                                   Fluttertoast.showToast(
//                                       msg: "${snapshot.data.data.message}",
//                                       fontSize: 16,
//                                       backgroundColor: Colors.white,
//                                       textColor: darkThemeBlue,
//                                       toastLength: Toast.LENGTH_LONG);
//                                 }
//                                 break;
//                               case Status.ERROR:
//                                 print(snapshot.error);
//                                 updateCheck = false;
//                                 Fluttertoast.showToast(
//                                     msg: "Please try again!",
//                                     fontSize: 16,
//                                     backgroundColor: Colors.orange[100],
//                                     textColor: darkThemeBlue,
//                                     toastLength: Toast.LENGTH_LONG);
//                                 //   Error(
//                                 //   errorMessage: snapshot.data.message,
//                                 // );
//                                 break;
//                             }
//                           } else if (snapshot.hasError) {
//                             updateCheck = false;
//                             print(snapshot.error);
//                             Fluttertoast.showToast(
//                                 msg: "Please try again!",
//                                 fontSize: 16,
//                                 backgroundColor: Colors.orange[100],
//                                 textColor: darkThemeBlue,
//                                 toastLength: Toast.LENGTH_LONG);
//                           }
//                         }
//                         return Text(
//                           'Continue',
//                           style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
