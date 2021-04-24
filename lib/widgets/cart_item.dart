import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({this.id, this.quantity, this.price, this.title});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Padding(
      padding: EdgeInsets.all(8),
      child: Dismissible(
        confirmDismiss: (direction) {
          return showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: Text('Are you sure?'),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Text('Yes'),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: Text('No'),
                    ),
                  ],
                  content: Text('Do you want to remove the item?'),
                );
              });
        },
        key: ValueKey(id),
        background: Container(
          color: Theme.of(context).errorColor,
          child: Container(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.delete,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          cart.removeItemCart(id);
        },
        child: Card(
          margin: EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              subtitle: Text('x $quantity'),
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    child: Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              title: Text('$title'),
              trailing: Text('x $quantity'),
            ),
          ),
        ),
      ),
    );
  }
}
