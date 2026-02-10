class ProductModel {
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

  ProductModel({
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

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
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

class CategoryModel {
  final int id;
  final String name;
  final String slug;
  final String? image;
  final int isActive;
  final String createdAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.image,
    required this.isActive,
    required this.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      image: json['image'] as String?,
      isActive: json['is_active'] as int,
      createdAt: json['created_at'] as String,
    );
  }
}
