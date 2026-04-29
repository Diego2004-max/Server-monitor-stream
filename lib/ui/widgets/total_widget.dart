import 'package:flutter/material.dart';
import '../../blocs/cart_bloc.dart';

class TotalWidget extends StatelessWidget {
  final CartBloc bloc;

  TotalWidget({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: bloc.totalStream,
      initialData: 0,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "Total: \$${snapshot.data}",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}