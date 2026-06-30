import 'package:alkher/screens/add_product_screen.dart';
import 'package:alkher/services/product_services.dart';
import 'package:alkher/models/product_model.dart';
import 'package:alkher/widget/product_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<ProductModel>> _products;

  @override
  void initState() {
    super.initState();
    _products = ProductServices().getProducts();
  }

  void _refresh() {
    setState(() {
      _products = ProductServices().getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'الخير',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline,
              color: Color(0xFF1A73E8),
            ),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddProductScreen()),
              );
              _refresh(); // يحدث القائمة بعد الإضافة
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final products = snapshot.data ?? [];
          if (products.isEmpty) {
            return const Center(
              child: Text(
                'لا يوجد منتجات',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              return ProductCard(product: products[index]);
            },
          );
        },
      ),
    );
  }
}
