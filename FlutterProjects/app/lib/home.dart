import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cart.dart';
import 'holistic_wellness.dart';
import 'hair_vitality.dart';
import 'muscle_builder.dart';
import 'sculpt_transform.dart';
import 'bulk_ordering.dart';
import 'login.dart';
import 'models/product_model.dart';
import 'services/product_service.dart';
import 'services/cart_service.dart';
import 'services/firebase_service.dart';

class Category {
  final String name;
  final String iconPath;
  final String? secondIconPath;
  const Category(this.name, this.iconPath, {this.secondIconPath});
}

class DietSubscription {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  const DietSubscription({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });
}

const categories = [
  Category('All', 'assets/icons/mark.png'),
  Category('Fruits & Vegetables', 'assets/icons/chinese-cabbage.png'),
  Category('Meat & Seafood', 'assets/icons/meat.png', secondIconPath: 'assets/icons/salmon.png'),
  Category('Daily Staples', 'assets/icons/seeds.png'),
  Category('Beverages', 'assets/icons/juice.png'),
  Category('Eggs & Dairy', 'assets/icons/milk.png', secondIconPath: 'assets/icons/tray.png'),
];

const dietSubscriptions = [
  DietSubscription(title: 'Bulk Ordering', subtitle: 'Order in bulk and save more', icon: Icons.shopping_basket, gradient: [Color.fromARGB(255, 255, 170, 0), Color(0xFFFFE66D)]),
  DietSubscription(title: 'Holistic Wellness', subtitle: 'Nutrition for complete body harmony', icon: Icons.restaurant_menu, gradient: [Color.fromARGB(255, 55, 188, 255), Color.fromARGB(255, 127, 221, 255)]),
  DietSubscription(title: 'Hair Vitality', subtitle: 'Nourish for lustrous hair', icon: Icons.face_retouching_natural, gradient: [Color.fromARGB(255, 255, 0, 85), Color(0xFFF5576c)]),
  DietSubscription(title: 'Muscle Builder', subtitle: 'Premium protein plans', icon: Icons.fitness_center, gradient: [Color.fromARGB(255, 0, 0, 0), Color.fromARGB(255, 50, 50, 50)]),
  DietSubscription(title: 'Sculpt & Transform', subtitle: 'Smart nutrition plan', icon: Icons.self_improvement, gradient: [Color.fromARGB(255, 0, 193, 39), Color.fromARGB(255, 0, 255, 42)]),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final _sliderController = PageController(viewportFraction: 0.88);
  var _selectedCategory = "All";
  var _currentSliderIndex = 0;
  late final _headerAnimController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..forward();
  late final _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..forward();

  @override
  void initState() {
    super.initState();
    _sliderController.addListener(() {
      if (_sliderController.hasClients) {
        final next = _sliderController.page!.round();
        if (_currentSliderIndex != next) setState(() => _currentSliderIndex = next);
      }
    });
  }

  @override
  void dispose() {
    _sliderController.dispose();
    _headerAnimController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _addToCart(ProductModel product) async {
    try {
      await CartService.addToCart(product);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.check, color: Colors.green, size: 14)
          ),
          const SizedBox(width: 12),
          Expanded(child: Text('${product.name} added to cart!', style: const TextStyle(fontFamily: 'HennyPenny', color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)))
        ]),
        backgroundColor: Colors.green.shade600,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString(), style: const TextStyle(fontFamily: 'HennyPenny')),
        backgroundColor: Colors.red.shade600,
      ));
    }
  }

  void _navigateToCart() => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage()));

  void _navigateToDietPlan(String dietTitle) {
    Widget? page;
    
    switch (dietTitle) {
      case 'Holistic Wellness':
        page = const HolisticWellnessPage();
        break;
      case 'Bulk Ordering':
        page = const BulkOrderingPage();
        break;
      case 'Hair Vitality':
        page = const HairVitalityPage();
        break;
      case 'Muscle Builder':
        page = const MuscleBuilderPage();
        break;
      case 'Sculpt & Transform':
        page = const SculptTransformPage();
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('$dietTitle - Coming Soon!', style: const TextStyle(fontFamily: 'HennyPenny', fontWeight: FontWeight.w600)),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16)
        ));
        return;
    }

    if (page != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page!),
      );
    }
  }

  Future<void> _handleLogout() async {
    try {
      await FirebaseService.signOut();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e', style: const TextStyle(fontFamily: 'HennyPenny')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(CurvedAnimation(parent: _headerAnimController, curve: Curves.easeOutCubic)),
              child: _Header(onCartTap: _navigateToCart, onLogout: _handleLogout),
            ),
            const SizedBox(height: 12),
            FadeTransition(opacity: _fadeController, child: _DietSlider(controller: _sliderController, currentIndex: _currentSliderIndex, onDietTap: _navigateToDietPlan)),
            const SizedBox(height: 8),
            FadeTransition(opacity: _fadeController, child: _CategoryTabs(selectedCategory: _selectedCategory, onCategorySelected: (cat) => setState(() => _selectedCategory = cat))),
            Expanded(child: FadeTransition(opacity: _fadeController, child: _ProductGrid(selectedCategory: _selectedCategory, onAddToCart: _addToCart))),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onCartTap;
  final VoidCallback onLogout;
  const _Header({required this.onCartTap, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4FC3F7),
            const Color(0xFF29B6F6),
            const Color(0xFF03A9F4),
          ]
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF03A9F4).withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 3)
          )
        ],
      ),
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => _showMenuDrawer(context, onLogout, user),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 2)
                      )
                    ]
                  ),
                  child: Image.asset(
                    'assets/icons/menu.png',
                    width: 20,
                    height: 20,
                    errorBuilder: (_, __, ___) => const Icon(Icons.menu, color: Colors.black87, size: 20)
                  ),
                ),
              ),
              const SizedBox(width: 9),
              const Text(
                'Fresh Veg',
                style: TextStyle(
                  fontFamily: 'HennyPenny',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.3,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      offset: Offset(0, 1),
                      blurRadius: 3
                    )
                  ]
                )
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (user?.photoURL != null)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(user!.photoURL!),
                    backgroundColor: Colors.white,
                  ),
                )
              else
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 2)
                      )
                    ]
                  ),
                  child: Icon(Icons.person, color: Colors.lightBlue.shade700, size: 18),
                ),
              StreamBuilder<int>(
                stream: CartService.getCartCount(),
                initialData: 0,
                builder: (context, snapshot) {
                  return _CartButton(count: snapshot.data ?? 0, onTap: onCartTap);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showMenuDrawer(BuildContext context, VoidCallback onLogout, User? user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, -2))]
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2)
              ),
            ),
            const SizedBox(height: 16),
            if (user != null) ...[
              CircleAvatar(
                radius: 35,
                backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                backgroundColor: Colors.lightBlue.shade100,
                child: user.photoURL == null ? Icon(Icons.person, size: 35, color: Colors.lightBlue.shade700) : null,
              ),
              const SizedBox(height: 12),
              Text(
                user.displayName ?? 'User',
                style: const TextStyle(
                  fontFamily: 'HennyPenny',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87
                ),
              ),
              Text(
                user.email ?? '',
                style: TextStyle(
                  fontFamily: 'HennyPenny',
                  fontSize: 13,
                  color: Colors.grey.shade600
                ),
              ),
              const SizedBox(height: 8),
            ],
            Divider(color: Colors.grey.shade200, height: 1),
            _MenuOption(icon: Icons.home, title: 'Home', onTap: () => Navigator.pop(context)),
            _MenuOption(icon: Icons.logout, title: 'Logout', onTap: () {
              Navigator.pop(context);
              onLogout();
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _MenuOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade50,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Icon(icon, color: Colors.lightBlue.shade700, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'HennyPenny',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87
                )
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 16),
          ],
        ),
      ),
    );
  }
}

