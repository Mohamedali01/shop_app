import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'cart.dart';
import 'order.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _listOfOrders = [];
  String token;
  String userId;

  List<Order> get listOfOrders {
    return [..._listOfOrders];
  }

  void updatedToken(String newToken, String newUserId) {
    token = newToken;
    userId = newUserId;
  }

  Future<void> addOrders(List<Cart> carts, double amount) async {
    final url =
        'https://fir-updates-66ba9-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token';
    final date = DateTime.now();
    await http.post(
      url,
      body: json.encode(
        {
          'amount': amount,
          'dateTime': date.toIso8601String(),
          'list': carts
              .map((e) => {
                    'id': e.id,
                    'price': e.price,
                    'quantity': e.quantity,
                    'title': e.title
                  })
              .toList()
        },
      ),
    );
  }

  Future<void> fetchOrders() async {
    final url =
        'https://fir-updates-66ba9-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token';
    http.Response response = await http.get(url);
    final data = json.decode(response.body) as Map<String, dynamic>;
    List<Order> loadedOrders = [];
    if (data != null) {
      data.forEach(
        (key, value) {
          final List<dynamic> loadedList = value['list'];
          loadedOrders.add(
            Order(
              id: key,
              list: loadedList
                  .map((product) => Cart(
                      id: product['id'],
                      title: product['title'],
                      price: product['price'],
                      quantity: product['quantity']))
                  .toList(),
              amount: value['amount'],
              dateTime: DateTime.parse(value['dateTime']),
            ),
          );
        },
      );
    }
    _listOfOrders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
