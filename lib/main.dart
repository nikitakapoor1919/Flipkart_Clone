import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flipkart_clone/screens/addToCart.dart';
import 'package:flipkart_clone/screens/home_screen.dart';
import 'package:flipkart_clone/screens/i18ndemo.dart';
import 'package:flipkart_clone/screens/list_of_products.dart';
import 'package:flipkart_clone/screens/loginpage.dart';
import 'package:flipkart_clone/screens/sign_in.dart';
import 'package:flipkart_clone/screens/paymentpage.dart';
import 'package:flipkart_clone/screens/splashscreen.dart';
import 'package:flipkart_clone/screens/upload_product.dart';
import 'package:flipkart_clone/utils/constants.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

  //Camera
  // runApp(MaterialApp(
  //     title: 'Camera',
  //    //home: CameraDemo(),
  //    // home: PaymentPage()
  //    // home:ListOfProducts(),
  //       //home:UploadProduct.constructor(),
  //   home:CartPage()
  // )
  // );

  // I18N
  // runApp(
  //   EasyLocalization(
  //       supportedLocales: [Locale('en', 'US'), Locale('hi', 'IN')],
  //       path: 'assets/translations', // <-- change patch to your
  //       fallbackLocale: Locale('hi', 'IN'),
  //       child: MyApp()),
  // );
  // runApp(MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     title: 'Login',
  //     home: LoginPage(),
  // ));

  runApp(MaterialApp(
    title: 'FlipKart Clone',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        backgroundColor: Colors.white,
        appBarTheme:
            AppBarTheme(color: Color(Constants.FLIPKART_BLUE), elevation: 5)),
    //home: SplashScreen(),
    routes: <String, WidgetBuilder>{
      Constants.ROOT_ROUTE: (BuildContext context) => SplashScreen(),
      Constants.HOME_ROUTE: (ctx) => HomeScreen(),
      Constants.LIST_OF_PRODUCTS: (ctx) => ListOfProducts()
    },
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'I18NDemo',
      home: I18NDemo(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}