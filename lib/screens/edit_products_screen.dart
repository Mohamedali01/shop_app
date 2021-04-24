import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product.dart';
import '../provider/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static final String id = '/edit-screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _isFilled = false;
  bool _isLoading = false;
  var _editProduct =
      Product(
          userId: null,
          id: null, title: '', description: '', imageUrl: '', price: 0.0);
  var data = {'title': '', 'description': '', 'imageUrl': '', 'price': ''};

  Future<void> _saveForm() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      if (_editProduct.id != null) {
        await Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(_editProduct);
      } else {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editProduct);
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_urlListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isFilled) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        final productData =
            Provider.of<ProductsProvider>(context).getById(productId);
        _editProduct = productData;
        data['title'] = _editProduct.title;
        data['price'] = _editProduct.price.toString();
        data['description'] = _editProduct.description;
        _imageController.text = _editProduct.imageUrl;
      }
    }
    _isFilled = true;
  }

  void _urlListener() {
    if (!_imageUrlFocusNode.hasFocus) {
      print('has focus changed');
      if (_imageController.text.isEmpty) {
        print('is empty executed');
        setState(() {});
        return;
      }
      if (!(_imageController.text.startsWith('https') ||
              _imageController.text.startsWith('https')) ||
          !(_imageController.text.endsWith('.png') ||
              _imageController.text.endsWith('.jpg') ||
              _imageController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: _saveForm,
          )
        ],
        title: Text('Edit products'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: data['title'],
                        decoration: InputDecoration(labelText: 'title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                          _editProduct = Product(
                            userId: _editProduct.userId,
                              id: _editProduct.id,
                              isFavorite: _editProduct.isFavorite,
                              title: value,
                              description: _editProduct.description,
                              imageUrl: _editProduct.imageUrl,
                              price: _editProduct.price);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'please input the title.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: data['price'],
                        decoration: InputDecoration(labelText: 'price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) {
                          _editProduct = Product(
                              userId: _editProduct.userId,

                              id: _editProduct.id,
                              isFavorite: _editProduct.isFavorite,
                              title: _editProduct.title,
                              description: _editProduct.description,
                              imageUrl: _editProduct.imageUrl,
                              price: double.parse(value));
                        },
                        validator: (value) {
                          if (value.isEmpty) return 'please enter the price';
                          if (double.tryParse(value) == null)
                            return 'Please enter a valid number';
                          if (double.parse(value) < 0)
                            return 'Please enter a number greater than zero';
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: data['description'],
                        decoration: InputDecoration(labelText: 'description'),
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        maxLines: 3,
                        onSaved: (value) {
                          _editProduct = Product(
                              userId: _editProduct.userId,

                              id: _editProduct.id,
                              isFavorite: _editProduct.isFavorite,
                              title: _editProduct.title,
                              description: value,
                              imageUrl: _editProduct.imageUrl,
                              price: _editProduct.price);
                        },
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Please enter a description';
                          if (value.length < 10)
                            return 'Please enter 10 characters at least';
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 6, top: 10),
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: _imageController.text.isEmpty
                                ? Text('Enter image url')
                                : FittedBox(
                                    fit: BoxFit.cover,
                                    child: Image.network(
                                      _imageController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              focusNode: _imageUrlFocusNode,
                              decoration:
                                  InputDecoration(labelText: 'Enter image url'),
                              keyboardType: TextInputType.url,
                              controller: _imageController,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              onSaved: (value) {
                                _editProduct = Product(
                                    userId: _editProduct.userId,
                                    id: _editProduct.id,
                                    isFavorite: _editProduct.isFavorite,
                                    title: _editProduct.title,
                                    description: _editProduct.description,
                                    imageUrl: value,
                                    price: _editProduct.price);
                              },
                              validator: (value) {
                                if (value.isEmpty) return 'Please enter a URL';
                                if (!(value.startsWith('http') ||
                                    value.startsWith('https')))
                                  return 'Please enter a valid URL';
                                if (!(value.endsWith('.jpg') ||
                                    value.endsWith('.jpeg') ||
                                    value.endsWith('.png')))
                                  return 'Please enter a valid image URL';
                                return null;
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
