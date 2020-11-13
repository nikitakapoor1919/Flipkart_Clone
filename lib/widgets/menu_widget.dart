import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipkart_clone/models/menu.dart';
import 'package:flipkart_clone/screens/list_of_products.dart';
import 'package:flipkart_clone/screens/loginpage.dart';
import 'package:flipkart_clone/screens/userprofile.dart';
//import 'package:flipkart_clone/screens/sign_in.dart';
import 'package:flipkart_clone/utils/constants.dart';
import 'package:flipkart_clone/utils/token.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MenuWidget extends StatelessWidget {
  List<Menu> menus = [];
  List<int> _selectedItems = List<int>();
  String loc;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  final databaseReference = Firestore.instance;

  List UserInformation=[];
  _loginWithGmail(BuildContext context) async {
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
    print(UserInformation);
    createRecord(UserInformation);
    String token = await userObject.getIdToken();
    Token.generateToken(token);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return UserProfile.constructor(UserInformation);
        },
      ),
    );
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
  //List<double> loc = [];

  MenuWidget(this.menus, this.loc);
  // MenuWidget(List<Menu> menus, ) {
  //   this.menus = menus;
  // }
  Container _makeHeader() {
    return Container(
      color: Color(Constants.FLIPKART_BLUE),
      height: deviceSize.height / 10,
      child: Center(
        child: ListTile(
          leading: Icon(
            Icons.home_filled,
            color: Colors.white,
          ),
          title: Row(
            children: [
              Text(
                'Home',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(
                width: 10,
              ),
              // Expanded(
              //   child: Text(
              //     loc,
              //     //'Lng:${loc[0]} Lat${loc[1]}',
              //     style: TextStyle(fontSize: 12, color: Colors.white),
              //   ),
              // ),
            ],
          ),
          trailing: Image.asset(Constants.FLIPKART_SPLASH_LOGO),
        ),
      ),
    );
  }

  _makeASingleMenu(int index,BuildContext context) {
    // return Text('Hello');
      int iconData = int.parse(menus[index].iconValue);
      return ListTile(
          leading: Icon(IconData(iconData, fontFamily: 'MaterialIcons')),
          title: Text(menus[index].name),
          onLongPress:(){
            print("List Long Press: $_selectedItems");
            if(! _selectedItems.contains(index)){
            _selectedItems.add(index);
            print(_selectedItems);
            if(index==0){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return ListOfProducts();
                  },
                ),
              );
            }
            if(index==1){
              _loginWithGmail(context);
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) {
              //      List info=_loginWithGmail();
              //      //  return _loginWithGmail() != null ?
              //      //  LoginPage():LoginPage();
              //       return LoginPage();
              //     },
              //   ),
              // );
            }
            }
            },
           onTap: (){
             print("List Tap: $_selectedItems");
            if(_selectedItems.contains(index)){
                _selectedItems.removeWhere((val) => val == index);
                print(_selectedItems);
            }
          },
        );
  }

  _makeBody() {
    print("Menu is $menus");
    // return Container(
    //   child: Text('bgsdjgjhdjk'),
    // );
    return ListView.builder(
      shrinkWrap: true,
      itemCount: menus.length,
      itemBuilder: (BuildContext context, int index) {
        return _makeASingleMenu(index,context);
      },
    );
  }

  Size deviceSize;
  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return this.menus != null && this.menus.length > 0
        ? ListView(
      children: [
        _makeHeader(),
        Container(child: _makeBody()),
        Divider(
          color: Colors.black
        ),
        ListTile(
          leading: Icon(Icons.location_on),
          title: Text(loc)
        )
      ],
    )
        : Container(child: Text('Waiting to Load a Menu'));
  }
}