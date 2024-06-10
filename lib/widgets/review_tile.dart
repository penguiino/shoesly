import 'package:flutter/material.dart';
import 'package:shoesly/models/review.dart';

class ReviewTile extends StatelessWidget {
  final Review review;

  const ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(review.author),
      subtitle: Text(review.content),
      trailing: Text('${review.rating} stars'),
    );
  }
}
