// ---------------------------------------------------------------------------
// CheckoutSummaryItem — one line-item in the checkout summary
// ---------------------------------------------------------------------------
class CheckoutSummaryItem {
  final int id;
  final int productId;
  final String productName;
  final String image;
  final double price;
  final int quantity;
  final double subtotal;

  const CheckoutSummaryItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.image,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  factory CheckoutSummaryItem.fromJson(Map<String, dynamic> json) {
    return CheckoutSummaryItem(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      productName: json['product_name'] as String,
      image: json['image'] as String? ?? 'https://placehold.co/150x150',
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      subtotal: (json['subtotal'] as num).toDouble(),
    );
  }
}

// ---------------------------------------------------------------------------
// CheckoutSummary — the server-side validated cart totals
// ---------------------------------------------------------------------------
class CheckoutSummary {
  final List<CheckoutSummaryItem> items;
  final double subtotal;
  final double shipping;
  final double discount;
  final double total;

  const CheckoutSummary({
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.discount,
    required this.total,
  });

  factory CheckoutSummary.fromJson(Map<String, dynamic> json) {
    return CheckoutSummary(
      items: (json['items'] as List)
          .map((i) => CheckoutSummaryItem.fromJson(i as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      shipping: (json['shipping'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }
}

// ---------------------------------------------------------------------------
// PlaceOrderResult — returned by backend when an order is created
// ---------------------------------------------------------------------------
class OrderItem {
  final int id;
  final int productId;
  final String productName;
  final double price;
  final int quantity;
  final double subtotal;

  const OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      productName: json['product_name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      subtotal: (json['subtotal'] as num).toDouble(),
    );
  }
}

class PlaceOrderResult {
  final int orderId;
  final double totalAmount;
  final String status;
  final String clientSecret;
  final String paymentIntentId;

  const PlaceOrderResult({
    required this.orderId,
    required this.totalAmount,
    required this.status,
    required this.clientSecret,
    required this.paymentIntentId,
  });

  factory PlaceOrderResult.fromJson(Map<String, dynamic> json) {
    final order = json['order'] as Map<String, dynamic>;
    return PlaceOrderResult(
      orderId: order['id'] as int,
      totalAmount: (order['total_amount'] as num).toDouble(),
      status: order['status'] as String,
      clientSecret: json['client_secret'] as String,
      paymentIntentId: json['payment_intent_id'] as String,
    );
  }
}
