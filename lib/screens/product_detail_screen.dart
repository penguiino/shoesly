import 'package:flutter/material.dart';
import 'package:shoesly/models/product.dart';
import 'package:shoesly/widgets/review_tile.dart';
import 'package:shoesly/services/cart_service.dart';
import 'package:shoesly/screens/reviews_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final CartService _cartService = CartService();

  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: product.images.map((image) {
                  return Image.network(image);
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text('\$${product.price}'),
                  SizedBox(height: 10),
                  Text('Description:'),
                  Text(product.description),
                  SizedBox(height: 10),
                  Text('Color Options:'),
                  Row(
                    children: product.colors.map((color) {
                      return Container(
                        width: 20,
                        height: 20,
                        margin: EdgeInsets.all(2),
                        color: Color(int.parse(color)),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10),
                  Text('Size Options:'),
                  Row(
                    children: product.sizes.map((size) {
                      return Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(size.toString()),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10),
                  Text('Top 3 Reviews:'),
                  ...product.topReviews.map((review) {
                    return ReviewTile(review: review);
                  }).toList(),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      /*String userId = 'testUser';
                      await _cartService.addToCart(userId, product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added to cart!')),
                      );*/
                    },
                    child: Text('Add to Cart'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/reviews',
                        arguments: product.id,
                      );
                    },
                    child: Text('View All Reviews'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
