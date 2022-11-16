import 'dart:convert';

import 'package:delivery_on_time/cart_screen/cartPage.dart';
import 'package:delivery_on_time/cart_screen/cart_page.dart';
import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/registration_otp_screens/mobileNumberPage.dart';
import 'package:delivery_on_time/restaurants_screen/model/foodDetailsModel.dart' as fdm;
import 'package:delivery_on_time/restaurants_screen/order_options.dart';
import 'package:delivery_on_time/restaurants_screen/repository/foodHomeRepository.dart';
import 'package:delivery_on_time/restaurants_screen/tabBarScreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopDetail extends StatefulWidget {
  final double shopLat;
  final double shopLong;
  final String vendorId;
  final String categoryId;
  final String vendorName;
  final bool shopAvailability;
  final String cartId;

  const ShopDetail({Key key, this.shopLat, this.shopLong, this.vendorId, this.categoryId, this.vendorName, this.shopAvailability = true, this.cartId}) : super(key: key);

  @override
  _shop createState() => _shop(shopLat, shopLong,vendorId, categoryId, vendorName, shopAvailability,cartId);
}

class _shop extends State<ShopDetail> with SingleTickerProviderStateMixin{
  bool firsttime = false;
  bool tabBarSetState = false;
  int controllerlen = 0;

  final double shopLat;
  final double shopLong;
  final String vendorId;
  final String categoryId;
  final String vendorName;
  final bool shopAvailability;
  String _cartId="";


  _shop(this.shopLat, this.shopLong, this.vendorId, this.categoryId, this.vendorName, this.shopAvailability, this._cartId);

  // int _subCategoryIndex=0;

  List<TabBarScreen> _tabBarScreenList;

  // Future<FoodParentCategoryModel> _foodParentCategoryFuture;
  FoodHomeRepository _foodHomeRepository = new FoodHomeRepository();
  Future<fdm.FoodDetailsModel> _foodDetailsFuture;

  TabController _tabController;
  SharedPreferences prefs;
  String _userToken = "";
  // String _cartId = "";

