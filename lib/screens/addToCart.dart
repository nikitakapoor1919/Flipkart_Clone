import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipkart_clone/models/cart.dart';
import 'package:flipkart_clone/screens/paymentpage.dart';
import 'package:flutter/material.dart';
import 'package:flipkart_clone/utils/CustomTextStyle.dart';
import 'package:flipkart_clone/utils/CustomUtils.dart';

import 'home_screen.dart';

// import 'CheckOutPage.dart';

class CartPage extends StatefulWidget {
  List<Cart> cart = [];
  List<String> item=[];
  CartPage(this.cart);
  CartPage.constructor(this.cart,this.item);
  @override
  //_CartPageState createState() => _CartPageState(cart);
  _CartPageState createState() => _CartPageState.constructor(cart,item);
}

class _CartPageState extends State<CartPage> {
  int items;
  int count;
  List<String> indexArray=[];
  final databaseReference = Firestore.instance;
  int sum=0;
  List<Cart> cart = [];
  _CartPageState.constructor(this.cart,this.indexArray);
  _CartPageState(List cart){
    this.cart=cart;
    print(cart);
    items=cart.length;
  }
  @override
  void initState() {
    super.initState();
    setState((){
      items=cart.length;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      body: Builder(
        builder: (context) {
          print('My Cart: $cart');
          return ListView(
            children: <Widget>[
              createHeader(),
              createSubTitle(),
              createCartList(context),
              footer(context)
            ],
          );
        },
      ),
    );
  }


  footer(BuildContext context) {
    return items !=0 ? Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: <Widget>[
          //     Container(
          //       margin: EdgeInsets.only(left: 30),
          //       child: Text(
          //         "Total",
          //         style: CustomTextStyle.textFormFieldMedium
          //             .copyWith(color: Colors.grey, fontSize: 15),
          //       ),
          //     ),
          //     Container(
          //       margin: EdgeInsets.only(right: 30),
          //       child: Text(
          //         "₹$sum",
          //         style: CustomTextStyle.textFormFieldBlack.copyWith(
          //             color: Colors.greenAccent.shade700, fontSize: 16),
          //       ),
          //     ),
          //   ],
          // ),
          Utils.getSizedBox(height: 8),
          RaisedButton(
            onPressed: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => PaymentPage(sum.toString())));
            },
            color: Colors.green,
            padding: EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24))),
            child: Text(
              "Checkout",
              style: CustomTextStyle.textFormFieldSemiBold
                  .copyWith(color: Colors.white),
            ),
          ),
          Utils.getSizedBox(height: 8),
        ],
      ),
      margin: EdgeInsets.only(top: 16),
    ): new Container();
  }

  createHeader() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () async{
          print('IndexArray: $indexArray');
          await indexArray.forEach((element) async {
            await Firestore.instance.collection('carts').document(element).delete();
          });
         // Navigator.of(context).pop()
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomeScreen()
          ));
        },
      ),
      title: Text("My Cart"),
    );
  }

  createSubTitle() {
    return Container(
      alignment: Alignment.topLeft,
      child: Padding(
        padding:EdgeInsets.all(5),
        child: Text(
          "Total(${cart.length}) Items",
          style: CustomTextStyle.textFormFieldBold
              .copyWith(fontSize: 14, color: Colors.grey),
        ),
      ),
      margin: EdgeInsets.only(left: 12, top: 4),
    );
  }

  createCartList(BuildContext context)  {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, position) {
        return createCartListItem(position,context);
      },
      itemCount: items,
    );
  }


  createCartListItem(int index,BuildContext context) {
    if(items!=0) {
      String id = '${cart[index].id}';
      var map=cart[index];
      //print('Id: ${_getId(id)}');
      count = cart[index].qty;
      print(count);
      // sum =sum+ int.parse('${cart[index].price}'.split('.')[0])*
      //     int.parse('${cart[index].qty}');
      // setState((){
      //  this. sum =sum;
      // });
      print('Sum ${sum}');
      return Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16))),
            child: Row(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(
                        right: 8, left: 8, top: 8, bottom: 8),
                    width: 80,
                    height: 80,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(
                                '${cart[index].imagePath}'
                            )
                        )
                    )

                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 8, top: 4),
                          child: Text(
                            '${cart[index].name}',
                            //"NIKE XTM Basketball Shoeas",
                            maxLines: 2,
                            softWrap: true,
                            style: CustomTextStyle.textFormFieldSemiBold
                                .copyWith(fontSize: 14),
                          ),
                        ),
                        Utils.getSizedBox(height: 6),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "${cart[index].price}",
                                style: CustomTextStyle.textFormFieldBlack
                                    .copyWith(color: Colors.green),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    // IconButton(
                                    //     icon: Icon(
                                    //       Icons.remove,
                                    //       size: 24,
                                    //       color: Colors.grey.shade700,
                                    //     ),
                                    //     onPressed: () async {
                                    //       int val=--count;
                                    //       print('Doc is: ${cart[index].id}');
                                    //       val>0 ?await databaseReference
                                    //           .collection('carts')
                                    //           .document(cart[index].id)
                                    //           .updateData({
                                    //         'qty': val,
                                    //       }):
                                    //       // indexArray.add(cart[index].id);
                                    //       // print(indexArray);
                                    //       // _doThis(map);
                                    //       // print('Data updated Successfully');
                                    //       '';
                                    //     }
                                    // ),
                                    Container(
                                      color: Colors.grey.shade200,
                                      padding: const EdgeInsets.only(
                                          bottom: 2, right: 12, left: 12),
                                      child: MaterialButton(
                                        child: new StreamBuilder(
                                            stream: Firestore.instance
                                                .collection('carts').document(
                                                cart[index].id).snapshots(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return new Text("Loading");
                                              }
                                              var userDocument = snapshot.data;
                                              return new Text(
                                               // '1',
                                               ' ${userDocument["qty"]}',
                                                style:
                                                CustomTextStyle
                                                    .textFormFieldSemiBold,
                                              );
                                            }
                                        ),
                                        minWidth: 5,
                                      ),
                                    ),
                                    // IconButton(
                                    //     icon: Icon(
                                    //       Icons.add,
                                    //       size: 24,
                                    //       color: Colors.grey.shade700,
                                    //     ),
                                    //     onPressed: () async {
                                    //       int val=++count;
                                    //       await databaseReference
                                    //           .collection('carts')
                                    //           .document(cart[index].id)
                                    //           .updateData({
                                    //         'qty': val
                                    //       });
                                    //       print('Data updated Successfully');
                                    //     }
                                    // )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  flex: 100,
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 10, top: 8),
              child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 15,
                  ),
                  onPressed: () {
                    indexArray.add(cart[index].id);
                    print(indexArray);
                    _doThis(map);
                   }

              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: Colors.green),
            ),
          )
        ],
      );
    }
    else
      new Container();
  }
  _doThis(var map){
     cart.remove(map);
      print('After remove $cart');
    //await Firestore.instance.collection('carts').document(cart[index].id).delete();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CartPage.constructor(cart,indexArray)));
  }

}