import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';
import '../provider/order_provider.dart';

class FlatButtonWidget extends StatefulWidget {
  @override
  _FlatButtonWidgetState createState() => _FlatButtonWidgetState();
}

class _FlatButtonWidgetState extends State<FlatButtonWidget> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final order = Provider.of<OrderProvider>(context, listen: false);

    return FlatButton(
      onPressed: (cart.cartItems.isEmpty || _isLoading)
          ? null
          : () async {
              if (cart.cartItems.isNotEmpty) {
                setState(() {
                  _isLoading = true;
                });
                await order.addOrders(
                    cart.cartItems.values.toList(), cart.totalAmount);
                setState(() {
                  _isLoading = false;
                });
                cart.clear();
              } else {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Empty Cart'),
                    content: Text('The cart is empty!'),
                    actions: [
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              'ORDER NOW',
              style: cart.cartItems.isNotEmpty
                  ? TextStyle(color: Theme.of(context).primaryColor)
                  : TextStyle(),
            ),
    );
  }
}
