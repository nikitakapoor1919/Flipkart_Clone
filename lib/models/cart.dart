class Cart {
  String _name;
  double _price;
  String _url;
  String imagePath;
  String desc;
  String _status;
  int _qty;
  String _id;

  String get id => _id;

  set id(String value) {
    _id = value;
  }
  String get name => _name;

  set name(String value) {
    _name = value;
  }

  double get price => _price;

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  String get url => _url;

  set url(String value) {
    _url = value;
  }

  set price(double value) {
    _price = value;
  }
  int get qty => _qty;

  set qty(int value) {
    _qty = value;
  }

  @override
  String toString() {
    return 'Cart{_name: $_name, _price: $_price, _url: $_url, imagePath: $imagePath, _status: $_status,_qty : $qty,_id: $id}';
  }
}