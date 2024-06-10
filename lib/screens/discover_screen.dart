import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shoesly/models/product.dart';
import 'package:shoesly/widgets/shoe_tile.dart';

class DiscoverScreen extends StatefulWidget {
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final PagingController<int, DocumentSnapshot> _pagingController =
  PagingController(firstPageKey: 0);
  final List<String> filters = ["All", "Nike", "Jordan", "Adidas", "Reebok"];
  String selectedFilter = "All";

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      Query query = FirebaseFirestore.instance.collection('shoes').orderBy('name');

      if (selectedFilter != "All") {
        query = query.where('brand', isEqualTo: selectedFilter);
      }

      final QuerySnapshot newItems = await query
          .startAfter([pageKey])
          .limit(10)
          .get();
      final isLastPage = newItems.docs.length < 10;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems.docs);
      } else {
        final nextPageKey = pageKey + newItems.docs.length;
        _pagingController.appendPage(newItems.docs, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover'),
      ),
      body: Column(
        children: [
          // Filters
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: filters.map((filter) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: selectedFilter == filter,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedFilter = filter;
                        _pagingController.refresh();
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: PagedListView<int, DocumentSnapshot>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<DocumentSnapshot>(
                itemBuilder: (context, item, index) {
                  Product product = Product.fromMap(item.data() as Map<String, dynamic>, item.id);
                  return ShoeTile(
                    shoe: product,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/product_detail',
                        arguments: product,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to filter options
        },
        child: Icon(Icons.filter_list),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