class _CartButton extends StatefulWidget {
  final int count;
  final VoidCallback onTap;
  const _CartButton({required this.count, required this.onTap});

  @override
  State<_CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<_CartButton> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
  late final _scale = Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: _controller.reverse,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2)
              )
            ]
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.asset(
                    'assets/icons/shopping-bag.png',
                    width: 20,
                    height: 20,
                    errorBuilder: (_, __, ___) => Icon(Icons.shopping_cart_outlined, size: 20, color: Colors.orange.shade700)
                  ),
                  if (widget.count > 0)
                    Positioned(
                      right: -8,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF6B6B), Color(0xFFFF5252)]
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.4),
                              blurRadius: 4,
                              offset: const Offset(0, 2)
                            )
                          ]
                        ),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Center(
                          child: Text(
                            widget.count > 9 ? '9+' : '${widget.count}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'HennyPenny'
                            )
                          )
                        )
                      )
                    )
                ],
              ),
              const SizedBox(width: 6),
              const Text(
                'Cart',
                style: TextStyle(
                  fontFamily: 'HennyPenny',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF9800)
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DietSlider extends StatelessWidget {
  final PageController controller;
  final int currentIndex;
  final ValueChanged<String> onDietTap;

  const _DietSlider({required this.controller, required this.currentIndex, required this.onDietTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller,
              itemCount: dietSubscriptions.length,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    var value = 1.0;
                    if (controller.position.haveDimensions) {
                      value = controller.page! - index;
                      value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                    }
                    return Center(child: SizedBox(height: Curves.easeInOut.transform(value) * 135, child: child));
                  },
                  child: _DietCard(diet: dietSubscriptions[index], onTap: () => onDietTap(dietSubscriptions[index].title)),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              dietSubscriptions.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: currentIndex == i ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: currentIndex == i ? Colors.lightBlue.shade600 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4)
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DietCard extends StatefulWidget {
  final DietSubscription diet;
  final VoidCallback onTap;
  const _DietCard({required this.diet, required this.onTap});

  @override
  State<_DietCard> createState() => _DietCardState();
}

class _DietCardState extends State<_DietCard> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
  late final _scale = Tween<double>(begin: 1.0, end: 0.95).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: _controller.reverse,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.diet.gradient
            ),
            boxShadow: [BoxShadow(color: widget.diet.gradient[0].withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6))]
          ),
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Icon(widget.diet.icon, color: Colors.white, size: 28)
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.diet.title,
                      style: const TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.diet.subtitle,
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.95),
                        fontWeight: FontWeight.w400,
                        height: 1.3
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis
                    ),
                  ]
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.9), size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  const _CategoryTabs({required this.selectedCategory, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: categories.length,
        itemBuilder: (_, i) => _CategoryChip(
          category: categories[i],
          isSelected: selectedCategory == categories[i].name,
          onTap: () => onCategorySelected(categories[i].name)
        ),
      ),
    );
  }
}

