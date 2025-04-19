import 'package:crud/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:crud/models/product.dart';

class ProductListPage extends StatelessWidget {
  final FirebaseService _firestoreService = FirebaseService();

  ProductListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Products')),
      body: StreamBuilder<List<Product>>(
        stream: _firestoreService.getAllProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data;

          if (products == null || products.isEmpty) {
            return Center(child: Text('No products available.'));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(product.name, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    '${product.category} • ₹${product.pricePerDay}/day\nAvailable: ${product.quantityAvailable}',
                  ),
                  isThreeLine: true,
                  leading: CircleAvatar(child: Text(product.name[0].toUpperCase())),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteProduct(product.id, context),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _deleteProduct(String productId, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Product"),
          content: Text("Are you sure you want to delete this product?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await _firestoreService.deleteProduct(productId);
                Navigator.of(context).pop();
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
