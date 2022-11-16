import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/restaurants_screen/shop_details.dart';
import 'package:delivery_on_time/search_screen/repository/searchRepository.dart';
import 'package:delivery_on_time/search_screen/searchFoodVendorPage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:intl/intl.dart';

import 'model/foodSearchModel.dart';

class SearchPage extends SearchDelegate<String> {
  final cities = ["Kolkata", "Chennai", "Mumbai", "Delhi", "Hayderabad", "Bangalore"];

  final recent = ["Sugar", "Rice", "Biryani"];

  SearchRepository _foodSearchRepository = new SearchRepository();

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      primaryColor: darkThemeBlue,

      textTheme: TextTheme(

        headline1: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        headline6: TextStyle(
          color: Colors.white,
          fontSize: 18,
        )
      ),
      primaryIconTheme: IconThemeData(
        color: Colors.white,
      ),
      backgroundColor: darkThemeBlue,
      cursorColor: Colors.orange,
      inputDecorationTheme: InputDecorationTheme(
       //labe fillColor: Colors.amber,

       // labelStyle: TextStyle(
          //  color: Colors.white),

          hintStyle: TextStyle(
        color: Colors.white,
      )),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, "");
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchTabBarClass(
      query: query,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty ? recent : cities;

    return (query.isEmpty)
        ? Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Center(
          child: Text(
            "Type Something to Search",
            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          )),
    )
        :Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Center(
          child: Text(
            "Press Search / Enter on Keypad",
            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          )),
    );
  }
}

class SearchTabBarClass extends StatefulWidget {
  final query;

  const SearchTabBarClass({Key key, this.query}) : super(key: key);

  @override
  _SearchTabBarClassState createState() => _SearchTabBarClassState();
}

