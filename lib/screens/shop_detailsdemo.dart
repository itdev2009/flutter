import 'dart:convert';

import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/registration_otp_screens/registrationPage.dart';
import 'package:delivery_on_time/restaurants_screen/model/foodDetailsModel.dart';
import 'package:delivery_on_time/restaurants_screen/model/foodParentCategoryModel.dart';
import 'package:delivery_on_time/restaurants_screen/repository/foodHomeRepository.dart';
import 'package:delivery_on_time/restaurants_screen/tabBarScreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'grocery_home.dart';
/*

class ShopDetail1 extends StatefulWidget {
  @override
  _shop createState() => _shop();

  static String vendorId;
  static String categoryId;
  static String vendorName;


  ShopDetail1(Category_id, vendor_id, vendor_name) {
    print("category at shoppage $Category_id");
    categoryId = Category_id;
    vendorId = vendor_id;
    vendorName = vendor_name;
  }
}

class _shop extends State<ShopDetail1> with SingleTickerProviderStateMixin {
  bool firsttime=false;
  int controllerlen = 0;
  var vendorId = ShopDetail1.vendorId;
  var categoryId = ShopDetail1.categoryId;
  var vendorName = ShopDetail1.vendorName;
  int _subCategoryIndex=0;


  Future<FoodParentCategoryModel> _foodParentCategoryFuture;
  FoodHomeRepository _foodHomeRepository = new FoodHomeRepository();
  */
/*List tabs = [
    Container(
      child: Text("1st"),
    ),
    Container(
      child: Text("2nd"),
    ),
    Container(
      child: Text("3rd"),
    ),
    Container(
      child: Text("4th"),
    ),
    Container(
      child: Text("5th"),
    ),
  ];*/

/*SizedBox(
                width: 5,
              ),*//*

              */
/*Text(
                "Rs.150  ",
                style: TextStyle(
                    fontSize: screenWidth * 0.037, color: Colors.white),
              ),*/
/*

              Icon(
                Icons.arrow_forward,
                size: 15,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
      backgroundColor: darkThemeBlue,
      body: new CustomScrollView(
        slivers: [

          // The containers in the background
          new Container(
            height: screenHeight * .4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage((categoryId=="2")?'assets/images/food_images/snacksShop.png':"assets/images/grocery/grocery1.jpg"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          // The card widget with top padding,
          // incase if you wanted bottom padding to work,
          // set the `alignment` of container to Alignment.bottomCenter
          new Container(
            alignment: Alignment.topCenter,
            padding: new EdgeInsets.only(
              top: screenHeight * .32,
            ),
            child: new Container(
              decoration: new BoxDecoration(
                  color: darkThemeBlue, //new Color.fromRGBO(255, 0, 0, 0.0),
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(40.0),
                      topRight: const Radius.circular(40.0))),
              height: screenHeight * .75,
              width: screenWidth,
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: new Card(
                  clipBehavior: Clip.hardEdge,
                  color: darkThemeBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30))),
                  child: ListView(
                    children: [
                      Container(
                        // color: Colors.white,
                        child: Row(
                          children: [
                            Text(
                              "$vendorName".toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.favorite_border,
                              color: Colors.white38,
                              size: screenWidth * 0.06,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Text(
                        (categoryId=="2")?"Tasty and Delicious Food":"Fresh Grocery Product",
                        style: TextStyle(
                          color: Colors.deepOrangeAccent,
                          fontSize: screenWidth * 0.035,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      Row(
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
                          Text(
                            "Free Delivery",
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: screenWidth * 0.036,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
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
                          */
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
/*

                          // ToggleButtons(children: null, isSelected: null)
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.016,
                      ),
                      FutureBuilder<FoodParentCategoryModel>(
                        future: _foodParentCategoryFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState != ConnectionState.done)
                            return Center(
                              heightFactor: 5,
                              widthFactor: 10,
                              child: CircularProgressIndicator(
                                  backgroundColor: circularBGCol,
                                  strokeWidth: strokeWidth,
                                  valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol)
                              ),
                            );

                          //load null data UI
                          if (!snapshot.hasData || snapshot.data == null)
                            return Container(child: Text("No Data Found"));

                          if (snapshot.hasData) {
                            controllerlen =
                                snapshot.data.data[_subCategoryIndex].subcategory.length;
                            if(!firsttime){
                              _tabController = new TabController(
                                  vsync: this, length: controllerlen);
                              print("tab controller created");
                              firsttime=true;
                            }
                            _tabController.addListener(() {
                              _activeTabIndex = _tabController.index;
                              print("tabbar index ${_tabController.index}");
                              print("tabbar listner listing");
                              setState(() {
                              });
                            });
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
                                    labelPadding: EdgeInsets.only(
                                        right: 15.0, left: 15.0),
                                    labelStyle: TextStyle(fontSize: 13.0),
                                    tabs: List.generate(
                                      controllerlen,
                                          (index) => Tab(
                                        text:
                                        "${snapshot.data.data[_subCategoryIndex].subcategory[index].subcategoryname}",
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: screenHeight * 0.58,
                                  child: ListView(shrinkWrap: true, children: [
                                    SizedBox(
                                      height: screenHeight * 0.025,
                                    ),
                                    Container(
                                      height: screenHeight * 0.555,
                                      // color: Colors.pink,
                                      child: TabBarView(
                                        controller: _tabController,
                                        children: List.generate(
                                            controllerlen,
                                                (index) => TabBarScreen(
                                                categoryId,
                                                vendorId,
                                                snapshot.data.data[_subCategoryIndex]
                                                    .subcategory[_activeTabIndex].id,
                                                _activeTabIndex)),
                                      ),
                                    ),
                                  ]),
                                ),
                              ],
                            );
                          } else {
                            return Container(child: Text("No Data Found"));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
*/





/*
class _Page {
  _Page({this.widget});
  final Widget widget;
}

List<_Page> _allPages;

class Home extends StatefulWidget {

  @override
  _HomeState createState() => new _HomeState();


  changeTabIndex(int index) {
    _HomeState()._controller.animateTo(index);
  }
}

class _HomeState extends State<Home> with TickerProviderStateMixin {

  TabController _controller;
  _HomeState();

  @override
  void initState() {
    super.initState();

    _allPages = <_Page>[
      _Page(widget: GroceryHome()),
      _Page(widget: GroceryHome()),
      _Page(widget: GroceryHome()),
      _Page(widget: GroceryHome()),
    ];

    _controller = TabController(vsync: this, length: 4);
    _controller.addListener(_handleTabSelection);
  }

  _handleTabSelection() { // <--- Save your tab index
    if(_controller.indexIsChanging) {
      // Save your tab index here
      // You can use static variable or BloC state
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TabBarView(
          controller: _controller,
          children: _allPages.map<Widget>((_Page page){
            return SafeArea(
              child: Container(
                  key: ObjectKey(page.widget),
                  child: page.widget
              ),
            );
          }).toList(),
        )
    )
  }*/
