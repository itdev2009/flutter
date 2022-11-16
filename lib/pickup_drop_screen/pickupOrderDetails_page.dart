// import 'package:delivery_on_time/constants.dart';
// import 'package:delivery_on_time/pickup_drop_screen/model/pickupDropShowModel.dart';
// import 'package:delivery_on_time/pickup_drop_screen/repository/pickupDropRepository.dart';
// import 'package:delivery_on_time/tracking_screen/mapTrackingPickUpDropPage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/intl.dart';
//
// class PickupOrderDetailsPage extends StatefulWidget {
//   @override
//   _OrderDetailsPageState createState() => _OrderDetailsPageState();
// }
//
// class _OrderDetailsPageState extends State<PickupOrderDetailsPage> {
//
//   SharedPreferences prefs;
//   String userToken="";
//   String userId="";
//   PickupDropRepository _pickupDropRepository;
//   Future<PickupDropShowModel> _pickupDropShowApi;
//   Map _body;
//   var statusCol;
//   String regex = " at:(\\d{4}-\\d{2}-\\d{2}) Notes:";
//
//   Future<void> createSharedPref() async {
//     prefs = await SharedPreferences.getInstance();
//     userToken=prefs.getString("user_token");
//     userId=prefs.getString("user_id");
//     _pickupDropRepository=new PickupDropRepository();
//     _pickupDropShowApi=_pickupDropRepository.pickupDropShowAll(userToken);
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
//                   "Pickup Drop Order Details",
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
//                   size: 0,
//                 ),
//               ),
//             ]),
//         body: ListView(
//           physics: ScrollPhysics(),
//           shrinkWrap: true,
//           children: [
//             FutureBuilder<PickupDropShowModel>(
//               future: _pickupDropShowApi,
//               builder: (context,snapshot){
//                 if(snapshot.hasData){
//                   return ListView.builder(
//                     shrinkWrap: true,
//                     physics: ScrollPhysics(),
//                     itemCount: snapshot.data.data.length,
//                     reverse: true,
//                     itemBuilder: (context, index){
//
//                       if(snapshot.data.data[index].status=="ASSIGNED"){
//                         statusCol=Colors.orangeAccent;
//                       }else if(snapshot.data.data[index].status=="DELIVERED"){
//                         statusCol=Colors.green;
//                       }else if(snapshot.data.data[index].status=="PENDING"){
//                         statusCol=Colors.red[900];
//                       }else if(snapshot.data.data[index].status=="IN_TRANSIT"){
//                         statusCol=Colors.teal[600];
//                       }
//                       return InkWell(
//                         onTap: (){
//                           if(snapshot.data.data[index].status=="IN_TRANSIT"){
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => MapTrackingPickUpDropPage(pickUpDropData: snapshot.data.data[index],carrierId:snapshot.data.data[index].carrierId,userToken: userToken,)));
//                           }
//                         },
//
//                         child: Container(
//                           clipBehavior: Clip.hardEdge,
//                           // height: screenHeight*0.17,
//                           width: screenWidth,
//                           decoration: BoxDecoration(
//                               // color: lightThemeBlue,
//                             border: Border.all(
//                               color: Colors.deepOrange,
//                               width: 1.5
//                             ),
//                           borderRadius: BorderRadius.all(Radius.circular(17))),
//                           margin: EdgeInsets.fromLTRB(10.0,7.0,10.0,4.0),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                   flex: 0,
//                                   child: Container(
//                                       /*height: screenHeight*0.17,
//                                       padding: EdgeInsets.all(6.0),
//                                       color: Colors.white70,
//                                       child:Column(
//                                         children: [
//                                           Expanded(
//                                             flex: 1,
//                                             child: Container(
//                                               height: screenWidth*0.1,
//                                               width: screenWidth*0.1,
//                                               decoration: BoxDecoration(
//                                                   border: Border.all(color: Colors.black),
//                                                   // color: lightThemeBlue,
//                                                   borderRadius:
//                                                   BorderRadius.all(Radius.circular(50)),
//                                                   image: DecorationImage(
//                                                       image: AssetImage(
//                                                           "assets/images/placeHolder/square.png"),
//                                                       fit: BoxFit.fill)),
//                                             ),
//                                           ),
//                                           Expanded(
//                                             flex: 1,
//                                             child: Container(
//                                               height: screenWidth*0.1,
//                                               width: screenWidth*0.1,
//                                               decoration: BoxDecoration(
//                                                   border: Border.all(color: Colors.black),
//                                                   // color: lightThemeBlue,
//                                                   borderRadius:
//                                                   BorderRadius.all(Radius.circular(50)),
//                                                   image: DecorationImage(
//                                                       image: AssetImage(
//                                                           "assets/images/placeHolder/square.png"),
//                                                       fit: BoxFit.fill)),
//                                             ),
//                                           ),
//                                         ],
//                                       )*/
//                                   )
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
//                                                               text: "Sender Name : ".toUpperCase(),
//                                                               style: TextStyle(
//                                                                   color: orangeCol,
//                                                                   fontSize: 12,
//                                                                   fontWeight: FontWeight.w600
//                                                               ),
//                                                               children: [
//                                                                 TextSpan(
//                                                                   text: "${snapshot.data.data[index].senderName}",
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
//                                                               text: "sender Address : ".toUpperCase(),
//                                                               style: TextStyle(
//                                                                   color: orangeCol,
//                                                                   fontSize: 12,
//                                                                   fontWeight: FontWeight.w600
//                                                               ),
//                                                               children: [
//                                                                 TextSpan(
//                                                                   text: "${snapshot.data.data[index].senderAddress}",
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
//                                                               text: "Receiver Name : ".toUpperCase(),
//                                                               style: TextStyle(
//                                                                   color: orangeCol,
//                                                                   fontSize: 12,
//                                                                   fontWeight: FontWeight.w600
//                                                               ),
//                                                               children: [
//                                                                 TextSpan(
//                                                                   text: "${snapshot.data.data[index].receiverName}",
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
//                                                               text: "Receiver Mobile No. : ".toUpperCase(),
//                                                               style: TextStyle(
//                                                                   color: orangeCol,
//                                                                   fontSize: 12,
//                                                                   fontWeight: FontWeight.w600
//                                                               ),
//                                                               children: [
//                                                                 TextSpan(
//                                                                   text: "${snapshot.data.data[index].receiverMobile}",
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
//                                                               text: "Receiver Address : ".toUpperCase(),
//                                                               style: TextStyle(
//                                                                   color: orangeCol,
//                                                                   fontSize: 12,
//                                                                   fontWeight: FontWeight.w600
//                                                               ),
//                                                               children: [
//                                                                 TextSpan(
//                                                                   text: "${snapshot.data.data[index].receiverAddress}",
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
//                                                               text: "Status : ".toUpperCase(),
//                                                               style: TextStyle(
//                                                                   color: orangeCol,
//                                                                   fontSize: 12,
//                                                                   fontWeight: FontWeight.w600
//                                                               ),
//                                                               children: [
//                                                                 TextSpan(
//                                                                   text: "${snapshot.data.data[index].status}",
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
