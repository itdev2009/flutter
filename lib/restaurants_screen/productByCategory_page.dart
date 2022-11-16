// import 'package:delivery_on_time/constants.dart';
// import 'package:flutter/material.dart';
//
// class ProductByCategory extends StatefulWidget {
//   @override
//   _ProductByCategoryState createState() => _ProductByCategoryState();
// }
//
// class _ProductByCategoryState extends State<ProductByCategory> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: darkThemeBlue,
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
//                   "Shop Details",
//                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.045),
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
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: ListView(
//             physics: ScrollPhysics(),
//             shrinkWrap: true,
//             children: [
//               Container(
//                 width: screenWidth,
//                 // height: screenHeight * 0.3,
//                 child: Column(
//                   children: [
//                     CarouselSlider.builder(
//                         options: CarouselOptions(
//                             autoPlayInterval: Duration(seconds: 4),
//                             autoPlay: true,
//                             aspectRatio: 2.0,
//                             enlargeCenterPage: true,
//                             enlargeStrategy: CenterPageEnlargeStrategy.height,
//                             autoPlayCurve: Curves.decelerate,
//                             onPageChanged: (index, reason) {
//                               setState(() {
//                                 _current = index;
//                               });
//                             }
//                         ),
//                         itemCount: _foodDetails.detailedProductImages.split(",").length,
//                         itemBuilder: (BuildContext context, int index) {
//                           return Container(
//                             // width: screenWidth,
//                             color: Colors.white,
//                             child: FadeInImage(
//                               width: screenWidth,
//                               // height: screenHeight * 0.3,
//                               image: NetworkImage(
//                                 "$imageBaseURL${_foodDetails.detailedProductImages.split(",")[index]}",
//                               ),
//                               placeholder: AssetImage("assets/images/placeHolder/square_white.png"),
//                               fit: BoxFit.fitHeight,
//                             ),
//                           );
//                         }),
//                     Row(
//                       mainAxisAlignment:
//                       MainAxisAlignment.center,
//                       children: _foodDetails.detailedProductImages.split(",")
//                           .map((url) {
//                         int index = _foodDetails.detailedProductImages.split(",")
//                             .indexOf(url);
//                         return Container(
//                           width: 9.0,
//                           height: 9.0,
//                           margin: EdgeInsets.symmetric(
//                               vertical: 10.0,
//                               horizontal: 2.0),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: _current == index
//                                 ? Colors.orange.shade800
//                                 : Colors.white,
//                           ),
//                         );
//                       }).toList(),
//                     )
//                   ],
//                 ),
//               ),
//
//               SizedBox(
//                 height: 5.0,
//               ),
//
//               Flexible(
//                 child: Text(
//                   "${_foodDetails.skuName}",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
//                 ),
//               ),
//
//               SizedBox(
//                 height: 10.0,
//               ),
//
//               Text(
//                 "All Shops ",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
//               ),
//
//               ListView.builder(
//                   shrinkWrap: true,
//                   physics: ScrollPhysics(),
//                   itemCount: _foodDetails.vendor.length,
//
//                   itemBuilder: (context, index) {
//                     return InkWell(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) =>
//                                     ShopDetail(_foodDetails.vendor[index]
//                                         .categoryId,
//                                         _foodDetails.vendor[index]
//                                             .vendorId,
//                                         _foodDetails.vendor[index]
//                                             .shopName))
//                         );
//                       },
//                       child: Container(
//                           margin: EdgeInsets.all(7.0),
//                           padding: EdgeInsets.all(5.0),
//                           height: screenWidth * 0.27,
//                           // width: screenWidth*0.05,
//                           // height: 100.0,
//                           // color: Colors.white,
//                           decoration: BoxDecoration(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(12.0)),
//                               color: Colors.white),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                   flex: 3,
//                                   child: Container(
//                                     height: screenWidth * 0.24,
//                                     // width: screenWidth * 0.20,
//                                     // height: double.infinity,
//                                     clipBehavior: Clip.hardEdge,
//                                     decoration: BoxDecoration(
//                                       borderRadius:
//                                       BorderRadius.all(Radius.circular(12.0)),
//                                     ),
//                                     child: FadeInImage(
//                                       image: NetworkImage("$imageBaseURL${_foodDetails.vendor[index].vendorImage}"),
//
//                                       placeholder: AssetImage(
//                                           "assets/images/grocery/grocery1.jpg"),
//                                       fit: BoxFit.fill,
//                                     ),
//                                   )
//                               ),
//                               Expanded(
//                                 flex: 8,
//                                 child: Container(
//                                   // color: Colors.redAccent,
//                                   width: screenWidth * 0.58,
//                                   margin:
//                                   EdgeInsets.only(left: 15.0, top: 7.0,right: 10.0),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                     CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                           "${_foodDetails.vendor[index].shopName}",
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.black,
//                                               fontSize:
//                                               screenWidth * 0.04)),
//                                       Container(
//                                         margin: EdgeInsets.only(top: 10.0),
//                                         child: Row(
//                                           children: [
//                                             Text(
//                                               "${_foodDetails.vendor[index].city}  ${_foodDetails.vendor[index].zip}",
//                                               style: TextStyle(
//                                                 // fontWeight: FontWeight.bold,
//                                                   color: Colors.black,
//                                                   fontSize:
//                                                   screenWidth * 0.032),
//                                             ),
//                                             Expanded(
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                   MainAxisAlignment.end,
//                                                   children: [
//                                                     Icon(
//                                                       Icons.access_time,
//                                                       color: Colors.black38,
//                                                       size: screenWidth * 0.032,
//                                                     ),
//                                                     Text(
//                                                       " 9AM-7PM",
//                                                       textAlign: TextAlign.end,
//                                                       style: TextStyle(
//                                                         // fontWeight: FontWeight.bold,
//                                                           color: Colors.black38,
//                                                           fontSize:
//                                                           screenWidth *
//                                                               0.030),
//                                                     ),
//                                                   ],
//                                                 ))
//                                           ],
//                                         ),
//                                       ),
//                                       Container(
//                                         margin: EdgeInsets.only(top: 10.0),
//                                         child: Row(
//                                           children: [
//                                             Icon(
//                                               Icons.star,
//                                               size: screenWidth * 0.037,
//                                               color: Colors.orangeAccent,
//                                             ),
//                                             Text(
//                                               " 4.2",
//                                               style: TextStyle(
//                                                 color: Colors.orangeAccent,
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               width: 20.0,
//                                             ),
//                                             Icon(
//                                               Icons.access_time,
//                                               size: screenWidth * 0.032,
//                                               color: Colors.deepOrange,
//                                             ),
//                                             Text("  30m",
//                                                 style: TextStyle(
//                                                   fontWeight:
//                                                   FontWeight.bold,
//                                                   fontSize:
//                                                   screenWidth * 0.030,
//                                                   color: Colors.deepOrange,
//                                                 ))
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           )),
//                     );
//                   }),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