class _SearchTabBarClassState extends State<SearchTabBarClass> with TickerProviderStateMixin {
  SearchRepository _foodSearchRepository;
  TabController _tabController;
  List searchDataName = ["   Products   ", "   Restaurants   "];
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
    createSharedPref();
    _foodSearchRepository = new SearchRepository();
  }

  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.query.isEmpty)
        ? Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Center(
                child: Text(
              "Type Something to Search",
              style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
            )),
          )
        : FutureBuilder<FoodSearchModel>(
            future: _foodSearchRepository.search({"search_data": "${widget.query}"}),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.data.products.isNotEmpty || snapshot.data.data.vendors.isNotEmpty) {
                  return Column(
                    children: [
                      TabBar(
                          isScrollable: true,
                          indicatorColor: Colors.deepOrange,
                          indicatorSize: TabBarIndicatorSize.tab,
                          controller: _tabController,
                          unselectedLabelColor: Colors.black,
                          labelColor: darkThemeBlue,
                          labelPadding: EdgeInsets.only(right: 15.0, left: 15.0),
                          labelStyle: TextStyle(fontSize: 16.0),
                          tabs: [
                            Tab(
                              child: SizedBox(width: screenWidth*0.39,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.style),
                                  Text("  Products"),
                                ],
                              ),),
                            ),
                            Tab(
                              child: SizedBox(width: screenWidth*0.39,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.restaurant_rounded),
                                    Text("  Restaurants"),
                                  ],
                                ),),
                            ),
                          ]),
                      Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [searchProductWidget(snapshot.data.data), searchRestroWidget(snapshot.data.data)],
                        ),
                      ),
                    ],
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Center(
                      child: Text(
                        "No Result Found",
                        style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                      )),
                );
              } else if (snapshot.hasError) {
                print(snapshot.error.toString());
                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Center(
                      child: Text(
                    "No Result Found",
                    style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                  )),
                );
              } else
                return Center(
                  heightFactor: 5,
                  widthFactor: 10,
                  child: CircularProgressIndicator(
                      backgroundColor: circularBGCol,
                      strokeWidth: strokeWidth,
                      valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol)),
                );
            },
          );
  }

  Widget searchProductWidget(Data data) {
    if (data.products.isNotEmpty) {
      return ListView.builder(
          itemCount: data.products.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return SearchFoodVendorPage(data.products[index]);
                    }));
                  },
                  child: ListTile(
                      leading: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        child: FadeInImage(
                          height: 55,
                          width: 55,
                          image: NetworkImage(
                            "$imageBaseURL${data.products[index].detailedProductImages.split(",")[0]}",
                          ),
                          placeholder: AssetImage("assets/images/placeHolder/square_white.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      title: SubstringHighlight(
                        text: data.products[index].skuName,
                        term: widget.query,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        textStyleHighlight: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                          fontSize: 15,
                        ),
                      )),
                ),
                Divider(
                  color: Colors.orange,
                  // thickness: 1,
                )
              ],
            );
          });
    } else
      return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Center(
            child: Text(
              "No Product Found",
              style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
            )),
      );
  }


  Widget searchRestroWidget(Data data) {

    DateTime startTime;
    DateTime endTime;
    DateTime nowTime=DateTime.now();
    DateTime availableFrom;
    DateTime availableTo;
    List<double> shopDistance=new List<double>();
    List<bool> shopTimingAvailability=new List<bool>();

    if (data.vendors.isNotEmpty) {
      return ListView.builder(
          itemCount: data.vendors.length,
          itemBuilder: (context, index) {

            double totalDistance = calculateDistance(
                userLat,
                userLong,
                (data.vendors[index].latitude != null)
                    ? double.parse(data.vendors[index].latitude)
                    : userLat,
                (data.vendors[index].longitude != null)
                    ? double.parse(data.vendors[index].longitude)
                    : userLong);
            // double totalDistance = calculateDistance(userLat, userLong, 22.620943, 88.398922);

            // print("${snapshot.data.data[index].shopName} $totalDistance");
            shopDistance.add(totalDistance);
            availableFrom=DateFormat("HH:mm:ss").parse(data.vendors[index].availableFrom);
            availableTo=DateFormat("HH:mm:ss").parse(data.vendors[index].availableTo);


            // print(snapshot.data.data[index].shopName);
            if(DateTime.now(). compareTo(DateTime(nowTime.year,nowTime.month,nowTime.day,availableFrom.hour,availableFrom.minute))>0 &&
                DateTime.now(). compareTo(DateTime(nowTime.year,nowTime.month,nowTime.day,availableTo.hour,availableTo.minute))<0){
              shopTimingAvailability.add(true);
              // print("Shop open");
            }else{
              shopTimingAvailability.add(false);
              // print("Shop Closed");
            }

            return Column(
              children: [
                InkWell(
                  onTap: () {
                    if (shopDistance[index] <= 10.0) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShopDetail(
                                shopLat: (data.vendors[index].latitude != null)
                                    ? double.parse(data.vendors[index].latitude)
                                    : userLat,
                                shopLong: (data.vendors[index].longitude != null)
                                    ? double.parse(data.vendors[index].longitude)
                                    : userLong,
                                categoryId: data.vendors[index].categoryId.toString(),
                                vendorId: data.vendors[index].id.toString(),
                                vendorName: data.vendors[index].shopName,
                                shopAvailability: shopTimingAvailability[index],
                                cartId: prefs.getString("cart_id")??"",
                                // data.vendors[index].categoryId,
                                // data.vendors[index].vendorId,
                                // data.vendors[index].shopName
                              )));
                    } else {
                      Fluttertoast.showToast(
                          msg: "${data.vendors[index].shopName} is Undeliverable at your location",
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
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)), color: Colors.transparent),
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
                                    child:FadeInImage(
                                      image: NetworkImage("$imageBaseURL${data.vendors[index].vendorImage}"),
                                      placeholder: AssetImage("assets/images/placeHolder/square_white.png"),
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
                                        child: Text("${data.vendors[index].shopName}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold, color: Colors.black, fontSize: screenWidth * 0.04)),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "${data.vendors[index].address}",
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
                                              /*${data.vendors[index].averageRating??4.2}*/"4.5",
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
                                              " ${data.vendors[index].availableFrom.split(":")[0]}:${data.vendors[index].availableFrom.split(":")[1]} - ${data.vendors[index].availableTo.split(":")[0]}:${data.vendors[index].availableTo.split(":")[1]}",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                // fontWeight: FontWeight.bold,
                                                  color: Colors.black45,
                                                  fontSize: screenWidth * 0.030),
                                            ),
                                            // Icon(
                                            //   Icons.access_time,
                                            //   size: screenWidth * 0.032,
                                            //   color: Colors.deepOrange,
                                            // ),
                                            // Text("  30m",
                                            //     style: TextStyle(
                                            //       fontWeight: FontWeight.bold,
                                            //       fontSize: screenWidth * 0.030,
                                            //       color: Colors.deepOrange,
                                            //     )),
                                            Spacer(),
                                            (shopTimingAvailability[index])?
                                            Text("OPEN",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: screenWidth * 0.032,
                                                  color: Colors.green,
                                                ))
                                                :
                                            Text("CLOSED",
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

                  ),
                ),
                Divider(
                  color: Colors.orange,
                  // thickness: 1,
                )
              ],
            );
          });
    } else
      return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Center(
            child: Text(
              "No Restaurant Found",
              style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
            )),
      );
  }


}
