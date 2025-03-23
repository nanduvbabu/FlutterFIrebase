import 'package:flutter/material.dart';


class AdminHomePage extends StatelessWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/productcrud'); // Navigate to product list page
              },
              child: Card(
                elevation: 4,
                color: Colors.blue[100],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory_2, size: 40, color: Colors.blue),
                      SizedBox(height: 10),
                      Text('Products', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
            // another card inside the above children
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/productcrud'); // Navigate to product list page
              },
              child: Card(
                elevation: 4,
                color: Colors.blue[100],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.supervised_user_circle, size: 40, color: Colors.blue),
                      SizedBox(height: 10),
                      Text('Products', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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