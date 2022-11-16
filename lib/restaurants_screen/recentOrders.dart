import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/restaurants_screen/model/recentOrdersModel.dart';
import 'package:delivery_on_time/restaurants_screen/repository/foodHomeRepository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class RecentOrders extends StatefulWidget {
  @override
  _RecentOrdersState createState() => _RecentOrdersState();
}

class _RecentOrdersState extends State<RecentOrders> {

  Future<RecentOrdersModel> _recentOrderApi;
  SharedPreferences prefs;
  FoodHomeRepository _foodHomeRepo = new FoodHomeRepository();
  String userId = "";
  String userToken = "";

  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("user_id");
    userToken = prefs.getString("user_token");
    Map _body = {"userid": "$userId"};
    _recentOrderApi = _foodHomeRepo.recentOrders(_body, userToken);
    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    createSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      // height: 225.0,
      child: FutureBuilder<RecentOrdersModel>(
          future: _recentOrderApi,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.data == null) {
                return Column(
                  children: [
                    Container(
                        margin: EdgeInsets.fromLTRB(15, 15, 10, 10),
                        child: Text(
                          "Your Recent Orders".toUpperCase(),
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14.0),
                        )),
                    Image.asset(
                      "assets/images/cart.png",
                      height: 130.0,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "You Don't Have Any Recent Order",
                      style: TextStyle(color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold, fontSize: 16.0),
                    )
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(15, 15, 10, 10),
                      child: Text(
                        "Your Recent Orders".toUpperCase(),
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14.0),
                      )),
                  Container(
                      margin: EdgeInsets.all(5.0),
                      // color: Colors.white,
                      height: 225.0,
                      // decoration: BoxDecoration(
                      //   // color: lightThemeBlue,
                      //     borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      //     ),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.data.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
                              elevation: 5,
                              shadowColor: Color.fromRGBO(190, 255, 255, 0.1),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Images of Your Recent Orders...
                                  Container(
                                    margin: EdgeInsets.all(5),
                                    height: 130.0,
                                    width: 150.0,
                                    decoration: BoxDecoration(
                                      // color: lightThemeBlue,
                                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "$imageBaseURL${snapshot.data.data[index].orderItems[0].productImage}"),
                                            fit: BoxFit.fill)),
                                  ),

                                  //Details of Your Recent Orders...
                                  Container(
                                    margin: EdgeInsets.only(left: 10.0, top: 5.0),
                                    // alignment: Alignment.topLeft,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Order ID : ${snapshot.data.data[index].orderId}",
                                            // textAlign: TextAlign.start,
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0, color: Colors.black)),

                                        SizedBox(
                                          height: 5.0,
                                        ),

                                        Text(
                                            "${DateFormat.yMMMMd().format(DateFormat("yyyy-MM-dd").parse(snapshot.data.data[index].createdAt, true))}.",
                                            // textAlign: TextAlign.start,
                                            style: TextStyle(
                                              // fontWeight: FontWeight.bold,
                                                fontSize: 12.0,
                                                color: Colors.black38)),

                                        //Price of Your Recent Orders...
                                        Container(
                                          // color: Colors.blue,
                                          width: 140,
                                          padding: const EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 0.0),
                                          child: Row(
                                            children: [
                                              Text("Rs.  ${snapshot.data.data[index].transactionAmount}/-",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold, fontSize: 14.0, color: Colors.deepOrange)),
                                              Expanded(
                                                child: Align(
                                                  alignment: Alignment.centerRight,
                                                  child: Icon(
                                                    Icons.shopping_cart,
                                                    size: 0.0,
                                                    color: Colors.deepOrange,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          })),
                ],
              );
            } else if (snapshot.hasError) {
              if (userToken == "") {
                return Container();
                /*Center(
                            child : Text("Please Login to See Your Recent Order",
                          style: TextStyle(color: Colors.deepOrangeAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0
                          ),));*/
              }
              return Column(
                children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(15, 15, 10, 10),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Your Recent Orders".toUpperCase(),
                        // textAlign: TextAlign.start,
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14.0),
                      )),
                  Image.asset(
                    "assets/images/cart.png",
                    height: 130.0,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "You Don't Have Any Recent Order",
                    style: TextStyle(color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold, fontSize: 16.0),
                  )
                ],
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
          }),
    );
  }
}
