import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoesly/models/review.dart';
import 'package:shoesly/widgets/review_tile.dart';

class ReviewsScreen extends StatefulWidget {
  final String productId;

  ReviewsScreen({required this.productId});

  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  int _selectedStar = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    _selectedStar == index + 1
                        ? Icons.star
                        : Icons.star_border,
                  ),
                  color: Colors.yellow,
                  onPressed: () {
                    setState(() {
                      _selectedStar = index + 1;
                    });
                  },
                );
              }),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .doc(widget.productId)
                  .collection('reviews')
                  .where('rating', isEqualTo: _selectedStar == 0 ? null : _selectedStar)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var reviews = snapshot.data!.docs.map((doc) {
                  return Review.fromMap(doc.data() as Map<String, dynamic>);
                }).toList();

                if (reviews.isEmpty) {
                  return Center(child: Text('No reviews found.'));
                }

                return ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    return ReviewTile(review: reviews[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
