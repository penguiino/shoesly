import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoesly/services/order_service.dart';

class checkout_screen extends StatelessWidget {
  final double total;
  final OrderService _orderService = OrderService();

  checkout_screen({required this.total});

  @override
  Widget build(BuildContext context) {
    String userId = 'testUser'; // Assume userId is obtained from FirebaseAuth

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Order Summary', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Total: \$${total.toStringAsFixed(2)}'),
            SizedBox(height: 20),
            Text('Payment Method', style: TextStyle(fontSize: 20)),
            // For simplicity, just showing text instead of actual payment methods
            SizedBox(height: 10),
            Text('Credit Card'),
            SizedBox(height: 20),
            Text('Shipping Address', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('123 Main Street, Springfield, USA'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _orderService.createOrder(userId, total);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Order placed successfully!')),
                );
                Navigator.pop(context);
              },
              child: Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}
