import 'package:cloud_firestore/cloud_firestore.dart';

class CartItemModel {
  final String id; // ✅ Document ID (for ValueKey)
  final String productId; // Product reference ID
  final String productName;
  final double price;
  final int quantity;
  final String imageUrl;
  final String category; // ✅ Added category field
  final DateTime? addedAt;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.category,
    this.addedAt,
  });

  factory CartItemModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CartItemModel(
      id: doc.id, // ✅ Get document ID
      productId: data['productId'] ?? doc.id, // Product ID from data or fallback to doc ID
      productName: data['productName'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      quantity: data['quantity'] ?? 1,
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '', // ✅ Get category from data
      addedAt: (data['addedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'category': category,
      'addedAt': addedAt != null 
          ? Timestamp.fromDate(addedAt!) 
          : FieldValue.serverTimestamp(),
    };
  }

  double get totalPrice => price * quantity;

  // ✅ Useful for updating cart items
  CartItemModel copyWith({
    String? id,
    String? productId,
    String? productName,
    double? price,
    int? quantity,
    String? imageUrl,
    String? category,
    DateTime? addedAt,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  // ✅ Useful for debugging
  @override
  String toString() {
    return 'CartItemModel(id: $id, productName: $productName, quantity: $quantity, price: $price)';
  }
}