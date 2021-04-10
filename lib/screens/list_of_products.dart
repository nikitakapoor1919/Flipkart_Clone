import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flipkart_clone/db/dboperations.dart';
import 'package:flipkart_clone/models/cart.dart';
import 'package:flipkart_clone/models/product.dart';
import 'package:flipkart_clone/screens/single_product_display.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class ListOfProducts extends StatefulWidget {
  @override
  _ListOfProductsState createState() => _ListOfProductsState();
}

class _ListOfProductsState extends State<ListOfProducts> {
  String searchString='';
  final myController = TextEditingController();
  List<Cart> cartList=[];
  String groupValue = "mygroup";
  String NoPic='https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRJEK40TRPKbM5JcPw1M6F8ayHInpCGrTNSrg&usqp=CAU';
  final NumberFormat numberFormat = NumberFormat("#,##,###0.0#", "en_US");
  _appbar() {
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
                  controller:myController,
                  onChanged: (val) {
                    searchString=val.toLowerCase();
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search For Products, Brands and More',
                    // suffixIcon: IconButton(
                    //     icon:Icon(Icons.clear),
                    //     onPressed:()=>{
                    //       //myController.clear()
                    //       setState((){
                    //         myController.clear();
                    //       })
                    //   }
                    // ),
                  ),
                ),
              ),
              ],
            ),
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: (){
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomeScreen()
          ));
        }
      ),
      title: Text("Deals"),
    );
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
                Text('Item added to Cart'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                // Navigator.of(context).pushReplacement(MaterialPageRoute(
                //     builder: (context) => HomeScreen()
                // ));
              },
            ),
          ],
        );
      },
    );
  }
  _displayBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext ctx) {
          return Container(
            height: deviceSize.height / 2,
            child: Column(
              children: [
                Container(
                  child: Text(
                    'SORT BY',
                    style: TextStyle(fontSize: 32),
                  ),
                ),
                RadioListTile(

                    value: "Descending",

                    groupValue: groupValue,
                    onChanged: (value) {

                    },
                    title: Text('Descending')
                ),


                RadioListTile(
                    title: Text('Price Low to High'),
                    value: "Price Low to High",
                    groupValue: groupValue,
                    onChanged: (value) {}),
                RadioListTile(
                    title: Text('Price High to Low'),
                    value: "Price High to Low",
                    groupValue: groupValue,
                    onChanged: (value) {}),
              ],
            ),
          );
        });
  }
  String msg = "";
  _AddToCart(name,imagepath,price) async{
    Cart product = Cart();
    product.name = name;
    product.imagePath =imagepath;
    product.price=price;
    cartList.add(product);
    print("Product DETAIL IS $product");
    String result = await DbOperations.addToCart(product);
    setState(() {
      msg = result;
    });
    print("Db Message: $msg");
  }
  Size deviceSize;
  @override
  Widget build(BuildContext context) {
    print('$searchString');
    deviceSize = MediaQuery.of(context).size;
    Query query = DbOperations.fetchProducts();
    return Scaffold(
      appBar: _appbar(),
      body: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FlatButton.icon(
                    onPressed: () {
                      _displayBottomSheet();
                    },
                    icon: Icon(Icons.sort),
                    label: Text("Sort")),
                Container(width: 2, height: 20, color: Colors.blueGrey),
                FlatButton.icon(
                    onPressed: () {
                      _displayBottomSheet();
                    },
                    icon: Icon(Icons.filter),
                    label: Text("Filter"))
              ],
            ),
            Divider(
              color: Colors.blueGrey,
              height: 20,
              thickness: 3,
            ),
            Expanded(
                child: StreamBuilder(
                  stream: (searchString==null||searchString.trim()==''||searchString=='')?
                  Firestore.instance.collection('products').snapshots():
                  Firestore.instance.collection('products').where('caseSearch',arrayContains:searchString).snapshots(),
                  builder: (BuildContext ctx, AsyncSnapshot stream) {
                    if (stream.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (stream.hasError) {
                      return Center(
                        child: Text(
                          'Some Error Occur',
                          style: TextStyle(fontSize: 24, color: Colors.red),
                        ),
                      );
                    }
                    // U Get the data
                    QuerySnapshot querySnapShot = stream.data;
                    return GridView.builder(
                        itemCount: querySnapShot.size,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: deviceSize.width / deviceSize.height),
                        itemBuilder: (BuildContext c, int index) {
                          // filled up
                          DocumentSnapshot documentSnapShot =
                          querySnapShot.docs[index];
                          Map<String, dynamic> datamap = documentSnapShot.data();
                          Product product = Product();
                          product.name = datamap["name"];
                          product.price = double.parse(datamap["price"].toString());

                          product.imagePath = datamap['image'];
                          product.desc = datamap['desc'];
                          return Card(
                            child: Column(
                              children: [
                                Image.network(product.imagePath!=null ? product.imagePath:'$NoPic',
                                  height:170,fit:BoxFit.fill),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => SingleProductDisplay()),
                                    );
                                  },
                                  child: Padding(
                                      padding:EdgeInsets.all(5),
                                      child:Text(product.name,
                                        //overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontWeight: FontWeight.bold)
                                      ),
                                  ),
                                ),
                                Padding(
                                    padding:EdgeInsets.all(10),
                                    child: Text(
                                        product.desc,
                                        maxLines:5
                                    )
                                ),
                                Expanded(
                                  child:Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.baseline,
                                      children: [
                                        Text(
                                          "\u{20B9}${numberFormat.format(product.price)}",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                        RaisedButton(
                                                child: Text('Add To Cart'),
                                                textColor: Colors.white,
                                                color:Colors.blueAccent,
                                                onPressed:() async{
                                                  Cart cart = Cart();
                                                  cart.name = product.name;
                                                  cart.imagePath =product.imagePath;
                                                  cart.price=product.price;
                                                  cartList.add(cart);
                                                  print("Product DETAIL IS $cart");
                                                  String result = await DbOperations.addToCart(cart);
                                                  if(result!=null)
                                                    print("Product uploaded successfully");
                                                 // print("List: $cartList");
                                                  _showMyDialog();
                                                },
                                        ),
                                      ],
                                    ),
                                  )
                                )
                              ],
                            )
                          );
                        });
                  },
                ))
          ],
        ),
      ),
    );
  }
}