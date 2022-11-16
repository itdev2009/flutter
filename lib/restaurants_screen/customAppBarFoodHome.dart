import 'package:delivery_on_time/cart_screen/cartPage.dart';
import 'package:delivery_on_time/cart_screen/cart_page.dart';
import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/screens/mapCurrentAddressPicker.dart';
import 'package:delivery_on_time/search_screen/searchPage.dart';
import 'package:flutter/material.dart';


class CustomAppBarFoodHome extends PreferredSize {
  final String _address;
  final String _cartId;
  // final int cartItemNo;

  CustomAppBarFoodHome(this._address, this._cartId);

  @override
  Size get preferredSize => Size.fromHeight(120.0);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 120.0,
      child: Column(
        children: [
          //Upper Container with Address and icons....
          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 10, 5),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 5.0, 3.0, 5.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 18.0,
                    ),
                  ),

                  //Address Text....
                  Expanded(
                    flex: 9,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MapHomePage1(
                                  pageIndex: 2,
                                )
                              // AddressPage()
                            ));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2.9),
                            child: Text(
                              "Delivery Location",
                              overflow: TextOverflow.visible,
                              style: TextStyle(color: Colors.white70, fontSize: 10.5),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: Text(
                                  userAddress??"Choose Delivery Address...",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.white, fontSize: 12.5),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Icon(
                                  Icons.edit_outlined,
                                  color: Colors.white,
                                  size: 15.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                    ),
                  ),

                  //Address Arrow Icon....
                  /*Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 14.0,
                  ),*/

                  //Bell Icon in Expanded....
                  // Expanded(
                  //   flex: 1,
                  //   child: Badge(
                  //
                  //     position: BadgePosition.bottomStart(bottom: 10.0,start: 14.0),
                  //     badgeContent: Text('3',style: TextStyle(
                  //       fontSize: 12.0,
                  //       color: Colors.white
                  //     ),),
                  //     badgeColor: Colors.deepOrangeAccent,
                  //     child: Icon(Icons.shopping_cart_outlined,
                  //       color: Colors.white,
                  //       size: 24.0,),
                  //   ),
                  // ),
                  /*Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: (_cartId!="")?InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CartPage()
                                // AddressPage()
                              ));
                        },
                        child: Badge(
                          position: BadgePosition.bottomStart(bottom: 10.0,start: 14.0),
                          badgeContent: Text('$cartItemNo',style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.white
                          ),),
                          badgeColor: Colors.deepOrangeAccent,
                          child: Icon(Icons.shopping_cart_outlined,
                            color: Colors.white,
                            size: 24.0,),
                        ),
                      ):IconButton(
                        icon: Icon(
                          Icons.remove_shopping_cart_outlined,
                          color: Colors.deepOrangeAccent,
                          size: 24.0,
                        ),
                        onPressed: () {
                          Fluttertoast.showToast(
                              msg: "You Have Nothing In Your Cart",
                              fontSize: 16,
                              backgroundColor: Colors.orange[100],
                              textColor: darkThemeBlue,
                              toastLength: Toast.LENGTH_LONG);
                          // do something
                        },
                      ),
                    ),
                  )*/

                  Expanded(
                    flex: 1,
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: /*(_cartId!="")?*/ IconButton(
                          icon: Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                            size: 22.0,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CartPageNew()
                                  // AddressPage()
                                ));
                          },
                        )
                      /*:IconButton(
                        icon: Icon(
                          Icons.remove_shopping_cart_outlined,
                          color: Colors.white,
                          size: 22.0,
                        ),
                        onPressed: () {
                          Fluttertoast.showToast(
                              msg: "You Have Nothing In Your Cart",
                              fontSize: 16,
                              backgroundColor: Colors.orange[100],
                              textColor: darkThemeBlue,
                              toastLength: Toast.LENGTH_LONG);
                          // do something
                        },
                      ),*/
                    ),
                  )
                ],
              ),
            ),
          ),

          //Search TextFiled Container....
          Container(
            height: 45.0,
            alignment: Alignment.topCenter,
            margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: TextField(
              readOnly: true,
              style: TextStyle(fontSize: 14.0),
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: "search",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                  ),
                  border: InputBorder.none),
              onTap: () {
                showSearch(context: context, delegate: SearchPage());
              },
            ),
          ),
        ],
      ),

      // height: preferredSize.height,
      // color: lightThemeBlue,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: lightThemeBlue,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.0)),
      ),
      // child: child,
    );
  }
}
