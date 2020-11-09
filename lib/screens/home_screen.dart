import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipkart_clone/db/dboperations.dart';
import 'package:flipkart_clone/models/menu.dart';
import 'package:flipkart_clone/models/product.dart';
import 'package:flipkart_clone/screens/loginpage.dart';
import 'package:flipkart_clone/screens/paymentpage.dart';
import 'package:flipkart_clone/utils/constants.dart';
import 'package:flipkart_clone/utils/gps.dart';
import 'package:flipkart_clone/widgets/menu_widget.dart';
import 'package:flipkart_clone/widgets/slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flipkart_clone/widgets/category_widget.dart';
import 'package:flipkart_clone/widgets/deals_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 // String text1=tr('searchMsg');
  bool flag = false;
  List<Product> deals = [];
  List<Menu> menus = [];
  //List<double> loc = [];
  String loc = "";
  List<Product> ads = [];
  List<Product> categories = [];
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
  Future getCurrentUser() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser;
    print("User: ${_user.displayName ?? "None"}");
    return _user;
  }
  _loadThings() async {
    menus = await DbOperations.fetchMenus();
    loc = await getLocation();
    ads = await DbOperations.fetchAds();
    categories = await DbOperations.fetchCategories();
    deals = await DbOperations.fetchDeals();
    print("Menus $menus");
    setState(() {});
  }

  AppBar _appBar() {
    return AppBar(
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(deviceSize.height / 10),
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [Container(
                color: Colors.white,
                alignment: Alignment.center,
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search For Products, Brands and More'
                  ),
                ),
              ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        Icon(Icons.notifications),
        Padding(
            padding: EdgeInsets.only(right: 20, left: 20),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Colors.white,
              onPressed: () {Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    print('Value: ${getCurrentUser()}');
                    return getCurrentUser() != null ?
                    PaymentPage():LoginPage();
                  },
                ),
              );
              },
              ),
        )
      ],
      //leading: Icon(Icons.menu),
      title: Image.asset(
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
          DealsWidget(deals)
        ],
      ),
    );
  }
}