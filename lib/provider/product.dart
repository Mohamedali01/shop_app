import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app/exceptions/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final String userId;
  bool inCart;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.imageUrl,
      @required this.price,
      @required this.userId,
      this.isFavorite = false});

  Future<void> toggleFutureFavorite(
      String id, String token, String userId) async {
    toggleFavorite();
    http.Response response = await http.put(
        'https://fir-updates-66ba9-default-rtdb.firebaseio.com/usersFavorites/$userId/$id.json?auth=$token',
        body: json.encode(isFavorite));
    if (response.statusCode >= 400) {
      throw HttpException(message: 'HttpException:Favorite error');
    }
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
