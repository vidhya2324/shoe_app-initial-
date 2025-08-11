import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> cart = [];

  void addProduct(Map<String, dynamic> product) {
    cart.add(product);
    notifyListeners();
  }

  void removeProduct(Map<String, dynamic> product) {
    cart.remove(product);
    notifyListeners();
  }


  // ✅ Clear all items
  void clearCart() {
    cart.clear();
    notifyListeners();
  }

  // ✅ Getter for cart items
  List<Map<String, dynamic>> get items => cart;

  // ✅ Getter for total price
  double get totalprice {
    return cart.fold(0.0, (sum, item) => sum + (item['price'] as double));
  }
}
