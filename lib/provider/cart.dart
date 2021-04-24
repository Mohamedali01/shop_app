import 'package:flutter/material.dart';

class Cart {
  final String id;
  final double price;
  final int quantity;
  final String title;

  Cart(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.quantity});
}
