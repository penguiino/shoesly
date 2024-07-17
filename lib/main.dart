import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shoesly/screens/cart_screen.dart';
import 'package:shoesly/screens/checkout_screen.dart';
import 'package:shoesly/screens/discover_screen.dart';
import 'package:shoesly/screens/product_detail_screen.dart';
import 'package:shoesly/screens/reviews_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shoesly',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => DiscoverScreen(),
        '/cart': (context) => CartScreen(),
        '/checkout': (context) => checkout_screen(total: ModalRoute.of(context)!.settings.arguments as double),
        '/product_detail': (context) => ProductDetailScreen(),
        '/reviews': (context) => ReviewsScreen(productId: ModalRoute.of(context)!.settings.arguments as String),
      },
    );
  }
}
