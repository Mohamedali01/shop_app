import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/main_drawer.dart';
import '../provider/order_provider.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static final String id = '/orders-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('My orders'),
      ),
      body: FutureBuilder(
        future:
            Provider.of<OrderProvider>(context, listen: false).fetchOrders(),
        builder: (_, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapShot.hasError) {
              return Center(
                child: Text('There is an error occurred'),
              );
            } else {
              return Consumer<OrderProvider>(
                builder: (_, order, child) {
                  return ListView.builder(
                    itemCount: order.listOfOrders.length,
                    itemBuilder: (_, index) => OrderItem(
                      order: order.listOfOrders[index],
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
