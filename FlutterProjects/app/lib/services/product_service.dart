import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all products
  static Stream<List<ProductModel>> getProducts() {
    return _firestore
        .collection('products')
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    });
  }

  // Get products by category
  static Stream<List<ProductModel>> getProductsByCategory(String category) {
    return _firestore
        .collection('products')
        .where('category', isEqualTo: category)
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    });
  }

  // Search products
  static Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final snapshot = await _firestore.collection('products').get();
      final allProducts = snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();

      return allProducts
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()) ||
              product.category.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      print('Error searching products: $e');
      return [];
    }
  }

  // Add product (admin only - for seeding data)
  static Future<void> addProduct(ProductModel product) async {
    try {
      await _firestore.collection('products').add(product.toMap());
    } catch (e) {
      throw 'Failed to add product: ${e.toString()}';
    }
  }

  // Get product by ID
  static Future<ProductModel?> getProductById(String productId) async {
    try {
      final doc = await _firestore.collection('products').doc(productId).get();
      if (doc.exists) {
        return ProductModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting product: $e');
      return null;
    }
  }
}