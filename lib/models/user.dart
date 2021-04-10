class UserDetails{
  String _name;
  String _address;
  String _pic;
  String _mobile;
  String _uid;

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get pic => _pic;

  set pic(String value) {
    _pic = value;
  }
  String get mobile => _mobile;

  set mobile(String value) {
    _mobile = value;
  }
  String toString() {
    return 'Users{_name: $_name,_uid: $uid, _pic: $_pic, _address: $_address,_mobile:$_mobile}';
  }
}