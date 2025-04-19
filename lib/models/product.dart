class Product {
  final String id;
  final String name;
  final String category;
  final int pricePerDay;
  final int quantityAvailable;


  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.pricePerDay,
    required this.quantityAvailable,
  });


  factory Product.fromMap(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      pricePerDay: data['pricePerDay'] ?? 0,
      quantityAvailable: data['quantityAvailable'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'pricePerDay': pricePerDay,
      'quantityAvailable': quantityAvailable,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}