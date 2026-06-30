import 'package:alkher/models/category_model.dart';

class ProductModel {
  final String id;
  final String title;
  final String description;
  final List<String> image;
  final int stock;
  final double price;
  final bool isFavorite;
  final CategoryModel category;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.stock,
    required this.price,
    required this.isFavorite,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: List<String>.from(json['image'] ?? []),
      stock: json['stock'] ?? 0,
      price: (json['price'] as num).toDouble(),
      isFavorite: json['isFavorite'] ?? false,
      category: CategoryModel.fromJson(json['category'] ?? {}),
    );
  }
}
