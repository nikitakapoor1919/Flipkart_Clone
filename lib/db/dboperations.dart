import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipkart_clone/models/menu.dart';
import 'package:flipkart_clone/models/product.dart';
import 'package:flipkart_clone/models/user.dart';

class DbOperations {
  _DbOperations() {}
  static Future<String> addProduct(Product product) async {
    DocumentReference docRef;
    CollectionReference collectionReference =
    FirebaseFirestore.instance.collection('products');
    Map<String, dynamic> map = {
      "name": product.name,
      "desc": product.desc,
      "price": product.price,
      "image": product.imagePath
    };
    try {
      docRef = await collectionReference.add(map);
    } catch (e) {
      return "Error in Record Add $e";
    }
    return "Record added ${docRef.id}";
  }

  static Query fetchProducts() {
    Query query = FirebaseFirestore.instance.collection('products');
    String filterOrOrder = "ascending";
    return query;
  }


  static Future<List<Product>> fetchDeals() async {
    List<Product> deals = [];
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('deals').get();
    querySnapshot.docs.forEach((doc) {
      Product product = Product();
      product.name = doc['name'];
      product.url = doc['url'];
      product.imagePath = doc['image'];
      deals.add(product);
    });
    return deals;
  }

  static Future<List<Product>> fetchCategories() async {
    List<Product> categories = [];
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('categories').get();
    querySnapshot.docs.forEach((doc) {
      Product product = Product();
      product.name = doc['name'];
      product.url = doc['url'];
      product.imagePath = doc['image'];
      categories.add(product);
    });
    return categories;
  }

  static Future<List<Product>> fetchAds() async {
    List<Product> ads = [];
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('ads').get();
    querySnapshot.docs.forEach((doc) {
      Product product = Product();
      product.name = doc['name'];
      product.url = doc['url'];
      product.imagePath = doc['imagepath'];
      ads.add(product);
    });
    return ads;
  }

  static Future<List<Menu>> fetchMenus() async {
    List<Menu> menus = [];
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('menus').get();
    querySnapshot.docs.forEach((doc) {
      Menu menu = Menu();
      menu.name = doc['name'];
      menu.url = doc['url'];
      menu.iconValue = doc['iconValue'];
      menu.status = doc['status'];
      menus.add(menu);
    });
    return menus;
  }
  static Future<List<UserDetails>> fetchUsers() async {
    List<UserDetails> users = [];
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('users').get();
    querySnapshot.docs.forEach((doc) {
      UserDetails user = UserDetails();
      user.name = doc['name'];
      user.pic = doc['pic'];
      user.address = doc['address'];
      users.add(user);
    });
    print(users);
    return users;
  }
}