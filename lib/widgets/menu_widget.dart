import 'package:flipkart_clone/models/menu.dart';
import 'package:flipkart_clone/screens/loginpage.dart';
//import 'package:flipkart_clone/screens/sign_in.dart';
import 'package:flipkart_clone/utils/constants.dart';
import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  List<Menu> menus = [];
  List<int> _selectedItems = List<int>();
  String loc;
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
            if(index==1){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return LoginPage();
                  },
                ),
              );
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