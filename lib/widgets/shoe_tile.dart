import 'package:flutter/material.dart';
import 'package:shoesly/models/product.dart';

class ShoeTile extends StatelessWidget {
  final Product shoe;
  final VoidCallback onTap;

  const ShoeTile({required this.shoe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(shoe.images[0]),
      title: Text(shoe.name),
      subtitle: Text('\$${shoe.price} - ${shoe.reviewsCount} reviews - ${shoe.averageRating} stars'),
      onTap: onTap,
    );
  }
}
