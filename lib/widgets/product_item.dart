import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../provider/cart_provider.dart';
import '../provider/product.dart';
import '../screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Consumer<Product>(
      builder: (_, product, child) => ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, ProductDetailsScreen.id,
                  arguments: product.id);
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            leading: IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () async {
                try {
                  await product.toggleFutureFavorite(
                      product.id, auth.token, auth.userId);
                } catch (error) {
                  print('error catched favorite');
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      content: Text(
                        'Error in favorite this item',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      title: Text(
                        'Error',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      backgroundColor: Colors.black,
                      actions: [
                        FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                      ],
                    ),
                  );
                  product.toggleFavorite();
                }
              },
            ),
            backgroundColor: Colors.black87,
            trailing: Consumer<CartProvider>(builder: (_, cartList, child) {
              return IconButton(
                color: Theme.of(context).accentColor,
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  cartList.addCartItem(
                      product.id, product.title, product.price);
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text(
                        'Item added successfully!',
                        textAlign: TextAlign.center,
                      ),
                      action: SnackBarAction(
                        onPressed: () {
                          cartList.removeItem(product.id);
                        },
                        label: 'UNDO',
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}
