import 'package:flutter/material.dart';
import 'models/cart_item_model.dart';
import 'services/cart_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  static const _deliveryCharge = 25.0;
  static const _handlingCharge = 2.0;
  static const _donationAmounts = [20, 50, 100];

  var _selectedDonationIndex = -1;
  var _customDonation = 0.0;
  var _isCustomDonationSelected = false;

  final _customDonationController = TextEditingController();
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _customDonationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  double _calculateGrandTotal(double itemsTotal) {
    double total = itemsTotal + _deliveryCharge + _handlingCharge;

    if (_selectedDonationIndex >= 0 &&
        _selectedDonationIndex < _donationAmounts.length) {
      total += _donationAmounts[_selectedDonationIndex];
    } else if (_isCustomDonationSelected && _customDonation > 0) {
      total += _customDonation;
    }

    return total;
  }

  void _selectDonation(int index) {
    setState(() {
      _selectedDonationIndex = index;
      _isCustomDonationSelected = false;
      _customDonation = 0;
      _customDonationController.clear();
    });
  }

  void _selectCustomDonation() {
    setState(() {
      _isCustomDonationSelected = true;
      _selectedDonationIndex = -1;
    });
    _showCustomDonationDialog();
  }

  void _proceedToCheckout(double grandTotal) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Text(
              'Proceeding to checkout - ₹${grandTotal.toInt()}',
              style: const TextStyle(
                fontFamily: 'HennyPenny',
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showCustomDonationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Custom Donation',
          style: TextStyle(
            fontFamily: 'HennyPenny',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter your donation amount to help feed those in need',
              style: TextStyle(
                fontFamily: 'HennyPenny',
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _customDonationController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontFamily: 'HennyPenny'),
              decoration: InputDecoration(
                hintText: 'Enter amount',
                hintStyle: TextStyle(
                  fontFamily: 'HennyPenny',
                  color: Colors.grey.shade500,
                  fontSize: 13,
                ),
                prefixText: '₹ ',
                prefixStyle: const TextStyle(
                  fontFamily: 'HennyPenny',
                  color: Colors.black87,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.orange),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isCustomDonationSelected = false;
                _customDonation = 0;
                _customDonationController.clear();
              });
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'HennyPenny',
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              final amount =
                  double.tryParse(_customDonationController.text) ?? 0;
              if (amount > 0) {
                setState(() => _customDonation = amount);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Please enter a valid amount',
                      style: TextStyle(fontFamily: 'HennyPenny', fontSize: 13),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(
                fontFamily: 'HennyPenny',
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _removeItem(String productId, String productName) async {
    try {
      await CartService.removeFromCart(productId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$productName removed from cart',
            style: const TextStyle(
              fontFamily: 'HennyPenny',
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          backgroundColor: Colors.orange.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(16),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: const TextStyle(fontFamily: 'HennyPenny', fontSize: 13),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _updateQuantity(String productId, int newQuantity) async {
    try {
      await CartService.updateQuantity(productId, newQuantity);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: const TextStyle(fontFamily: 'HennyPenny', fontSize: 13),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF87CEEB),
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          'My Cart',
          style: TextStyle(
            fontFamily: 'HennyPenny',
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: StreamBuilder<int>(
              stream: CartService.getCartCount(),
              initialData: 0,
              builder: (context, snapshot) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.shopping_cart, color: Colors.white, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          '${snapshot.data ?? 0} items',
                          style: const TextStyle(
                            fontFamily: 'HennyPenny',
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<CartItemModel>>(
        stream: CartService.getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading cart',
                    style: TextStyle(
                      fontFamily: 'HennyPenny',
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          final cartItems = snapshot.data ?? [];

          if (cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey.shade300),
                  const SizedBox(height: 24),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontFamily: 'HennyPenny',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add some items to get started!',
                    style: TextStyle(
                      fontFamily: 'HennyPenny',
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.shopping_bag),
                    label: const Text(
                      'Start Shopping',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // Calculate items total
          final itemsTotal = cartItems.fold<double>(
            0,
            (sum, item) => sum + item.totalPrice,
          );
          final grandTotal = _calculateGrandTotal(itemsTotal);

          return Column(
            children: [
              // Cart Items List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return _CartItemCard(
                      key: ValueKey(item.id),
                      item: item,
                      onRemove: () => _removeItem(item.productId, item.productName),
                      onQuantityChanged: (newQty) => _updateQuantity(item.productId, newQty),
                    );
                  },
                ),
              ),

              // Summary Section
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Bill Summary Header
                      const Text(
                        'Bill Summary',
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Price Breakdown
                      _SummaryRow('Items total', itemsTotal),
                      const SizedBox(height: 12),
                      _SummaryRow('Delivery charge', _deliveryCharge),
                      const SizedBox(height: 12),
                      _SummaryRow('Handling charge', _handlingCharge),
                      
                      // Donation rows
                      if (_selectedDonationIndex >= 0) ...[
                        const SizedBox(height: 12),
                        _SummaryRow(
                          'Donation',
                          _donationAmounts[_selectedDonationIndex].toDouble(),
                          isPositive: true,
                        ),
                      ],
                      if (_isCustomDonationSelected && _customDonation > 0) ...[
                        const SizedBox(height: 12),
                        _SummaryRow('Custom Donation', _customDonation, isPositive: true),
                      ],
                      
                      const SizedBox(height: 16),
                      Divider(thickness: 1.5, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      
                      // Grand Total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Grand Total',
                            style: TextStyle(
                              fontFamily: 'HennyPenny',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            '₹${grandTotal.toInt()}',
                            style: TextStyle(
                              fontFamily: 'HennyPenny',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Donation Section
                      _buildDonationSection(),
                      const SizedBox(height: 20),
                      
                      // Checkout Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _proceedToCheckout(grandTotal),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Proceed to Checkout',
                                style: TextStyle(
                                  fontFamily: 'HennyPenny',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                            ],
                          ),
                        ),
                      ),
                      
                      // Bottom safe area padding
                      SizedBox(height: MediaQuery.of(context).padding.bottom),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDonationSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.favorite, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Feeding India donation',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Help fight malnutrition',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Donation Amount Options
          Row(
            children: [
              for (var i = 0; i < _donationAmounts.length; i++)
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDonation(i),
                    child: Container(
                      margin: EdgeInsets.only(
                        right: i < _donationAmounts.length - 1 ? 8 : 0,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedDonationIndex == i
                            ? Colors.orange
                            : Colors.white,
                        border: Border.all(
                          color: _selectedDonationIndex == i
                              ? Colors.orange
                              : Colors.grey.shade400,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '₹${_donationAmounts[i]}',
                          style: TextStyle(
                            fontFamily: 'HennyPenny',
                            color: _selectedDonationIndex == i
                                ? Colors.white
                                : Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Custom Amount Button
          GestureDetector(
            onTap: _selectCustomDonation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _isCustomDonationSelected
                    ? Colors.orange
                    : Colors.white,
                border: Border.all(
                  color: _isCustomDonationSelected
                      ? Colors.orange
                      : Colors.grey.shade400,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.edit,
                    size: 16,
                    color: _isCustomDonationSelected
                        ? Colors.white
                        : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isCustomDonationSelected && _customDonation > 0
                        ? 'Custom ₹${_customDonation.toInt()}'
                        : 'Custom Amount',
                    style: TextStyle(
                      fontFamily: 'HennyPenny',
                      color: _isCustomDonationSelected
                          ? Colors.white
                          : Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onRemove;
  final ValueChanged<int> onQuantityChanged;

  const _CartItemCard({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade100,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.shopping_basket,
                    size: 35,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.productName,
                    style: const TextStyle(
                      fontFamily: 'HennyPenny',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${item.price.toInt()} per item',
                    style: TextStyle(
                      fontFamily: 'HennyPenny',
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Quantity Controls
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _QuantityButton(
                              icon: Icons.remove,
                              onTap: () {
                                if (item.quantity > 1) {
                                  onQuantityChanged(item.quantity - 1);
                                }
                              },
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                  fontFamily: 'HennyPenny',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            _QuantityButton(
                              icon: Icons.add,
                              onTap: () => onQuantityChanged(item.quantity + 1),
                            ),
                          ],
                        ),
                      ),
                      
                      // Total Price
                      Text(
                        '₹${item.totalPrice.toInt()}',
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Delete Button
            const SizedBox(width: 4),
            IconButton(
              onPressed: onRemove,
              icon: Icon(Icons.delete_outline, color: Colors.red.shade400, size: 22),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: 'Remove item',
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 18, color: Colors.grey.shade700),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isPositive;

  const _SummaryRow(this.label, this.amount, {this.isPositive = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'HennyPenny',
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
        Text(
          '₹${amount.toInt()}',
          style: TextStyle(
            fontFamily: 'HennyPenny',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isPositive ? Colors.orange.shade700 : Colors.black87,
          ),
        ),
      ],
    );
  }
}