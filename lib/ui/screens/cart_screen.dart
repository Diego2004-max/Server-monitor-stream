import 'package:flutter/material.dart';
import '../../blocs/cart_bloc.dart';
import '../../models/product.dart';
import '../../ui/widgets/produc_list.dart';
import '../widgets/cart_list.dart';
import '../widgets/total_widget.dart';

class CartScreen extends StatelessWidget {
  final CartBloc bloc;

  CartScreen({required this.bloc});

  final List<Product> products = [
    Product(id: "1", name: "Laptop", price: 3000),
    Product(id: "2", name: "Mouse", price: 50),
    Product(id: "3", name: "Teclado", price: 120),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Carrito PRO")),
      body: Column(
        children: [
          Expanded(
            child: ProductList(products: products, bloc: bloc),
          ),
          Divider(),
          Expanded(
            child: CartList(bloc: bloc),
          ),
          TotalWidget(bloc: bloc),
        ],
      ),
    );
  }
}