import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  static String? get _userId => _auth.currentUser?.uid;

  // Get current user's cart reference
  static CollectionReference? get _cartRef {
    if (_userId == null) return null;
    return _firestore.collection('users').doc(_userId).collection('cart');
  }

  // Add item to cart
  static Future<void> addToCart(ProductModel product, {int quantity = 1}) async {
    try {
      final cartRef = _cartRef;
      if (cartRef == null) throw 'User not logged in';

      // Use product ID as document ID
      final cartItemDoc = cartRef.doc(product.id);
      final docSnapshot = await cartItemDoc.get();

      if (docSnapshot.exists) {
        // Item exists - update quantity
        final data = docSnapshot.data() as Map<String, dynamic>;
        final currentQuantity = data['quantity'] ?? 0;
        final newQuantity = currentQuantity + quantity;
        
        await cartItemDoc.update({
          'quantity': newQuantity,
          'totalPrice': product.price * newQuantity, // ✅ Update total price
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        // New item - create document
        await cartItemDoc.set({
          'productId': product.id, // ✅ Store product ID
          'productName': product.name,
          'price': product.price,
          'quantity': quantity,
          'imageUrl': product.imageUrl,
          'category': product.category, // ✅ Store category
          'totalPrice': product.price * quantity,
          'addedAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      print('✅ Successfully added ${product.name} to cart');
    } catch (e) {
      print('❌ Error adding to cart: $e');
      throw 'Failed to add to cart: ${e.toString()}';
    }
  }

  // Get cart items stream
  static Stream<List<CartItemModel>> getCartItems() {
    final cartRef = _cartRef;
    if (cartRef == null) {
      print('⚠️ No user logged in - returning empty cart');
      return Stream.value([]);
    }

    return cartRef
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      print('📦 Cart items count: ${snapshot.docs.length}');
      return snapshot.docs
          .map((doc) => CartItemModel.fromFirestore(doc))
          .toList();
    });
  }

  // Update cart item quantity
  static Future<void> updateQuantity(String productId, int newQuantity) async {
    try {
      final cartRef = _cartRef;
      if (cartRef == null) throw 'User not logged in';

      if (newQuantity <= 0) {
        await removeFromCart(productId);
        return;
      }

      final docRef = cartRef.doc(productId);
      final doc = await docRef.get();
      
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final price = (data['price'] ?? 0).toDouble();
        
        await docRef.update({
          'quantity': newQuantity,
          'totalPrice': price * newQuantity, // ✅ Update total price
          'updatedAt': FieldValue.serverTimestamp(),
        });
        
        print('✅ Updated quantity for $productId to $newQuantity');
      }
    } catch (e) {
      print('❌ Error updating quantity: $e');
      throw 'Failed to update quantity: ${e.toString()}';
    }
  }

  // Remove item from cart
  static Future<void> removeFromCart(String productId) async {
    try {
      final cartRef = _cartRef;
      if (cartRef == null) throw 'User not logged in';

      await cartRef.doc(productId).delete();
      print('✅ Removed $productId from cart');
    } catch (e) {
      print('❌ Error removing from cart: $e');
      throw 'Failed to remove from cart: ${e.toString()}';
    }
  }

  // Clear entire cart
  static Future<void> clearCart() async {
    try {
      final cartRef = _cartRef;
      if (cartRef == null) throw 'User not logged in';

      final snapshot = await cartRef.get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      print('✅ Cart cleared');
    } catch (e) {
      print('❌ Error clearing cart: $e');
      throw 'Failed to clear cart: ${e.toString()}';
    }
  }

  // Get cart total
  static Future<double> getCartTotal() async {
    try {
      final cartRef = _cartRef;
      if (cartRef == null) return 0.0;

      final snapshot = await cartRef.get();
      double total = 0.0;

      for (var doc in snapshot.docs) {
        final item = CartItemModel.fromFirestore(doc);
        total += item.totalPrice;
      }

      print('💰 Cart total: ₹$total');
      return total;
    } catch (e) {
      print('❌ Error getting cart total: $e');
      return 0.0;
    }
  }

  // Get cart item count (total quantity)
  static Stream<int> getCartCount() {
    final cartRef = _cartRef;
    if (cartRef == null) return Stream.value(0);

    return cartRef.snapshots().map((snapshot) {
      final count = snapshot.docs.fold<int>(
        0,
        (sum, doc) {
          final data = doc.data() as Map<String, dynamic>;
          return sum + (data['quantity'] as int? ?? 0);
        },
      );
      print('🔢 Total cart items: $count');
      return count;
    });
  }

  // ✅ Get number of unique items (document count)
  static Stream<int> getCartItemsCount() {
    final cartRef = _cartRef;
    if (cartRef == null) return Stream.value(0);

    return cartRef.snapshots().map((snapshot) {
      return snapshot.docs.length;
    });
  }

  // ✅ Check if product is in cart
  static Future<bool> isInCart(String productId) async {
    try {
      final cartRef = _cartRef;
      if (cartRef == null) return false;

      final doc = await cartRef.doc(productId).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  // ✅ Get specific cart item
  static Future<CartItemModel?> getCartItem(String productId) async {
    try {
      final cartRef = _cartRef;
      if (cartRef == null) return null;

      final doc = await cartRef.doc(productId).get();
      if (doc.exists) {
        return CartItemModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('❌ Error getting cart item: $e');
      return null;
    }
  }
}