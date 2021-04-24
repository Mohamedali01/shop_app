import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/products_overview_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/carts_screen.dart';
import 'screens/manage_screen.dart';
import 'screens/edit_products_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/splash_screen.dart';
import 'provider/products_provider.dart';
import 'provider/order_provider.dart';
import 'provider/cart_provider.dart';
import 'provider/auth_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          create: (_) => ProductsProvider(),
          update: (ctx, auth, prevProducts) =>
              prevProducts..updatedToken(auth.token, auth.userId),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
          create: (_) => OrderProvider(),
          update: (ctx, auth, prevOrders) =>
              prevOrders..updatedToken(auth.token, auth.userId),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, authData, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Shop App',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            home: authData.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: authData.autoLogin(),
                    builder: (_, snapShot) {
                      if (snapShot.connectionState == ConnectionState.waiting)
                        return SplashScreen();
                      if (snapShot.connectionState == ConnectionState.done) {
                        if (authData.isAuth)
                          return ProductsOverviewScreen();
                        else
                          return AuthScreen();
                      }
                      return AuthScreen();
                    }),
            routes: {
              AuthScreen.id: (_) => AuthScreen(),
              ProductsOverviewScreen.id: (_) => ProductsOverviewScreen(),
              ProductDetailsScreen.id: (_) => ProductDetailsScreen(),
              CartsScreen.id: (_) => CartsScreen(),
              OrdersScreen.id: (_) => OrdersScreen(),
              ManageScreen.id: (_) => ManageScreen(),
              EditProductScreen.id: (_) => EditProductScreen(),
            },
          );
        },
      ),
    );
  }
}
