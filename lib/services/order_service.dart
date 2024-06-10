import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createOrder(String userId, double total) async {
    final orderRef = _firestore.collection('orders').doc();
    final cartRef = _firestore.collection('carts').doc(userId);
    final cartSnapshot = await cartRef.get();

    if (cartSnapshot.exists) {
      List<dynamic> items = cartSnapshot.data()!['items'];

      await orderRef.set({
        'userId': userId,
        'total': total,
        'items': items,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Clear cart after placing the order
      await cartRef.update({'items': []});
    }
  }
}
