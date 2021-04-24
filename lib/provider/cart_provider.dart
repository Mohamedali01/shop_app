import 'package:flutter/material.dart';
import 'cart.dart';

class CartProvider with ChangeNotifier {
  Map<String, Cart> _cartItems = {};

  Map<String, Cart> get cartItems {
    return {..._cartItems};
  }

  int get cartItemsCount {
    return _cartItems.length;
  }

  double get totalAmount {
    double amount = 0;
    _cartItems.forEach((key, value) {
      amount += value.price * value.quantity;
    });
    return amount;
  }

  void addCartItem(String productId, String title, double price) {

    if (_cartItems.containsKey(productId)) {

      _cartItems.update(
        productId,
        (value) => Cart(
          id: value.id,
          price: value.price,
          quantity: value.quantity + 1,
          title: value.title,
        ),
      );
    } else {
      _cartItems.putIfAbsent(
        productId,
        () => Cart(
            id: DateTime.now().toString(),
            title: title,
            price: price,
            quantity: 1),
      );
    }
    notifyListeners();
  }

  void removeItemCart(String id) {
    _cartItems.remove(id);
    notifyListeners();
  }

  void clear() {
    _cartItems = {};
    notifyListeners();
  }

  void removeItem(String key) {
    if (!_cartItems.containsKey(key)) return;
    if (_cartItems[key].quantity > 1) {
      _cartItems.update(
        key,
        (value) => Cart(
          id: value.id,
          title: value.title,
          price: value.price,
          quantity: value.quantity - 1,
        ),
      );
    }else{
      _cartItems.remove(key);
    }
    notifyListeners();
  }
}
