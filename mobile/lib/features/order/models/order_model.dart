import 'package:ecommerence/features/product/models/product_model.dart';

class PaymentModel {
  final int id;
  final String paymentMethod;
  final double amount;
  final String status;
  final String? transactionId;
  final String createdAt;

  PaymentModel({
    required this.id,
    required this.paymentMethod,
    required this.amount,
    required this.status,
    this.transactionId,
    required this.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as int,
      paymentMethod: json['payment_method'] as String,
      amount: (json['amount'] is int)
          ? (json['amount'] as int).toDouble()
          : (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      transactionId: json['transaction_id'] as String?,
      createdAt: json['created_at'] as String,
    );
  }
}

class OrderModel {
  final int id;
  final String orderNumber;
  final String date;
  final String status;
  final double totalAmount;
  final List<OrderItemModel> items;
  final PaymentModel? payment;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.date,
    required this.status,
    required this.totalAmount,
    required this.items,
    this.payment,
  });

  factory OrderModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) throw Exception("Order data is null");
    return OrderModel(
      id: json['id'] as int? ?? 0,
      orderNumber: "ORD-${json['id'] ?? '?'}", // Using ID as order number
      date: json['created_at'] != null
          ? json['created_at'].toString().split(' ')[0]
          : 'N/A',
      status: json['status'] as String? ?? 'pending',
      totalAmount: (json['total_amount'] is int)
          ? (json['total_amount'] as int).toDouble()
          : (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      items: json['items'] != null
          ? (json['items'] as List)
                .where((e) => e != null)
                .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
      payment: json['payment'] != null
          ? PaymentModel.fromJson(json['payment'] as Map<String, dynamic>)
          : null,
    );
  }
}

class OrderItemModel {
  final int id;
  final ProductModel?
  product; // Make product optional in case of deleted products
  final int quantity;
  final double price;

  OrderItemModel({
    required this.id,
    this.product,
    required this.quantity,
    required this.price,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) throw Exception("Order item data is null");
    return OrderItemModel(
      id: json['id'] as int? ?? 0,
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'] as Map<String, dynamic>)
          : null,
      quantity: json['quantity'] as int? ?? 0,
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
