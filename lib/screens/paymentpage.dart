import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipkart_clone/db/dboperations.dart';
import 'package:flipkart_clone/models/user.dart';
import 'package:flipkart_clone/utils/gps.dart';
import 'package:flipkart_clone/utils/token.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'loginpage.dart';

class PaymentPage extends StatefulWidget {
  String amount;
  PaymentPage(this.amount);
  @override
  _PaymentPageState createState() => _PaymentPageState(amount);
}

class _PaymentPageState extends State<PaymentPage> {
  String amount;
  _PaymentPageState(this.amount);
  Razorpay _razorpay;
  String msg = "";
  _payNow() {
    const options = {
      'key': 'rzp_test_IDIL24OkbCajIY',
      'amount': '20',
      'name': 'Nikita Kapoor',
      'description': 'Test Payment',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'}
    };
    _razorpay.open(options);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, successPayment);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, errorInPayment);
    _loadThings();
  }

  errorInPayment(PaymentFailureResponse response) {
    setState(() {
      msg = "Payment Fail $response";
    });
  }

  successPayment(PaymentSuccessResponse response) {
    String payId = response.paymentId;
    String orderId = response.orderId;
    msg = "Payment Success $payId $orderId";
  }
  AppBar _appBar() {
    return AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("CheckOut"),
    );
  }
  List<UserDetails> users = [];
  String name,address,mobile,loc,uid;

  _loadThings() async {
   await _loginWithGmail();
    loc = await getLocation();
    users = await DbOperations.fetchUsers();
    users.forEach((element) {
      if(element.uid == this.uid){
        print("Result Found");
        setState(() {
          address=element.address;
          name=element.name;
          mobile=element.mobile;
        });
      }
      else
          print("No Result");
    });
     }
  Size deviceSize;
  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _appBar(),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding:EdgeInsets.all(30),
                  child: Container(
                    width: deviceSize.width/0.2,
                    //height: 200,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          Padding(
                            padding: EdgeInsets.only(right:40,left:40,top:20),
                            child: TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.home),
                                //labelText: 'Delivery Address',
                                border: OutlineInputBorder(),
                                  hintText:' ${address}'
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: (deviceSize.width/3+20)),
              child: RaisedButton(
                onPressed: () {
                  // print('User: ${FirebaseAuth.instance.currentUser}');
                  // if(FirebaseAuth.instance.currentUser != null)
                  //   _payNow();
                  // else
                  // {
                  //   Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //       builder: (context) => LoginPage()
                  //   ));
                  // }
                  final FirebaseAuth auth = FirebaseAuth.instance;
                  final User user = auth.currentUser;
                  final uid = user.uid;
                  if(uid != null)
                    _payNow();
                  else
                  {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => LoginPage()
                    ));
                  }

                },
                child: Text(
                  'PayNow',
                  style: TextStyle(fontSize: 15),
                ),
                textColor: Colors.white,
                color: Colors.blueAccent,
              ),
            )
          ],
        ),
      ),
    );
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  List UserInformation=[];
  _loginWithGmail() async {
    GoogleSignInAccount _googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _googleSignInAuth =
    await _googleSignInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: _googleSignInAuth.accessToken,
        idToken: _googleSignInAuth.idToken);
    UserCredential userCredential =
    await _auth.signInWithCredential(credential);
    User userObject = userCredential.user;
    print("User Info  is $userObject");
    UserInformation.add(userObject.displayName);
    UserInformation.add(userObject.uid);
    createRecord(UserInformation);
    setState(() {
      uid=userObject.uid;
      name=userObject.displayName;
    });
    print(UserInformation);
    String token = await userObject.getIdToken();
    Token.generateToken(token);
    return UserInformation;
  }

  void createRecord(List list) async {
    await Firestore.instance.document("users/${list[1]}").get().then((doc) {
      if (doc.exists)
        return;
      else
      {
        databaseReference.collection("users")
            .document(list[1])
            .setData({
          'uid':list[1],
          'name':list[0],
          'address' : null,
          'pic':null
        });
      };
    });
  }
}