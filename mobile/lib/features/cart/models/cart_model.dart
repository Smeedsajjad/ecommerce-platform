class CartItem {
  final int id;
  final int productId;
  final String productName;
  final String image;
  final double price;
  final int quantity;
  final double subtotal;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.image,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productId: json['product_id'],
      productName: json['product_name'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      subtotal: (json['subtotal'] as num).toDouble(),
    );
  }
}

class CartModel {
  final int id;
  final List<CartItem> items;
  final double total;

  CartModel({required this.id, required this.items, required this.total});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      items: (json['items'] as List).map((i) => CartItem.fromJson(i)).toList(),
      total: (json['total'] as num).toDouble(),
    );
  }
}