class _CategoryChip extends StatefulWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;
  const _CategoryChip({required this.category, required this.isSelected, required this.onTap});

  @override
  State<_CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<_CategoryChip> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
  late final _scale = Tween<double>(begin: 1.0, end: 0.92).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: _controller.reverse,
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isSelected ? const Color.fromARGB(255, 108, 206, 255) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isSelected ? const Color.fromARGB(255, 112, 198, 252) : Colors.grey.shade300,
              width: 1.5
            ),
            boxShadow: [
              BoxShadow(
                color: widget.isSelected ? const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2) : Colors.black.withOpacity(0.06),
                blurRadius: 6,
                offset: const Offset(0, 3)
              )
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.category.secondIconPath != null)
                SizedBox(
                  width: 22,
                  height: 18,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        child: Image.asset(
                          widget.category.iconPath,
                          width: 16,
                          height: 16,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink()
                        )
                      ),
                      Positioned(
                        right: 0,
                        top: 2,
                        child: Image.asset(
                          widget.category.secondIconPath!,
                          width: 14,
                          height: 14,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink()
                        )
                      ),
                    ]
                  ),
                )
              else
                Image.asset(
                  widget.category.iconPath,
                  width: 18,
                  height: 18,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.category,
                    color: widget.isSelected ? Colors.white : Colors.green.shade600,
                    size: 18
                  )
                ),
              const SizedBox(width: 8),
              Text(
                widget.category.name,
                style: TextStyle(
                  fontFamily: 'HennyPenny',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: widget.isSelected ? Colors.white : Colors.black87
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  final String selectedCategory;
  final Function(ProductModel) onAddToCart;
  const _ProductGrid({required this.selectedCategory, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ProductModel>>(
      stream: ProductService.getProducts(),
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
                  'Error loading products',
                  style: TextStyle(
                    fontFamily: 'HennyPenny',
                    fontSize: 16,
                    color: Colors.grey.shade600
                  ),
                ),
              ],
            ),
          );
        }

        final allProducts = snapshot.data ?? [];
        final filteredProducts = selectedCategory == "All"
            ? allProducts
            : allProducts.where((p) => p.category == selectedCategory).toList();

        if (filteredProducts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_basket_outlined, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text(
                  'No products found',
                  style: TextStyle(
                    fontFamily: 'HennyPenny',
                    fontSize: 16,
                    color: Colors.grey.shade600
                  ),
                ),
              ],
            ),
          );
        }

        final width = MediaQuery.of(context).size.width;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: width > 600 ? 3 : 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.72
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (_, i) => _ProductCard(
              product: filteredProducts[i],
              onAddToCart: () => onAddToCart(filteredProducts[i])
            ),
          ),
        );
      },
    );
  }
}

