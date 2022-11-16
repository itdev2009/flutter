import 'package:carousel_slider/carousel_slider.dart';
import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/restaurants_screen/shop_details.dart';
import 'package:delivery_on_time/search_screen/model/foodSearchModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchFoodVendorPage extends StatefulWidget {
  final Products _foodDetails;

  SearchFoodVendorPage(this._foodDetails);

  @override
  _SearchFoodVendorPageState createState() => _SearchFoodVendorPageState(_foodDetails);
}

class _SearchFoodVendorPageState extends State<SearchFoodVendorPage> {
  final Products _foodDetails;

  _SearchFoodVendorPageState(this._foodDetails);
  int _current=0;

  SharedPreferences prefs;
  DateTime availableFrom;
  DateTime availableTo;
  DateTime nowTime = DateTime.now();
  List<double> shopDistance=[];


  @override
  void initState() {
    super.initState();
    createSharedPref();
  }

  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: darkThemeBlue,
        appBar: AppBar(
            backgroundColor: lightThemeBlue,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
            title: Center(
                child: Text(
              "Shop Details",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.045),
            )),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 0,
                ),
              ),
            ]),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            children: [
              Container(
                width: screenWidth,
                // height: screenHeight * 0.3,
                child: Column(
                  children: [
                    CarouselSlider.builder(
                        options: CarouselOptions(
                          autoPlayInterval: Duration(seconds: 4),
                          autoPlay: true,
                          aspectRatio: 2.0,
                          enlargeCenterPage: true,
                          enlargeStrategy: CenterPageEnlargeStrategy.height,
                          autoPlayCurve: Curves.decelerate,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          }
                        ),
                        itemCount: _foodDetails.detailedProductImages.split(",").length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            // width: screenWidth,
                            color: Colors.white,
                            child: FadeInImage(
                              width: screenWidth,
                              // height: screenHeight * 0.3,
                              image: NetworkImage(
                                "$imageBaseURL${_foodDetails.detailedProductImages.split(",")[index]}",
                              ),
                              placeholder: AssetImage("assets/images/placeHolder/square_white.png"),
                              fit: BoxFit.fitHeight,
                            ),
                          );
                        }),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: _foodDetails.detailedProductImages.split(",")
                          .map((url) {
                        int index = _foodDetails.detailedProductImages.split(",")
                            .indexOf(url);
                        return Container(
                          width: 9.0,
                          height: 9.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current == index
                                ? Colors.orange.shade800
                                : Colors.white,
                          ),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),

              SizedBox(
                height: 5.0,
              ),

              Text(
                "${_foodDetails.skuName}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),

              SizedBox(
                height: 10.0,
              ),

              Text(
                "All Shops ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
              ),

          ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: _foodDetails.vendor.length,

              itemBuilder: (context, index) {

                double totalDistance = calculateDistance(
                    userLat,
                    userLong,
                    (_foodDetails.vendor[index].latitude != null)
                        ? double.parse(_foodDetails.vendor[index].latitude)
                        : userLat,
                    (_foodDetails.vendor[index].longitude != null)
                        ? double.parse(_foodDetails.vendor[index].longitude)
                        : userLong);
                // double totalDistance = calculateDistance(userLat, userLong, 22.620943, 88.398922);

                // print("${snapshot.data.data[index].shopName} $totalDistance");
                shopDistance.add(totalDistance);

                availableFrom = DateFormat("HH:mm:ss").parse(_foodDetails.vendor[index].availableFrom);
                availableTo = DateFormat("HH:mm:ss").parse(_foodDetails.vendor[index].availableTo);

                if (DateTime.now().compareTo(
                    DateTime(nowTime.year, nowTime.month, nowTime.day, availableFrom.hour, availableFrom.minute)) >
                    0 &&
                    DateTime.now().compareTo(
                        DateTime(nowTime.year, nowTime.month, nowTime.day, availableTo.hour, availableTo.minute)) <
                        0) {
                  _foodDetails.vendor[index].shopTimingAvailability = true;
                } else {
                  _foodDetails.vendor[index].shopTimingAvailability = false;
                }


                return InkWell(
                  onTap: () {

                    if (shopDistance[index] <= 10.0) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShopDetail(
                                shopLat: (_foodDetails.vendor[index].latitude != null)
                                    ? double.parse(_foodDetails.vendor[index].latitude)
                                    : userLat,
                                shopLong: (_foodDetails.vendor[index].longitude != null)
                                    ? double.parse(_foodDetails.vendor[index].longitude)
                                    : userLong,
                                categoryId: _foodDetails.vendor[index].categoryId.toString(),
                                vendorId: _foodDetails.vendor[index].vendorId.toString(),
                                vendorName: _foodDetails.vendor[index].shopName,
                                shopAvailability: _foodDetails.vendor[index].shopTimingAvailability,
                                cartId: prefs.getString("cart_id") ?? "",
                              )));
                    } else {
                      Fluttertoast.showToast(
                          msg: "${_foodDetails.vendor[index].shopName} is Undeliverable at your location",
                          fontSize: 14,
                          backgroundColor: Colors.orange[100],
                          textColor: darkThemeBlue,
                          toastLength: Toast.LENGTH_LONG);
                    }


                  },
                  child: Stack(
                    children: [
                      Container(
                          margin: EdgeInsets.all(7.0),
                          padding: EdgeInsets.all(5.0),
                          height: screenWidth * 0.27,
                          // width: screenWidth*0.05,
                          // height: 100.0,
                          // color: Colors.white,
                          decoration:
                          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)), color: Colors.white),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: screenWidth * 0.24,
                                    // width: screenWidth * 0.20,
                                    // height: double.infinity,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                    ),
                                    child: FadeInImage(
                                      image: NetworkImage("$imageBaseURL${_foodDetails.vendor[index].vendorImage}"),
                                      placeholder:
                                      AssetImage("assets/images/placeHolder/restro/food4.png"),
                                      fit: BoxFit.fill,
                                    ),
                                  )),
                              Expanded(
                                flex: 8,
                                child: Container(
                                  // color: Colors.redAccent,
                                  width: screenWidth * 0.58,
                                  margin: EdgeInsets.only(left: 15.0, top: 4.0, right: 10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text("${_foodDetails.vendor[index].shopName}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: screenWidth * 0.04)),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "${_foodDetails.vendor[index].address}",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            // fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: screenWidth * 0.032),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              size: screenWidth * 0.037,
                                              color: Colors.orangeAccent,
                                            ),
                                            Text(
                                              "4.2",
                                              style: TextStyle(
                                                color: Colors.orangeAccent,
                                              ),
                                            ),
                                            Spacer(),

                                            // SizedBox(
                                            //   width: 20.0,
                                            // ),
                                            Icon(
                                              Icons.access_time,
                                              color: Colors.black45,
                                              size: screenWidth * 0.032,
                                            ),
                                            Text(
                                              " ${_foodDetails.vendor[index].availableFrom.split(":")[0]}:${_foodDetails.vendor[index].availableFrom.split(":")[1]} - ${_foodDetails.vendor[index].availableTo.split(":")[0]}:${_foodDetails.vendor[index].availableTo.split(":")[1]}",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                // fontWeight: FontWeight.bold,
                                                  color: Colors.black45,
                                                  fontSize: screenWidth * 0.030),
                                            ),
                                            Spacer(),
                                            (_foodDetails.vendor[index].shopTimingAvailability)
                                                ? Text("OPEN",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: screenWidth * 0.032,
                                                  color: Colors.green,
                                                ))
                                                : Text("CLOSED",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: screenWidth * 0.032,
                                                  color: Colors.red[800],
                                                ))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )),
                      Container(
                        margin: EdgeInsets.all(7.0),
                        padding: EdgeInsets.all(5.0),
                        height: screenWidth * 0.27,
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)),
                            color: (shopDistance[index] <= 10.0)?Colors.white10.withOpacity(0):Colors.white10.withOpacity(0.5)),
                      ),
                    ],
                  )
                );
              }),

            ],
          ),
        ),
      ),
    );
  }
}
