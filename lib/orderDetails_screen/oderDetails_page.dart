// import 'package:delivery_on_time/constants.dart';
// import 'package:delivery_on_time/orderDetails_screen/model/orderDetailsModel.dart';
// import 'package:delivery_on_time/orderDetails_screen/repository/orderDetailsRepository.dart';
// import 'package:delivery_on_time/orderPlace_paymennt/repository/orderPlaceRepository.dart';
// import 'package:delivery_on_time/tracking_screen/mapTrackingPage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/intl.dart';
//
//
// class OrderDetailsPage extends StatefulWidget {
//   @override
//   _OrderDetailsPageState createState() => _OrderDetailsPageState();
// }
//
// class _OrderDetailsPageState extends State<OrderDetailsPage> {
//
//   SharedPreferences prefs;
//   String userToken="";
//   String userId="";
//   OrderDetailsRepository _orderDetailsRepository;
//   Future<OrderDetailsModel> _orderDetailsApi;
//   Map _body;
//   var statusCol;
//
//   Future<void> createSharedPref() async {
//     prefs = await SharedPreferences.getInstance();
//     userToken=prefs.getString("user_token");
//     userId=prefs.getString("user_id");
//     _body={
//       "userid":"$userId"
//     };
//     _orderDetailsRepository=new OrderDetailsRepository();
//     _orderDetailsApi=_orderDetailsRepository.orderDetails(_body, userToken);
//     setState(() {
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     createSharedPref();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: darkThemeBlue,
//         appBar: AppBar(
//             backgroundColor: lightThemeBlue,
//             leading: IconButton(
//               onPressed: (){
//                 Navigator.pop(context);
//               },
//                 icon: Icon(
//                   Icons.arrow_back,
//                   color: Colors.white,
//                 )),
//             title: Center(
//                 child: Text(
//                   "Order Details",
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: screenWidth * 0.045),
//                 )),
//             actions: <Widget>[
//               IconButton(
//                 icon: Icon(
//                   Icons.notifications,
//                   color: Colors.white,
//                 ),
//               ),
//             ]),
//         body: ListView(
//           physics: ScrollPhysics(),
//           shrinkWrap: true,
//           children: [
//             FutureBuilder<OrderDetailsModel>(
//               future: _orderDetailsApi,
//               builder: (context,snapshot){
//                 if(snapshot.hasData){
//                   return ListView.builder(
//                     shrinkWrap: true,
//                     physics: ScrollPhysics(),
//                     itemCount: snapshot.data.data.length,
//                     reverse: true,
//                     itemBuilder: (context, index){
//                       if(snapshot.data.data[index].transactionStatus=="Pending"){
//                         statusCol=Colors.red;
//                       }else{
//                         statusCol=Colors.green;
//                       }
//                       return InkWell(
//                         onTap: (){
//                           print(snapshot.data.data[index].transactionId);
//                           // Navigator.push(
//                           //     context,
//                           //     MaterialPageRoute(
//                           //         builder: (context) => MapTrackingPage(orderDetailsData: snapshot.data.data[index])));
//                         },
//
//                         child: Container(
//                           clipBehavior: Clip.hardEdge,
//                           // height: screenHeight*0.17,
//                           width: screenWidth,
//                           decoration: BoxDecoration(
//                             // color: lightThemeBlue,
//                               border: Border.all(
//                                   color: Colors.deepOrange,
//                                   width: 1.5
//                               ),
//                               borderRadius: BorderRadius.all(Radius.circular(17))),
//                           margin: EdgeInsets.fromLTRB(10.0,7.0,10.0,4.0),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                   flex: 0,
//                                   child: Container(),
//                               ),
//                               Expanded(
//                                 flex: 7,
//                                 child: Container(
//                                   color: Colors.white,
//                                   child: Row(
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(height: 100, child: VerticalDivider(color: Colors.black,thickness: 1.0,)),
//                                       ),
//                                       Expanded(
//                                           flex: 8,
//                                           child: Container(
//                                               padding: EdgeInsets.fromLTRB(0.0,5.0,5.0,5.0),
//                                               child: Center(
//                                                 child: Column(
//                                                   mainAxisSize: MainAxisSize.min,
//                                                   mainAxisAlignment: MainAxisAlignment.center,
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//                                                     Flexible(
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.only(top: 3.0),
//                                                         child: RichText(    // To Make Different Text Color in single line
//                                                           text: TextSpan(
//                                                               text: "ORDER ID : ",
//                                                               style: TextStyle(
//                                                                   color: orangeCol,
//                                                                   fontSize: 12,
//                                                                   fontWeight: FontWeight.w600
//                                                               ),
//                                                               children: [
//                                                                 TextSpan(
//                                                                   text: "${snapshot.data.data[index].id}",
//                                                                   style: TextStyle(
//                                                                       color: darkThemeBlue,
//                                                                       fontSize: 12,
//                                                                       fontWeight: FontWeight.w400
//                                                                   ),
//                                                                 ),
//                                                               ]
//                                                           ),
//                                                         ),
//
//                                                       ),
//                                                     ),
//
//                                                     Flexible(
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.only(top: 3.0),
//                                                         child: RichText(    // To Make Different Text Color in single line
//                                                           text: TextSpan(
//                                                               text: "Restaurant Name : ".toUpperCase(),
//                                                               style: TextStyle(
//                                                                   color: orangeCol,
//                                                                   fontSize: 12,
//                                                                   fontWeight: FontWeight.w600
//                                                               ),
//                                                               children: [
//                                                                 TextSpan(
//                                                                   text: "${snapshot.data.data[index].vendorId}",
//                                                                   style: TextStyle(
//                                                                       color: darkThemeBlue,
//                                                                       fontSize: 12,
//                                                                       fontWeight: FontWeight.w400
//                                                                   ),
//                                                                 ),
//                                                               ]
//                                                           ),
//                                                         ),
//
//                                                       ),
//                                                     ),
//
//                                                     Flexible(
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.only(top: 3.0),
//                                                         child: RichText(    // To Make Different Text Color in single line
//                                                           text: TextSpan(
//                                                               text: "Restaurant Number : ".toUpperCase(),
//                                                               style: TextStyle(
//                                                                   color: orangeCol,
//                                                                   fontSize: 12,
//                                                                   fontWeight: FontWeight.w600
//                                                               ),
//                                                               children: [
//                                                                 TextSpan(
//                                                                   text: "",
//                                                                   style: TextStyle(
//                                                                       color: darkThemeBlue,
//                                                                       fontSize: 12,
//                                                                       fontWeight: FontWeight.w400
//                                                                   ),
//                                                                 ),
//                                                               ]
//                                                           ),
//                                                         ),
//
//                                                       ),
//                                                     ),
//
//                                                     Flexible(
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.only(top: 3.0),
//                                                         child: RichText(    // To Make Different Text Color in single line
//                                                           text: TextSpan(
//                                                               text: "Biker Mobile Number. : ".toUpperCase(),
//                                                               style: TextStyle(
//                                                                   color: orangeCol,
//                                                                   fontSize: 12,
//                                                                   fontWeight: FontWeight.w600
//                                                               ),
//                                                               children: [
//                                                                 TextSpan(
//                                                                   text: "",
//                                                                   style: TextStyle(
//                                                                       color: darkThemeBlue,
//                                                                       fontSize: 12,
//                                                                       fontWeight: FontWeight.w400
//                                                                   ),
//                                                                 ),
//                                                               ]
//                                                           ),
//                                                         ),
//
//                                                       ),
//                                                     ),
//
//                                                     Flexible(
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.only(top: 3.0),
//                                                         child: RichText(    // To Make Different Text Color in single line
//                                                           text: TextSpan(
//                                                               text: "Delivery Address : ".toUpperCase(),
//                                                               style: TextStyle(
//                                                                   color: orangeCol,
//                                                                   fontSize: 12,
//                                                                   fontWeight: FontWeight.w600
//                                                               ),
//                                                               children: [
//                                                                 TextSpan(
//                                                                   text: "${snapshot.data.data[index].deliveryAddress}",
//                                                                   style: TextStyle(
//                                                                       color: darkThemeBlue,
//                                                                       fontSize: 12,
//                                                                       fontWeight: FontWeight.w400
//                                                                   ),
//                                                                 ),
//                                                               ]
//                                                           ),
//                                                         ),
//
//                                                       ),
//                                                     ),
//
//                                                     Flexible(
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.only(top: 3.0),
//                                                         child: RichText(    // To Make Different Text Color in single line
//                                                           text: TextSpan(
//                                                               text: "Expected Delivery Time : ".toUpperCase(),
//                                                               style: TextStyle(
//                                                                   color: orangeCol,
//                                                                   fontSize: 12,
//                                                                   fontWeight: FontWeight.w600
//                                                               ),
//                                                               children: [
//                                                                 TextSpan(
//                                                                   text: "",
//                                                                   style: TextStyle(
//                                                                       color: darkThemeBlue,
//                                                                       fontSize: 12,
//                                                                       fontWeight: FontWeight.w400
//                                                                   ),
//                                                                 ),
//                                                               ]
//                                                           ),
//                                                         ),
//
//                                                       ),
//                                                     ),
//
//                                                     Flexible(
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.only(top: 3.0),
//                                                         child: RichText(    // To Make Different Text Color in single line
//                                                           text: TextSpan(
//                                                               text: "Order Date : ".toUpperCase(),
//                                                               style: TextStyle(
//                                                                   color: orangeCol,
//                                                                   fontSize: 12,
//                                                                   fontWeight: FontWeight.w600
//                                                               ),
//                                                               children: [
//                                                                 TextSpan(
//                                                                   text: "${DateFormat.yMMMMEEEEd().format(DateFormat("yyyy-MM-dd").parse(snapshot.data.data[index].createdAt, true))}",
//                                                                   style: TextStyle(
//                                                                       color: darkThemeBlue,
//                                                                       fontSize: 12,
//                                                                       fontWeight: FontWeight.w400
//                                                                   ),
//                                                                 ),
//                                                               ]
//                                                           ),
//                                                         ),
//
//                                                       ),
//                                                     ),
//
//                                                     Flexible(
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.only(top: 3.0),
//                                                         child: RichText(    // To Make Different Text Color in single line
//                                                           text: TextSpan(
//                                                               text: "Transaction Status : ".toUpperCase(),
//                                                               style: TextStyle(
//                                                                   color: orangeCol,
//                                                                   fontSize: 12,
//                                                                   fontWeight: FontWeight.w600
//                                                               ),
//                                                               children: [
//                                                                 TextSpan(
//                                                                   text: "${snapshot.data.data[index].transactionStatus}",
//                                                                   style: TextStyle(
//                                                                       color: statusCol,
//                                                                       fontSize: 12,
//                                                                       fontWeight: FontWeight.w600
//                                                                   ),
//                                                                 ),
//                                                               ]
//                                                           ),
//                                                         ),
//
//                                                       ),
//                                                     ),
//
//                                                   ],
//                                                 ),
//                                               )
//                                           )
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//
//                   );
//                 } else if (snapshot.hasError) {
//                   return Text("No Data Found");
//                 } else{
//                   return Center(
//                     heightFactor: 5,
//                     widthFactor: 10,
//                     child: CircularProgressIndicator(
//                         backgroundColor: circularBGCol,
//                         strokeWidth: strokeWidth,
//                         valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol)
//                     ),
//                   );}
//               },
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
