import 'package:flutter/material.dart';
import '../models/CartItem.dart';
import '../models/Product.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(Product product, {int quantity = 1}) {
    int index = _items.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void updateQuantity(CartItem item, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(item);
    } else {
      item.quantity = newQuantity;
    }
    notifyListeners();
  }

  void removeItem(CartItem itemToRemove) {
    _items.removeWhere((item) => item.product.id == itemToRemove.product.id);
    notifyListeners();
  }

  double get totalAmount {
    return _items.fold(0.0, (total, current) => total + current.subtotal);
  }

  List<Map<String, dynamic>> get salePayloadItems {
    return _items
        .map(
          (item) => {
            'product_id': item.product.id,
            'quantity': item.quantity,
            'unit_price': item.product.salePrice,
            'subtotal': item.subtotal,
          },
        )
        .toList();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
