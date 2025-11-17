import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product_model.dart';

class DataSeeder {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> seedProducts() async {
    try {
      // ✅ Check if user is authenticated first
      if (FirebaseAuth.instance.currentUser == null) {
        print('⏭️ Skipping product seeding - user not authenticated');
        return;
      }

      // Check if products already exist
      final snapshot = await _firestore.collection('products').limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        print('✅ Products already exist. Skipping seed.');
        return;
      }

      final products = [
        ProductModel(
          id: '',
          name: 'CARROT',
          description: 'Fresh organic carrots',
          price: 50,
          imageUrl: 'assets/images/carrot.jpg',
          category: 'Fruits & Vegetables',
          stock: 100,
        ),
        ProductModel(
          id: '',
          name: 'MILK',
          description: 'Fresh dairy milk',
          price: 100,
          imageUrl: 'assets/images/milkjar.jpg',
          category: 'Eggs & Dairy',
          stock: 50,
        ),
        ProductModel(
          id: '',
          name: 'POTATO',
          description: 'Farm fresh potatoes',
          price: 40,
          imageUrl: 'assets/images/potato.jpg',
          category: 'Fruits & Vegetables',
          stock: 150,
        ),
        ProductModel(
          id: '',
          name: 'ORANGE JUICE',
          description: 'Fresh orange juice',
          price: 120,
          imageUrl: 'assets/images/orange_juice.jpg',
          category: 'Beverages',
          stock: 30,
        ),
        ProductModel(
          id: '',
          name: 'CHICKEN',
          description: 'Fresh chicken breast',
          price: 250,
          imageUrl: 'assets/images/chickenbreast.jpg',
          category: 'Meat & Seafood',
          stock: 40,
        ),
        ProductModel(
          id: '',
          name: 'MUSK MELON',
          description: 'Sweet muskmelon',
          price: 200,
          imageUrl: 'assets/images/muskmelon.jpg',
          category: 'Fruits & Vegetables',
          stock: 25,
        ),
        ProductModel(
          id: '',
          name: 'TOMATO',
          description: 'Fresh red tomatoes',
          price: 60,
          imageUrl: 'assets/images/tomato.jpg',
          category: 'Fruits & Vegetables',
          stock: 120,
        ),
        ProductModel(
          id: '',
          name: 'ONION',
          description: 'Fresh onions',
          price: 30,
          imageUrl: 'assets/images/onion.jpg',
          category: 'Fruits & Vegetables',
          stock: 200,
        ),
      ];

      for (var product in products) {
        await _firestore.collection('products').add(product.toMap());
      }

      print('✅ Successfully seeded ${products.length} products!');
    } catch (e) {
      print('❌ Error seeding products: $e');
    }
  }
}