import 'package:shoesly/models/review.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final List<String> images;
  final String description;
  final List<String> colors;
  final List<int> sizes;
  final List<Review> topReviews;
  final double averageRating;
  final int reviewsCount;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.images,
    required this.description,
    required this.colors,
    required this.sizes,
    required this.topReviews,
    required this.averageRating,
    required this.reviewsCount,
  });

  factory Product.fromMap(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      name: data['name'] ?? '',
      price: (data['price'] as num).toDouble(),
      images: List<String>.from(data['images'] ?? []),
      description: data['description'] ?? '',
      colors: List<String>.from(data['colors'] ?? []),
      sizes: List<int>.from(data['sizes'] ?? []),
      topReviews: (data['top_reviews'] as List<dynamic>?)
          ?.map((review) => Review.fromMap(review))
          .toList() ??
          [],
      averageRating: (data['average_rating'] as num).toDouble(),
      reviewsCount: data['reviews_count'] ?? 0,
    );
  }
}
