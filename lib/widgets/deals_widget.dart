import 'package:easy_localization/easy_localization.dart';
import 'package:flipkart_clone/models/product.dart';
import 'package:flipkart_clone/screens/list_of_products.dart';
import 'package:flutter/material.dart';

class DealsWidget extends StatefulWidget {
  List<Product> deals = [];
  bool flag = false;
  DealsWidget(this.deals,this.flag);

  @override
  _DealsWidgetState createState() => _DealsWidgetState(deals,flag);
}

class _DealsWidgetState extends State<DealsWidget> {
  bool flag = false;
  List<Product> deals = [];
  _DealsWidgetState(this.deals,this.flag);

  _changeLang() {
    if (flag) {
      EasyLocalization.of(context).locale = Locale('en', 'US');
    } else {
      EasyLocalization.of(context).locale = Locale('hi', 'IN');
    }
    flag = !flag;
  }

  Container buildSingleDeal(int index) {
    return Container(
      height: deviceSize.height / 2,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              widget.deals[index].imagePath,
              // height: deviceSize.height / 4,
              // width: deviceSize.width / 4,
                height:150,
                width:150
            ),
            Text(widget.deals[index].name),
            Text(widget.deals[index].price ?? '₹900')
          ],
        ),
      )
    );
  }

  Size deviceSize;

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        height: deviceSize.height / 1.5,
        child: Stack(
          children: [
            Container(
              color: Colors.tealAccent,
              height: deviceSize.height / 1.5,
            ),
            Container(
              //padding: EdgeInsets.only(right: 10, top: 4, left: 90),
              width: deviceSize.width,
              height: deviceSize.height / 10,
              //alignment: Alignment.topCenter,
              child: Image.network(
                  'https://freeiconshop.com/wp-content/uploads/edd/alarm-flat.png'),
            ),
            Positioned(
              top: deviceSize.height / 70,
              left: 0,
              child: Column(
                children: [
                  Container(
                    // Add this change
                    width: deviceSize.width,
                    padding: EdgeInsets.all(0),
                    child: Row(
                      children: [
                        Padding(
                          padding:EdgeInsets.only(bottom: 40),
                          child: Column(
                            children: [
                              Text(
                                tr('deals'),
                                //'Deals of the Day',
                                style: TextStyle(fontSize: 18),
                              ),
                              Row(children: [
                                Icon(Icons.access_time),
                                Text('19h 18m Remaining')
                              ])
                            ],

                            //crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ),
                      ],
                      //mainAxisAlignment: MainAxisAlignment.start,
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.,
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      width: deviceSize.width - 10,
                      height: deviceSize.height / 1.5,
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemBuilder: (BuildContext ctx, int index) {
                          //return Text('Hi');
                          return buildSingleDeal(index);
                        },
                        itemCount: widget.deals.length,
                      ),
                    ),
                  )
                ],
                // Grid
                mainAxisAlignment: MainAxisAlignment.start,
              ),
            ),
            Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.only(right: 20),
              child: MaterialButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ListOfProducts();
                      },
                    ),
                  );
                },
                child: Text('View All'),
              ),
            )
          ],
        ),
      ),
    );
  }
}