import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flipkart_clone/db/dboperations.dart';
import 'package:flipkart_clone/models/cart.dart';
import 'package:flipkart_clone/models/product.dart';
import 'package:flutter/material.dart';


class ProductsWidget extends StatefulWidget {
  String searchString='';

  ProductsWidget(this.searchString);
  //ProductWidget(String searchString){this.searchString=searchString;}
  @override
  _ProductsWidgetState createState() => _ProductsWidgetState(searchString);
}

class _ProductsWidgetState extends State<ProductsWidget> {
  String searchString='';
  _ProductsWidgetState(this.searchString);
  List<Cart> cartList=[];
  String groupValue = "mygroup";
  String NoPic='https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRJEK40TRPKbM5JcPw1M6F8ayHInpCGrTNSrg&usqp=CAU';
  final NumberFormat numberFormat = NumberFormat("#,##,###0.0#", "en_US");

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
    deviceSize = MediaQuery.of(context).size;
    Query query = DbOperations.fetchProducts();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Flexible(
            child: Column(
              children: [
                Expanded(
                    child: StreamBuilder(
                      stream: (searchString==null||searchString.trim()=='')?
                          query.snapshots():
                      query.where('caseSearch',arrayContains:searchString).snapshots(),
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
                                      Padding(
                                        padding:EdgeInsets.all(5),
                                        child:Text(product.name,
                                            //overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontWeight: FontWeight.bold)
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
        ),
      ),
    );
  }
}