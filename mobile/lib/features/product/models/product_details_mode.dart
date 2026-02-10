import 'package:ecommerence/features/product/models/product_model.dart';

class ProductDetailsModel {
  final int id;
  final String name;
  final String slug;
  final String description;
  final double price;
  final int stock;
  final int isActive;
  final List<String> images;
  final CategoryModel category;
  final String createdAt;

  ProductDetailsModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.price,
    required this.stock,
    required this.isActive,
    required this.images,
    required this.category,
    required this.createdAt,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String,
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (json['price'] as num).toDouble(),
      stock: json['stock'] as int,
      isActive: json['is_active'] as int,
      images: json['images'] != null
          ? List<String>.from(json['images'] as List)
          : [],
      category: CategoryModel.fromJson(
        json['category'] as Map<String, dynamic>,
      ),
      createdAt: json['created_at'] as String,
    );
  }
}