  @override
  void initState() {
    super.initState();
    print("page hit "+DateTime.now().toLocal().toString());
    print("at api push "+DateTime.now().toLocal().toString());
    _foodDetailsFuture = _foodHomeRepository.foodDetails(categoryId, vendorId, _cartId);
    print("after api push "+DateTime.now().toLocal().toString());
    createSharedPref();
    /*if(categoryId=="2"){
      _subCategoryIndex=0;
    }
    else if(categoryId=="3"){
      _subCategoryIndex=1;
    }
    else if(categoryId=="18"){
      _subCategoryIndex=2;
    }*/
    // _foodParentCategoryFuture = _foodHomeRepository.foodParentCategory();
  }

  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    // _cartId = prefs.getString("cart_id")??"";
    _userToken = prefs.getString("user_token");
    // print("at api push "+DateTime.now().toLocal().toString());
    // _foodDetailsFuture = _foodHomeRepository.foodDetails(categoryId, vendorId, _cartId);
    // print("after api push "+DateTime.now().toLocal().toString());
    setState(() {});
    // prefs.reload();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
        floatingActionButton: Visibility(
          visible: shopAvailability,
          child: FloatingActionButton.extended(
            backgroundColor: Colors.deepOrange,
            onPressed: () {
              _cartId = prefs.getString("cart_id");
              print("cartid" + _cartId);
              /*if(_userToken!="")*/
              {
                if (_cartId == "") {
                  Fluttertoast.showToast(
                      msg: "Please Add Items In Your Cart",
                      fontSize: 16,
                      backgroundColor: Colors.orange[100],
                      textColor: darkThemeBlue,
                      toastLength: Toast.LENGTH_LONG);
                } else if (_cartId != "") {

                  /*Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartPageNew()
                          // AddressPage()
                          ));
                  */

                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OrderOptions()
                          // AddressPage()
                          ));


                }
              }
              // else if(_userToken=="")
              // {
              //   if(_cartId==""){
              //     Fluttertoast.showToast(
              //         msg: "Please Add Items In Your Cart",
              //         fontSize: 16,
              //         backgroundColor: Colors.white,
              //         textColor: darkThemeBlue,
              //         toastLength: Toast.LENGTH_LONG);
              //   }else{
              //
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => MobileNumberPage(cartId: _cartId,)
              //         // AddressPage()
              //       ));
              //   }
              // }
            },
            label: Container(
              width: 180,
              child: Row(
                children: [
                  Text(
                    "Click Here to Proceed",
                    style: TextStyle(fontSize: 11, color: Colors.white),
                  ),
                  Spacer(),
                  /*SizedBox(
                    width: 5,
                  ),*/
                  /*Text(
                    "Rs.150  ",
                    style: TextStyle(
                        fontSize: screenWidth * 0.037, color: Colors.white),
                  ),*/
                  Icon(
                    Icons.arrow_forward,
                    size: 15,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ),
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
              "Shop Menu",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.045),
            )),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.notifications,
                  size: 0,
                  color: Colors.white,
                ),
              ),
            ]),
        backgroundColor: darkThemeBlue,
        body: new Stack(
          children: <Widget>[
            // The containers in the background
            /*new Container(
              height: screenHeight * .3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage((categoryId=="2")?'assets/images/food_images/snacksShop.png':"assets/images/grocery/grocery1.jpg"),
                  fit: BoxFit.fill,
                ),
              ),
            ),*/
            // The card widget with top padding,
            // incase if you wanted bottom padding to work,
            // set the `alignment` of container to Alignment.bottomCenter
            new Container(
              alignment: Alignment.topCenter,
              // padding: new EdgeInsets.only(
              //   top: screenHeight * .22,
              // ),
              child: new Container(
                decoration: new BoxDecoration(
                  color: darkThemeBlue, //new Color.fromRGBO(255, 0, 0, 0.0),
                  /*borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(40.0),
                        topRight: const Radius.circular(40.0))*/
                ),
                height: screenHeight * .81,
                width: screenWidth,
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: ListView(
                    children: [
                      Container(
                        // color: Colors.white,
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                "$vendorName".toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Text(
                        (categoryId == "2")
                            ? "Tasty and Delicious Food"
                            : (categoryId == "3")
                                ? "Fresh Grocery Product"
                                : (categoryId == "18")
                                    ? "Fresh and Yummy Cakes"
                                    : "",
                        style: TextStyle(
                          color: Colors.deepOrangeAccent,
                          fontSize: screenWidth * 0.035,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      /*(categoryId == "18")
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: RichText(
                                    // To Make Different Text Color in single line
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                        text: "Regular Order Delivery Time :",
                                        style: TextStyle(color: Colors.deepOrange[300], fontSize: 13, fontWeight: FontWeight.w500),
                                        children: [
                                          TextSpan(
                                            text: "  Approximate 1 Hr.",
                                            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                          ),
                                        ]),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Flexible(
                                  child: RichText(
                                    // To Make Different Text Color in single line
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                        text: "Customized Order Delivery Time :",
                                        style: TextStyle(color: Colors.deepOrange[300], fontSize: 13, fontWeight: FontWeight.bold),
                                        children: [
                                          TextSpan(
                                            text: "  2 to 4 Hrs.",
                                            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                          ),
                                        ]),
                                  ),
                                )
                              ],
                            )
                          :*/ Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.orangeAccent,
                                  size: screenWidth * 0.04,
                                ),
                                Text(
                                  " 4.2  ",
                                  style: TextStyle(
                                    color: Colors.orangeAccent,
                                    fontSize: screenWidth * 0.035,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  " (125)",
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: screenWidth * 0.035,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.1,
                                ),
                                Icon(
                                  Icons.access_time,
                                  color: Colors.deepOrange,
                                  size: screenWidth * 0.04,
                                ),
                                Text(
                                  " 30m",
                                  style: TextStyle(
                                    color: Colors.deepOrange,
                                    fontSize: screenWidth * 0.035,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                (shopAvailability)?
                                Text("OPEN",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth * 0.038,
                                      color: Colors.green,
                                    ))
                                    :
                                Text("CLOSED",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth * 0.038,
                                      color: Colors.red[800],
                                    ))
                              ],
                            ),
                      SizedBox(
                        height: screenHeight * 0.035,
                      ),
                      Row(
                        children: [
                          Text(
                            "Menu".toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.037,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          /*SizedBox(
                            width: screenWidth * 0.28,
                          ),
                          Text(
                            "Veg",
                            style: TextStyle(
                              color: lightTextBlue,
                              fontSize: screenWidth * 0.037,
                              fontWeight: FontWeight.bold,
                            ),
                          ),*/
                          // ToggleButtons(children: null, isSelected: null)
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.016,
                      ),
                      FutureBuilder<fdm.FoodDetailsModel>(
                        future: _foodDetailsFuture,
                        builder: (context, snapshot) {
                          print("before data receive "+DateTime.now().toLocal().toString());

                          // if (snapshot.connectionState != ConnectionState.done)
                          //

                          //load null data UI
                          // if (!snapshot.hasData || snapshot.data == null){
                          //   return Container(child: Text("No Data Found"));
                          // }
                          if (snapshot.hasData) {
                            print("after data receive "+DateTime.now().toLocal().toString());
                            if (snapshot.data.data.menu.isNotEmpty) {
                              controllerlen = snapshot.data.data.menu[0].subcategory.length;
                              if (!firsttime) {
                                _tabController = new TabController(vsync: this, length: controllerlen);
                                _tabBarScreenList = List.generate(
                                    controllerlen,
                                    (index) => TabBarScreen(
                                      shopLat: shopLat,
                                          shopLong: shopLong,
                                          foodDetailsModelData: snapshot.data.data,
                                          vendorId: vendorId,
                                          categoryId: categoryId,
                                          parentCategoryId: snapshot.data.data.menu[0].subcategory[index].id,
                                          index: index,
                                          shopAvailability: shopAvailability,
                                        ));
                                print("tab controller created");
                                firsttime = true;
                              }
                              print("after ytab creation "+DateTime.now().toLocal().toString());


                              return ListView(
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  Container(
                                    width: screenWidth,
                                    height: screenHeight * 0.062,
                                    // color: Color.fromRGBO(238, 46, 95, 1),
                                    child: TabBar(
                                      isScrollable: true,
                                      indicatorColor: Colors.deepOrange,
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      controller: _tabController,
                                      unselectedLabelColor: lightTextBlue,
                                      labelColor: Colors.white,
                                      labelPadding: EdgeInsets.only(right: 15.0, left: 15.0),
                                      labelStyle: TextStyle(fontSize: 13.0),
                                      tabs: List.generate(
                                        controllerlen,
                                        (index) => Tab(
                                          text: "${snapshot.data.data.menu[0].subcategory[index].subcategoryname}",
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: screenHeight * 0.68,
                                    child: ListView(shrinkWrap: true, children: [
                                      SizedBox(
                                        height: screenHeight * 0.025,
                                      ),
                                      Container(
                                        height: screenHeight * 0.555,
                                        // color: Colors.pink,
                                        child: TabBarView(
                                          controller: _tabController,
                                          children: _tabBarScreenList,
                                        ),
                                      ),
                                    ]),
                                  ),
                                ],
                              );
                            } else {
                              return Center(
                                  child: Text(
                                "This Shop Has No Items",
                                style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                              ));
                            }
                          }
                          else if(snapshot.hasError) {
                            print(snapshot.error);
                            return Container(child: Text("No Data Found"));
                          } else{
                            return Center(
                              heightFactor: 5,
                              widthFactor: 10,
                              child: CircularProgressIndicator(
                                  backgroundColor: circularBGCol,
                                  strokeWidth: strokeWidth,
                                  valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol)),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
