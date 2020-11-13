import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipkart_clone/db/dboperations.dart';
import 'package:flipkart_clone/models/cart.dart';
import 'package:flipkart_clone/models/menu.dart';
import 'package:flipkart_clone/models/product.dart';
import 'package:flipkart_clone/screens/loginpage.dart';
import 'package:flipkart_clone/screens/paymentpage.dart';
import 'package:flipkart_clone/utils/constants.dart';
import 'package:flipkart_clone/utils/gps.dart';
import 'package:flipkart_clone/widgets/menu_widget.dart';
import 'package:flipkart_clone/widgets/products-widget.dart';
import 'package:flipkart_clone/widgets/slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flipkart_clone/widgets/category_widget.dart';
import 'package:flipkart_clone/widgets/deals_widget.dart';
import 'package:easy_localization/easy_localization.dart';
//import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'addToCart.dart';
import 'list_of_products.dart';




class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final myController = TextEditingController();
 // String text1=tr('searchMsg');
  String searchString='';
  bool flag = false;
  List<Product> deals = [];
  List<Menu> menus = [];
  //List<double> loc = [];
  String loc = "";
  List<Product> ads = [];
  List<Cart> carts=[];
  List<Product> categories = [];
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = '';
  @override
  void initState() {
    super.initState();
    _loadThings();
  }

  _changeLang() {
    if (flag) {
      EasyLocalization.of(context).locale = Locale('en', 'US');
    } else {
      EasyLocalization.of(context).locale = Locale('hi', 'IN');
    }
    flag = !flag;
  }

  _loadThings() async {
    //await DbOperations.getDocs();
    menus = await DbOperations.fetchMenus();
    carts = await DbOperations.fetchCarts();
    loc = await getLocation();
    ads = await DbOperations.fetchAds();
    categories = await DbOperations.fetchCategories();
    deals = await DbOperations.fetchDeals();
    print('Cart: $carts');
    print("Menus $menus");
    setState(() {});
  }

  AppBar _appBar() {
    int counter=int.parse('${carts.length}');
    return AppBar(
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(deviceSize.height / 7),
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [Container(
                color: Colors.white,
                alignment: Alignment.center,
                child: TextField(
                  controller:myController,
                  onChanged: (val) {
                    searchString=val.toLowerCase();
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: tr('searchMsg'),
                      //'Search For Products, Brands and More',
                      // suffixIcon: IconButton(
                      //   icon:Icon(Icons.clear),
                      //   onPressed:()=>{
                      //     myController.clear()
                      //   //searchString=null
                      //   }
                      // ),
                  ),
                ),
              ),
                RaisedButton(
                  onPressed: () {
                    _changeLang();
                  },
                  child: Text('Change Language'),
                )
              ],
            ),
          ),
        ),
      ),
      actions: [
        Padding(
            padding: EdgeInsets.only(top:10),
            child: Stack(children: [Icon(Icons.notifications)])
        ),
        Padding(
            padding: EdgeInsets.only(right: 20, left: 10),
            child:Stack(
                children: [IconButton(
                  icon: Icon(Icons.shopping_cart),
                  color: Colors.white,
                  onPressed: () {
                    print('Cart: $carts');
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return CartPage(carts);
                        },
                      ),
                    );
                  },
                ),
                  counter != 0 ? new Positioned(
                    right: 11,
                    top: 11,
                    child: new Container(
                      padding: EdgeInsets.all(2),
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        '$counter',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ) : new Container()
                ]
            )
        )
      ],
      //leading: Icon(Icons.menu),
      title:
      Image.asset(
        Constants.FLIPKART_LOGO,
        height: deviceSize.height / 3,
        width: deviceSize.width / 4,
      ),
    );
  }

  Size deviceSize;
  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      drawer: Drawer(
        child: MenuWidget(menus, loc),
      ),
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: ListView(
        children: [
          SliderWidget(ads),
          CategoryWidget(categories),
          DealsWidget(deals,flag),
         // ProductsWidget(searchString)
        ],
      ),
    );
  }
}