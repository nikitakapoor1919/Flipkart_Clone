import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipkart_clone/db/dboperations.dart';
import 'package:flipkart_clone/models/user.dart';
import 'package:flipkart_clone/screens/sign_in.dart';
import 'package:flipkart_clone/screens/userprofile.dart';
import 'package:flipkart_clone/utils/constants.dart';
import 'package:flipkart_clone/utils/gps.dart';
import 'package:flipkart_clone/utils/token.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

final databaseReference = Firestore.instance;
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List<String> UserInformation=[];
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = '';
  void initState() {
    super.initState();
    _UserDetails();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  _UserDetails() async {
    _loginWithGmail();
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
  @override
  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text("Login"),
      centerTitle: true,
    );
  }
  Widget build(BuildContext context) {
    return Container(
        child:Scaffold(
          appBar: _appBar(),
          body: Container(
            //color: Color(Constants.FLIPKART_BLUE),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //  FlutterLogo(size: 150),
                  SizedBox(height: 50),
                  _signInButton(),
                ],
              ),
            ),
          ),
        )
    );
  }
  GoogleSignIn _googleSignIn = GoogleSignIn();
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
    //userObject.refreshToken;
    //userObject.uid
   // print('${userObject.uid},${userObject.displayName}');
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
    return userObject;
  }
  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () async{
        _loginWithGmail();
        // signInWithGoogle().then((result) {
        //   print("Result: $result");
        //   createRecord(result);
        //   print(result.runtimeType);
        //   if (result != null) {
        //     Navigator.of(context).pushReplacement(
        //       MaterialPageRoute(
        //         builder: (context) {
        //           return UserProfile.constructor(result);
        //         },
        //       ),
        //     );
        //   }
        // });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: NetworkImage(Constants.GOOGLE_ICON), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}