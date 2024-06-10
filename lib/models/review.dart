class Review {
  final String author;
  final String content;
  final int rating;

  Review({
    required this.author,
    required this.content,
    required this.rating,
  });

  factory Review.fromMap(Map<String, dynamic> data) {
    return Review(
      author: data['author'] ?? '',
      content: data['content'] ?? '',
      rating: data['rating'] ?? 0,
    );
  }
}
