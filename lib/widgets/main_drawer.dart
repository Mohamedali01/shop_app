import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/auth_screen.dart';

import '../provider/auth_provider.dart';
import '../screens/orders_screen.dart';
import '../screens/products_overview_screen.dart';
import '../screens/manage_screen.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Menu',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
              leading: Icon(
                Icons.shop,
                size: 22,
              ),
              title: Text(
                'Shop',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, ProductsOverviewScreen.id);
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(
              16.0,
            ),
            child: ListTile(
              leading: Icon(
                Icons.payment,
                size: 22,
              ),
              title: Text(
                'Orders',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  OrdersScreen.id,
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(
              16.0,
            ),
            child: ListTile(
              leading: Icon(
                Icons.edit,
                size: 22,
              ),
              title: Text(
                'Manage products',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  ManageScreen.id,
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(
              16.0,
            ),
            child: ListTile(
              leading: Icon(
                Icons.exit_to_app,
                size: 22,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Provider.of<AuthProvider>(context, listen: false).logout();
              },
            ),
          ),
        ],
      ),
    );
  }
}
