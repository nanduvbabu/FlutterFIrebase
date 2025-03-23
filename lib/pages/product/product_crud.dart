import 'package:flutter/material.dart';


class ProductCrud extends StatelessWidget {
  const ProductCrud({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/productadd'); // Navigate to product list page
              },
              child: Card(
                elevation: 4,
                color: Colors.blue[100],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 40, color: Colors.blue),
                      SizedBox(height: 10),
                      Text('Add Product', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
            // another card inside the above children
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/productlist'); // Navigate to product list page
              },
              child: Card(
                elevation: 4,
                color: Colors.blue[100],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.list, size: 40, color: Colors.blue),
                      SizedBox(height: 10),
                      Text('List Product', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
            // You can add more cards here like Orders, Rentals, etc.
          ],
        ),
      ),
    );
  }
}