import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/main_drawer.dart';
import '../widgets/manage_item.dart';
import '../screens/edit_products_screen.dart';
import '../provider/products_provider.dart';

class ManageScreen extends StatefulWidget {
  static final String id = '/manage-screen';

  @override
  _ManageScreenState createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  @override
  Widget build(BuildContext context) {
    print('......Updated......');
    final appBar = AppBar(
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, EditProductScreen.id);
          },
        ),
      ],
      title: Text('Mange Screen'),
    );
    return Scaffold(
      drawer: MainDrawer(),
      appBar: appBar,
      body: FutureBuilder(
        future: Provider.of<ProductsProvider>(context, listen: false)
            .fetchProducts(true),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  await Provider.of<ProductsProvider>(context, listen: false)
                      .fetchProducts(true);
                },
                child: Consumer<ProductsProvider>(
                  builder: (context, product, _) {
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: ListView.builder(
                        itemBuilder: (_, index) {
                          return Column(
                            children: [
                              ManageItem(
                                id: product.items[index].id,
                                title: product.items[index].title,
                                imageUrl: product.items[index].imageUrl,
                              ),
                              Divider()
                            ],
                          );
                        },
                        itemCount: product.items.length,
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
