import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../blocs/cart_bloc.dart';

class ProductList extends StatelessWidget {
  final List<Product> products;
  final CartBloc bloc;

  ProductList({required this.products, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (_, index) {
        final product = products[index];

        return ListTile(
          title: Text(product.name),
          subtitle: Text("\$${product.price}"),
          trailing: IconButton(
            icon: Icon(Icons.add),
            onPressed: () => bloc.addProduct(product),
          ),
        );
      },
    );
  }
}