class _ProductCard extends StatefulWidget {
  final ProductModel product;
  final VoidCallback onAddToCart;
  const _ProductCard({required this.product, required this.onAddToCart});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
  late final _scale = Tween<double>(begin: 1.0, end: 1.02).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getColor() {
    final t = widget.product.name.toLowerCase();
    if (t.contains('carrot')) return Colors.orange.shade100;
    if (t.contains('milk')) return Colors.blue.shade50;
    if (t.contains('potato')) return Colors.brown.shade100;
    if (t.contains('juice')) return Colors.orange.shade100;
    if (t.contains('chicken')) return Colors.red.shade50;
    if (t.contains('melon')) return Colors.green.shade100;
    if (t.contains('tomato')) return Colors.red.shade100;
    if (t.contains('onion')) return Colors.purple.shade50;
    return Colors.grey.shade100;
  }

  IconData _getIcon() {
    final t = widget.product.name.toLowerCase();
    if (t.contains('carrot') || t.contains('tomato') || t.contains('onion') || t.contains('potato')) return Icons.eco;
    if (t.contains('milk')) return Icons.local_drink;
    if (t.contains('juice')) return Icons.local_cafe;
    if (t.contains('chicken') || t.contains('meat')) return Icons.restaurant;
    if (t.contains('melon')) return Icons.apple;
    return Icons.shopping_basket;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 3)
              )
            ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: _getColor()
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      widget.product.imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(_getIcon(), size: 36, color: Colors.grey.shade600),
                            const SizedBox(height: 6),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                widget.product.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'HennyPenny',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade700
                                )
                              )
                            )
                          ]
                        )
                      )
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.2
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '1kg',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 10,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w400,
                        height: 1.2
                      )
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '₹${widget.product.price.toInt()}',
                      style: const TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 107, 210, 254),
                        height: 1.2
                      )
                    ),
                    const SizedBox(height: 8),
                    _AddToCartButton(onPressed: widget.onAddToCart),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddToCartButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _AddToCartButton({required this.onPressed});

  @override
  State<_AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<_AddToCartButton> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
  late final _scale = Tween<double>(begin: 1.0, end: 0.95).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: _controller.reverse,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.lightBlue.shade400,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.lightBlue.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2)
              )
            ],
          ),
          child: const Center(
            child: Text(
              'Add',
              style: TextStyle(
                fontFamily: 'HennyPenny',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )
            )
          ),
        ),
      ),
    );
  }
}