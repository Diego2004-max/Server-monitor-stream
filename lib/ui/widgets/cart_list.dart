import 'package:flutter/material.dart';
import '../../blocs/cart_bloc.dart';
import '../../models/product.dart';

class CartList extends StatelessWidget {
  final CartBloc bloc;

  CartList({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: bloc.cartStream,
      initialData: [],
      builder: (context, snapshot) {
        final cart = snapshot.data!;

        if (cart.isEmpty) {
          return Center(child: Text("Carrito vacío"));
        }

        return ListView.builder(
          itemCount: cart.length,
          itemBuilder: (_, index) {
            final item = cart[index];

            return ListTile(
              title: Text(item.name),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => bloc.removeProduct(item),
              ),
            );
          },
        );
      },
    );
  }
}