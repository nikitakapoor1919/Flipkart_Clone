import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:flipkart_clone/db/dboperations.dart';
import 'package:flipkart_clone/screens/sign_in.dart';
import 'package:flipkart_clone/utils/constants.dart';
import 'package:flipkart_clone/utils/gps.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipkart_clone/models/user.dart';
import 'home_screen.dart';
import 'loginpage.dart';

final databaseReference = Firestore.instance;
// final ref = FirebaseDatabase.instance.reference().child("users");
class UserProfile extends StatefulWidget {
  List list;
  FirebaseApp app;
  UserProfile(){}
  // UserProfile.constructor(List result){
  //   list=result;
  // }
  UserProfile.constructor(List result, {FirebaseApp app}){
    list=result;
    this.app = app;
  }
  @override
  _UserProfileState createState() => _UserProfileState(list);
}

class _UserProfileState extends State<UserProfile>{
  FirebaseStorage fbs;
  loadFS() {
    fbs = FirebaseStorage.instanceFor(
        app: widget.app, bucket: "gs://flipkart-app-f90aa.appspot.com");
  }

  @override
  initState() {
    super.initState();
    loadFS();
    _loadThings();
    getCurrentUser();
  }
  final auth = FirebaseAuth.instance;
  FirebaseUser currentUser;

  /// Function to get the currently logged in user
  void getCurrentUser() async {
    try {
      currentUser = await auth.currentUser;
      print('currentUser: $currentUser');
    } catch (e) {
      /// You can do something else here if there's an error
      print(e);
    }
  }
  String defPic='https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRHI-ZI1cHMwajaHlBYXmOj1RTJaWbbFHlGOw&usqp=CAU';
  Size deviceSize;
  List<UserDetails> users = [];
  String name,address,uid,loc="",pic,msg,mobile;
  bool pressAttention=false;
  QuerySnapshot querySnapshot;
  _UserProfileState(List list){this.name=list[0]; this.uid=list[1]; print(this.name);}

  _loadThings() async {
    loc = await getLocation();
    users = await DbOperations.fetchUsers();
    users.forEach((element) {
      if(element.uid == this.uid){
        print("Result Found");
        setState(() {
          address=element.address;
          name=element.name;
          pic=element.pic;
          downloadURL=element.pic;
          mobile=element.mobile;
        });
      }
    });
    setState(() {
    //  address=loc.toString();
    });
  }
  File imageFile;
  _openCameraOrGallery(String param) async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile =
    await imagePicker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedFile.path);
    print("Image Path is $imageFile");
    setState(() {});
    _uploadImage();
  }

  String imagePath;
  String downloadURL;
  _uploadImage() {
    imagePath = "images/${DateTime.now()}.jpg";
    Reference ref = fbs.ref().child(imagePath);
    UploadTask uploadTask = ref.putFile(imageFile);
    uploadTask.then((TaskSnapshot tasksnapshot) async {
      downloadURL = await tasksnapshot.ref.getDownloadURL();
      print("DOWNLOAD URL IS $downloadURL");
      setState(() {
        msg = "File Uploaded $downloadURL";
      });
    }).catchError((err) => setState(() {
      msg = "Error in Upload $err";
    }));
    if (uploadTask.snapshot.state == TaskState.success) {
      setState(() {
        msg = "File Uploaded ";
      });
    } else {
      msg = "File Not Uploaded....";
    }
  }

  void choiceAction(String choice){
    print(choice);
    if(choice == "SignOut"){
      signOutGoogle();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {return HomeScreen();}
          ),
          ModalRoute.withName('/'));
    }
  }
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your Changes are Saved Successfully'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomeScreen()
          ));
        }
      ),
      //leading: Icon(Icons.menu),
      title: Text("My Account"),
      centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context){
              return Constants.choices.map((String choice){
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),);
              })
                  .toList();
            }
            ,)]
    );
  }
  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: new Center(
            child: new Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top:20,bottom:5),
                  child: new Container(
                      width: 190.0,
                      height: 190.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(
                                  this.downloadURL==null ?'$defPic':this.downloadURL
                              )
                          )
                      )),
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt_rounded),
                  color: Colors.black54,
                  onPressed: () { _openCameraOrGallery("");},
                ),
                Padding(
                  padding: EdgeInsets.only(right:40,left:40,top:20),
                  child: TextField(
                    //enabled: false,
                    onChanged: (text) {
                      name=text;
                      print(text);
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                        hintText: '$name', //eg. John Doe
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right:40,left:40,top:20),
                  child: TextField(
                    onChanged: (text) {
                      address=text;
                      print(text);
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.home),
                       // labelText: 'Delivery Address',
                        border: OutlineInputBorder(),
                        hintText:' ${address == null ?loc.toString():address}'
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right:40,left:40,top:20),
                  child: TextField(
                    onChanged: (text) {
                      mobile=text;
                      print(text);
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                       // labelText: 'Mobile Number',
                        hintText:' ${mobile==null ? 'eg. 9999999999':mobile}'
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right:40,left:40,top:20),
                  child: RaisedButton(
                    onPressed:(){
                      databaseReference
                          .collection('users')
                          .document(uid)
                          .updateData({
                        'name': this.name,
                        'address':this.address,
                        'pic':this.downloadURL,
                        'mobile':this.mobile
                      });
                      print('Data updated Successfully');
                      _showMyDialog();
                    },
                    textColor: Colors.white,
                    child:new Text(
                      "Save",
                      style: new TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    color: Colors.blueAccent,
                  )
                ),
        ],
            )),
      )
    );
  }
}

