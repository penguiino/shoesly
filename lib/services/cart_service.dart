import 'package:cloud_firestore/cloud_firestore.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot> getCart(String userId) async {
    return await _firestore.collection('carts').doc(userId).get();
  }

  Future<void> addToCart(String userId, DocumentSnapshot product) async {
    final cartRef = _firestore.collection('carts').doc(userId);
    final cartSnapshot = await cartRef.get();

    if (cartSnapshot.exists) {
      cartRef.update({
        'items': FieldValue.arrayUnion([product.data()])
      });
    } else {
      cartRef.set({
        'items': [product.data()],
      });
    }
  }

  Future<void> updateItemQuantity(String userId, Map<String, dynamic> item, int change) async {
    final cartRef = _firestore.collection('carts').doc(userId);
    final cartSnapshot = await cartRef.get();

    if (cartSnapshot.exists) {
      List<dynamic> items = cartSnapshot.data()!['items'];
      items = items.map((cartItem) {
        if (cartItem['name'] == item['name']) {
          cartItem['quantity'] = (cartItem['quantity'] + change).clamp(0, double.infinity);
        }
        return cartItem;
      }).toList();

      cartRef.update({'items': items});
    }
  }

  Future<void> removeItemFromCart(String userId, Map<String, dynamic> item) async {
    final cartRef = _firestore.collection('carts').doc(userId);
    final cartSnapshot = await cartRef.get();

    if (cartSnapshot.exists) {
      List<dynamic> items = cartSnapshot.data()!['items'];
      items.removeWhere((cartItem) => cartItem['name'] == item['name']);

      cartRef.update({'items': items});
    }
  }
}
