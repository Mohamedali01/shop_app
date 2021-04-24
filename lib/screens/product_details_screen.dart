import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const String id = '/product-detail-screen';
  PreferredSizeWidget appBar(String title){
 return AppBar(
    title: Text(title),
  );
}
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<ProductsProvider>(context, listen: false)
        .getById(productId);
    return Scaffold(
      appBar: appBar(product.title),
      body: Column(
        children: [
          Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top -
            appBar(product.title).preferredSize.height)* 0.5,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.topCenter,
            child: Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.grey, fontSize: 25),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Text(
              '${product.description}',
              style: TextStyle(color: Colors.black, fontSize: 22),
            ),
          ),
        ],
      ),
    );
  }
}
