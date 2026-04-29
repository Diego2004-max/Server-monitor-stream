import 'dart:async';
import '../models/product.dart';

class CartBloc {
  // Stream principal del carrito
  final _cartController = StreamController<List<Product>>.broadcast();

  // Stream solo para el total (optimización PRO)
  final _totalController = StreamController<double>.broadcast();

  final List<Product> _cart = [];

  // Outputs
  Stream<List<Product>> get cartStream => _cartController.stream;
  Stream<double> get totalStream => _totalController.stream;

  // Agregar producto
  void addProduct(Product product) {
    _cart.add(product);
    _emitChanges();
  }

  // Eliminar producto
  void removeProduct(Product product) {
    _cart.remove(product);
    _emitChanges();
  }

  // Lógica centralizada (clave en nivel experto)
  void _emitChanges() {
    _cartController.sink.add(List.unmodifiable(_cart));
    _totalController.sink.add(_calculateTotal());
  }

  double _calculateTotal() {
    return _cart.fold(0, (sum, item) => sum + item.price);
  }

  void dispose() {
    _cartController.close();
    _totalController.close();
  }
}