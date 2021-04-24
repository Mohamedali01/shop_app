import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/main_drawer.dart';

import '../provider/cart_provider.dart';
import '../provider/products_provider.dart';
import '../widgets/badge.dart';
import '../widgets/product_item.dart';
import '../screens/carts_screen.dart';

enum FavoriteItems { ALL, FAVORITE }

class ProductsOverviewScreen extends StatefulWidget {
  static const String id = '/products-over-view-screen';

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool isFav = false;
  bool _isLoading = false;
  int count = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    Provider.of<ProductsProvider>(context, listen: false)
        .fetchProducts()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    }).catchError(
      (error) {
        setState(() {
          _isLoading = false;
        });
        return showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Error!'),
            content: Text('There is an error here'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('okay'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final providedData = Provider.of<ProductsProvider>(context);
    final providedProducts = isFav ? providedData.favList : providedData.items;
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        actions: [
          PopupMenuButton(
              onSelected: (FavoriteItems selectedItem) {
                if (selectedItem == FavoriteItems.FAVORITE) {
                  setState(() {
                    isFav = true;
                  });
                } else {
                  setState(() {
                    isFav = false;
                  });
                }
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      value: FavoriteItems.ALL,
                      child: Text('All products'),
                    ),
                    PopupMenuItem(
                      value: FavoriteItems.FAVORITE,
                      child: Text('Favorites'),
                    ),
                  ]),
          Consumer<CartProvider>(
            child: IconButton(
              iconSize: 35,
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartsScreen.id);
              },
            ),
            builder: (_, cartList, ch) => Badge(
              child: ch,
              value: cartList.cartItemsCount,
            ),
          ),
        ],
        title: Text('ShopApp'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Provider.of<ProductsProvider>(context).items.isEmpty
              ? Center(
                  child: Text('There is no items here'),
                )
              : GridView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: providedProducts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (_, index) {
                    return ChangeNotifierProvider.value(
                      value: providedProducts[index],
                      child: ProductItem(),
                    );
                  }),
    );
  }
}
