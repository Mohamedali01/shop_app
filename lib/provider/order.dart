import 'package:flutter/foundation.dart';
import 'cart.dart';

class Order {
  final String id;
  final List<Cart> list;
  final double amount;
  final DateTime dateTime;

  Order(
      {@required this.id,
      @required this.list,
      @required this.amount,
      @required this.dateTime});
}
