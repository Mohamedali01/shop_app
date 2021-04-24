import 'package:flutter/material.dart';
import '../exceptions/http_exception.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductsProvider with ChangeNotifier {
  String token;
  String userId;

  void updatedToken(String newToken, String newUserId) {
    token = newToken;
    userId = newUserId;
  }

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //     id: 'p2',
    //     title: 'Skirts',
    //     description: 'A nice skirt.',
    //     price: 70.99,
    //     imageUrl:
    //         'https://images-na.ssl-images-amazon.com/images/I/71ElLga-12L._AC_UL1500_.jpg'),
    // Product(
    //     id: 'p3',
    //     title: 'Trousers',
    //     description: 'A nice pair of trousers.',
    //     price: 59.99,
    //     imageUrl:
    //         'https://allensolly.imgix.net/img/app/product/2/209185-653175.jpg'),
    // Product(
    //   id: 'p4',
    //   title: 'PS5',
    //   description: 'A nice ps!',
    //   price: 1000.0,
    //   imageUrl:
    //       'https://m.alwafd.news/images/news/897d2465d90d8e594515478b23333ff2.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favList {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product getById(String mId) {
int index = _items.indexWhere((element) => element.id == mId);
return _items[index];
  }

  Future<void> addProduct(Product product) async {
    try {
      await http.post(
        'https://fir-updates-66ba9-default-rtdb.firebaseio.com/products.json?auth=$token',
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'userId': userId
          },
        ),
      );
      await fetchProducts();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchProducts([bool fetchById = false]) async {
    String url;
    if (fetchById == false) {
      url =
          'https://fir-updates-66ba9-default-rtdb.firebaseio.com/products.json?auth=$token';
    } else {
      url =
          'https://fir-updates-66ba9-default-rtdb.firebaseio.com/products.json?auth=$token&orderBy="userId"&equalTo="$userId"';
    }
    try {
      http.Response response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedList = [];
      url =
          'https://fir-updates-66ba9-default-rtdb.firebaseio.com/usersFavorites/$userId.json?auth=$token';
      final favRes1 = await http.get(url);
      final favRes2 = json.decode(favRes1.body);
      data.forEach(
        (key, value) {
          loadedList.add(
            Product(
              id: key,
              title: value['title'],
              userId: userId,
              description: value['description'],
              imageUrl: value['imageUrl'],
              price: value['price'],
              isFavorite: favRes2 == null
                  ? false
                  : (favRes2[key] == null ? false : favRes2[key]),
            ),
          );
        },
      );
      _items = loadedList;
      notifyListeners();
    } catch (error) {
      print('provider1 : ${error.toString()} ');
      throw error;
    }
  }

  Future<void> updateProduct(Product product) async {
    final String url =
        'https://fir-updates-66ba9-default-rtdb.firebaseio.com/products/${product.id}.json?auth=$token';
    await http.patch(
      url,
      body: json.encode(
        {
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        },
      ),
    );
    await fetchProducts();
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final String url =
        'https://fir-updates-66ba9-default-rtdb.firebaseio.com/products/$id.json?auth=$token';
    final index = _items.indexWhere((element) => element.id == id);
    var product = _items[index];
    _items.removeAt(index);
    notifyListeners();
    http.Response response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(index, product);
      notifyListeners();
      throw HttpException(message: 'Deleting failed!');
    }
    product = null;
  }
}
