import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoesly/services/cart_service.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  final CartService _cartService = CartService();

  @override
  Widget build(BuildContext context) {
    String userId = 'testUser'; // Assume userId is obtained from FirebaseAuth

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _cartService.getCart(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var cartData = snapshot.data!.data() as Map<String, dynamic>?;
          if (cartData == null || cartData['items'] == null || cartData['items'].isEmpty) {
            return Center(child: Text('Your cart is empty.'));
          }

          List<dynamic> items = cartData['items'];
          double total = items.fold(0, (sum, item) => sum + item['price']);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    var item = items[index];
                    return ListTile(
                      leading: Image.network(item['image']),
                      title: Text(item['name']),
                      subtitle: Text('\$${item['price']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              _cartService.updateItemQuantity(userId, item, -1);
                            },
                          ),
                          Text(item['quantity'].toString()),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              _cartService.updateItemQuantity(userId, item, 1);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _cartService.removeItemFromCart(userId, item);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Total: \$${total.toStringAsFixed(2)}', style: TextStyle(fontSize: 20)),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/checkout',
                          arguments: total,
                        );
                      },
                      child: Text('Proceed to Checkout'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
