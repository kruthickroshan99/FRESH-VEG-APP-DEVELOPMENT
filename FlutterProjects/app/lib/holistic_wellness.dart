import 'package:flutter/material.dart';

// 🏷️ Models
class IngredientItem {
  final String name;
  final String quantity;
  final double price;
  final String category;
  final String unit;
  bool isSelected;

  IngredientItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.category,
    required this.unit,
    this.isSelected = true,
  });
}

class RecipeSuggestion {
  final String id;
  final String name;
  final String time;
  final String mealType;
  final List<IngredientItem> ingredients;
  final String preparation;
  final String description;
  bool isIncluded;

  RecipeSuggestion({
    required this.id,
    required this.name,
    required this.time,
    required this.mealType,
    required this.ingredients,
    required this.preparation,
    required this.description,
    this.isIncluded = true,
  });

  double get totalPrice {
    if (!isIncluded) return 0;
    return ingredients.where((i) => i.isSelected).fold(0.0, (sum, i) => sum + i.price);
  }
}

class DailyPlan {
  final int day;
  final List<RecipeSuggestion> recipes;

  DailyPlan({required this.day, required this.recipes});

  double get dailyPrice => recipes.fold(0.0, (sum, recipe) => sum + recipe.totalPrice);
}

enum PricingTier { affordable, premium }

class HolisticWellnessPage extends StatefulWidget {
  const HolisticWellnessPage({super.key});

  @override
  State<HolisticWellnessPage> createState() => _HolisticWellnessPageState();
}

class _HolisticWellnessPageState extends State<HolisticWellnessPage> {
  var _selectedDay = 1;
  var _selectedTier = PricingTier.affordable;
  late List<DailyPlan> _dailyPlans;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _dailyPlans = _generateDailyPlans();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<DailyPlan> _generateDailyPlans() {
    return List.generate(30, (dayIndex) {
      final day = dayIndex + 1;
      return DailyPlan(
        day: day,
        recipes: _getRecipesForDay(day, _selectedTier),
      );
    });
  }

  void _updatePlansForTier() {
    setState(() {
      _dailyPlans = _generateDailyPlans();
    });
  }

  List<RecipeSuggestion> _getRecipesForDay(int day, PricingTier tier) {
    if (tier == PricingTier.affordable) {
      return _getAffordableRecipes(day);
    } else {
      return _getPremiumRecipes(day);
    }
  }

  List<RecipeSuggestion> _getAffordableRecipes(int day) {
    final breakfastOptions = [
      RecipeSuggestion(
        id: 'b$day',
        name: 'Poha with Peanuts',
        time: '8:00 AM',
        mealType: 'Breakfast',
        description: 'Traditional flattened rice with vegetables and peanuts',
        preparation: '1. Heat oil, add mustard seeds\n2. Add curry leaves, green chilies\n3. Add vegetables and poha\n4. Mix well and garnish with peanuts and lemon',
        ingredients: [
          IngredientItem(name: 'Poha', quantity: '100', price: 8.0, category: 'Staples', unit: 'g'),
          IngredientItem(name: 'Peanuts', quantity: '20', price: 5.0, category: 'Staples', unit: 'g'),
          IngredientItem(name: 'Onion', quantity: '1', price: 3.0, category: 'Vegetables', unit: 'pc'),
          IngredientItem(name: 'Potato', quantity: '1', price: 4.0, category: 'Vegetables', unit: 'pc'),
        ],
      ),
      RecipeSuggestion(
        id: 'b$day',
        name: 'Vegetable Upma',
        time: '8:00 AM',
        mealType: 'Breakfast',
        description: 'Healthy semolina porridge with fresh vegetables',
        preparation: '1. Roast semolina until light golden\n2. Sauté vegetables with spices\n3. Add water and roasted semolina\n4. Cook until thick consistency',
        ingredients: [
          IngredientItem(name: 'Semolina', quantity: '100', price: 10.0, category: 'Staples', unit: 'g'),
          IngredientItem(name: 'Carrot', quantity: '1', price: 5.0, category: 'Vegetables', unit: 'pc'),
          IngredientItem(name: 'Beans', quantity: '50', price: 6.0, category: 'Vegetables', unit: 'g'),
          IngredientItem(name: 'Onion', quantity: '1', price: 3.0, category: 'Vegetables', unit: 'pc'),
        ],
      ),
    ];

    final lunchOptions = [
      RecipeSuggestion(
        id: 'l$day',
        name: 'Dal Rice with Sabzi',
        time: '1:00 PM',
        mealType: 'Lunch',
        description: 'Complete Indian meal with lentils, rice and seasonal vegetables',
        preparation: '1. Cook rice and dal separately\n2. Temper dal with spices\n3. Prepare seasonal vegetable curry\n4. Serve together with salad',
        ingredients: [
          IngredientItem(name: 'Rice', quantity: '150', price: 12.0, category: 'Staples', unit: 'g'),
          IngredientItem(name: 'Toor Dal', quantity: '100', price: 15.0, category: 'Staples', unit: 'g'),
          IngredientItem(name: 'Potato', quantity: '1', price: 4.0, category: 'Vegetables', unit: 'pc'),
          IngredientItem(name: 'Tomato', quantity: '2', price: 10.0, category: 'Vegetables', unit: 'pc'),
          IngredientItem(name: 'Onion', quantity: '1', price: 3.0, category: 'Vegetables', unit: 'pc'),
        ],
      ),
      RecipeSuggestion(
        id: 'l$day',
        name: 'Chicken Curry with Rice',
        time: '1:00 PM',
        mealType: 'Lunch',
        description: 'Spicy chicken curry with steamed rice',
        preparation: '1. Marinate chicken with spices\n2. Cook with onion-tomato gravy\n3. Simmer until tender\n4. Serve with steamed rice',
        ingredients: [
          IngredientItem(name: 'Chicken', quantity: '200', price: 80.0, category: 'Meat', unit: 'g'),
          IngredientItem(name: 'Rice', quantity: '150', price: 12.0, category: 'Staples', unit: 'g'),
          IngredientItem(name: 'Onion', quantity: '2', price: 6.0, category: 'Vegetables', unit: 'pc'),
          IngredientItem(name: 'Tomato', quantity: '3', price: 15.0, category: 'Vegetables', unit: 'pc'),
        ],
      ),
    ];

    final snackOptions = [
      RecipeSuggestion(
        id: 's$day',
        name: 'Vegetable Pakoras',
        time: '5:00 PM',
        mealType: 'Snack',
        description: 'Crispy vegetable fritters with tea',
        preparation: '1. Mix vegetables with gram flour batter\n2. Deep fry until golden and crispy\n3. Serve hot with green chutney',
        ingredients: [
          IngredientItem(name: 'Gram Flour', quantity: '100', price: 12.0, category: 'Staples', unit: 'g'),
          IngredientItem(name: 'Onion', quantity: '1', price: 3.0, category: 'Vegetables', unit: 'pc'),
          IngredientItem(name: 'Potato', quantity: '1', price: 4.0, category: 'Vegetables', unit: 'pc'),
        ],
      ),
      RecipeSuggestion(
        id: 's$day',
        name: 'Boiled Eggs Salad',
        time: '5:00 PM',
        mealType: 'Snack',
        description: 'Protein-rich egg salad with vegetables',
        preparation: '1. Boil eggs for 10 minutes\n2. Chop vegetables\n3. Mix with salt, pepper, lemon\n4. Serve chilled',
        ingredients: [
          IngredientItem(name: 'Eggs', quantity: '2', price: 12.0, category: 'Dairy', unit: 'pc'),
          IngredientItem(name: 'Cucumber', quantity: '1', price: 8.0, category: 'Vegetables', unit: 'pc'),
          IngredientItem(name: 'Tomato', quantity: '1', price: 5.0, category: 'Vegetables', unit: 'pc'),
        ],
      ),
    ];

    final dinnerOptions = [
      RecipeSuggestion(
        id: 'd$day',
        name: 'Khichdi with Vegetables',
        time: '8:30 PM',
        mealType: 'Dinner',
        description: 'Comfort rice and lentil porridge with vegetables',
        preparation: '1. Cook rice and moong dal together\n2. Add chopped vegetables\n3. Pressure cook for 3 whistles\n4. Temper with ghee and serve',
        ingredients: [
          IngredientItem(name: 'Rice', quantity: '100', price: 8.0, category: 'Staples', unit: 'g'),
          IngredientItem(name: 'Moong Dal', quantity: '50', price: 10.0, category: 'Staples', unit: 'g'),
          IngredientItem(name: 'Carrot', quantity: '1', price: 5.0, category: 'Vegetables', unit: 'pc'),
          IngredientItem(name: 'Beans', quantity: '50', price: 6.0, category: 'Vegetables', unit: 'g'),
        ],
      ),
      RecipeSuggestion(
        id: 'd$day',
        name: 'Dal Tadka with Chapati',
        time: '8:30 PM',
        mealType: 'Dinner',
        description: 'Tempered lentils with whole wheat flatbreads',
        preparation: '1. Cook dal until soft and creamy\n2. Prepare tadka with spices\n3. Make fresh chapatis\n4. Serve with vegetable side',
        ingredients: [
          IngredientItem(name: 'Toor Dal', quantity: '100', price: 15.0, category: 'Staples', unit: 'g'),
          IngredientItem(name: 'Wheat Flour', quantity: '150', price: 12.0, category: 'Staples', unit: 'g'),
          IngredientItem(name: 'Tomato', quantity: '2', price: 10.0, category: 'Vegetables', unit: 'pc'),
          IngredientItem(name: 'Onion', quantity: '1', price: 3.0, category: 'Vegetables', unit: 'pc'),
        ],
      ),
    ];

    return [
      breakfastOptions[day % breakfastOptions.length],
      lunchOptions[day % lunchOptions.length],
      snackOptions[day % snackOptions.length],
      dinnerOptions[day % dinnerOptions.length],
    ];
  }

  List<RecipeSuggestion> _getPremiumRecipes(int day) {
    final breakfastOptions = [
      RecipeSuggestion(
        id: 'pb$day',
        name: 'Paneer Paratha with Curd',
        time: '8:00 AM',
        mealType: 'Breakfast',
        description: 'Stuffed whole wheat flatbread with cottage cheese and fresh curd',
        preparation: '1. Prepare dough with wheat flour\n2. Make paneer filling with spices\n3. Stuff and roll parathas\n4. Cook on tawa with ghee, serve with curd',
        ingredients: [
          IngredientItem(name: 'Wheat Flour', quantity: '150', price: 12.0, category: 'Staples', unit: 'g'),
          IngredientItem(name: 'Fresh Paneer', quantity: '100', price: 60.0, category: 'Dairy', unit: 'g'),
          IngredientItem(name: 'Fresh Curd', quantity: '100', price: 25.0, category: 'Dairy', unit: 'g'),
          IngredientItem(name: 'Ghee', quantity: '30', price: 40.0, category: 'Dairy', unit: 'g'),
          IngredientItem(name: 'Butter', quantity: '20', price: 25.0, category: 'Dairy', unit: 'g'),
        ],
      ),
      RecipeSuggestion(
        id: 'pb$day',
        name: 'Masala Dosa with Sambar',
        time: '8:00 AM',
        mealType: 'Breakfast',
        description: 'Crispy rice crepe with spiced potato filling and lentil soup',
        preparation: '1. Prepare dosa batter (fermented)\n2. Make potato masala filling\n3. Cook dosas until crispy\n4. Serve with sambar and chutney',
        ingredients: [
          IngredientItem(name: 'Dosa Batter', quantity: '200', price: 30.0, category: 'Staples', unit: 'g'),
          IngredientItem(name: 'Potato', quantity: '3', price: 15.0, category: 'Vegetables', unit: 'pc'),
          IngredientItem(name: 'Sambar Powder', quantity: '20', price: 10.0, category: 'Spices', unit: 'g'),
          IngredientItem(name: 'Toor Dal', quantity: '50', price: 8.0, category: 'Staples', unit: 'g'),
          IngredientItem(name: 'Mixed Vegetables', quantity: '100', price: 20.0, category: 'Vegetables', unit: 'g'),
        ],
      ),
    ];

    final lunchOptions = [
      RecipeSuggestion(
        id: 'pl$day',
        name: 'Mutton Biryani with Raita',
        time: '1:00 PM',
        mealType: 'Lunch',
        description: 'Aromatic mutton biryani with fragrant basmati rice and cooling raita',
        preparation: '1. Marinate mutton with spices and curd\n2. Layer with cooked basmati rice\n3. Cook dum style for 30 minutes\n4. Serve with raita and curry',
        ingredients: [
          IngredientItem(name: 'Mutton', quantity: '250', price: 180.0, category: 'Meat', unit: 'g'),
          IngredientItem(name: 'Basmati Rice', quantity: '200', price: 60.0, category: 'Staples', unit: 'g'),
          IngredientItem(name: 'Curd', quantity: '100', price: 25.0, category: 'Dairy', unit: 'g'),
          IngredientItem(name: 'Onion', quantity: '2', price: 8.0, category: 'Vegetables', unit: 'pc'),
          IngredientItem(name: 'Biryani Masala', quantity: '30', price: 20.0, category: 'Spices', unit: 'g'),
        ],
      ),
      RecipeSuggestion(
        id: 'pl$day',
        name: 'Fish Curry with Rice',
        time: '1:00 PM',
        mealType: 'Lunch',
        description: 'Fresh fish cooked in tangy coconut curry with steamed rice',
        preparation: '1. Clean and marinate fish pieces\n2. Prepare coconut-based curry\n3. Cook fish in the curry\n4. Serve with steamed rice',
        ingredients: [
          IngredientItem(name: 'Fresh Fish', quantity: '250', price: 150.0, category: 'Seafood', unit: 'g'),
          IngredientItem(name: 'Coconut', quantity: '1', price: 30.0, category: 'Vegetables', unit: 'pc'),
          IngredientItem(name: 'Rice', quantity: '150', price: 12.0, category: 'Staples', unit: 'g'),
          IngredientItem(name: 'Tomato', quantity: '3', price: 15.0, category: 'Vegetables', unit: 'pc'),
          IngredientItem(name: 'Curry Leaves', quantity: '10', price: 5.0, category: 'Herbs', unit: 'g'),
        ],
      ),
    ];

    final snackOptions = [
      RecipeSuggestion(
        id: 'ps$day',
        name: 'Chicken Kebabs',
        time: '5:00 PM',
        mealType: 'Snack',
        description: 'Succulent grilled chicken kebabs with mint chutney',
        preparation: '1. Marinate chicken with spices and curd\n2. Thread onto skewers\n3. Grill until charred and juicy\n4. Serve with mint chutney and onion rings',
        ingredients: [
          IngredientItem(name: 'Chicken Breast', quantity: '200', price: 90.0, category: 'Meat', unit: 'g'),
          IngredientItem(name: 'Curd', quantity: '50', price: 12.0, category: 'Dairy', unit: 'g'),
          IngredientItem(name: 'Ginger-Garlic Paste', quantity: '20', price: 8.0, category: 'Spices', unit: 'g'),
          IngredientItem(name: 'Mint Leaves', quantity: '20', price: 10.0, category: 'Herbs', unit: 'g'),
          IngredientItem(name: 'Lemon', quantity: '1', price: 5.0, category: 'Fruits', unit: 'pc'),
        ],
      ),
      RecipeSuggestion(
        id: 'ps$day',
        name: 'Paneer Tikka',
        time: '5:00 PM',
        mealType: 'Snack',
        description: 'Marinated and grilled cottage cheese cubes with peppers',
        preparation: '1. Marinate paneer with tandoori masala\n2. Add bell peppers and onions\n3. Grill until slightly charred\n4. Serve hot with chutney',
        ingredients: [
          IngredientItem(name: 'Fresh Paneer', quantity: '200', price: 120.0, category: 'Dairy', unit: 'g'),
          IngredientItem(name: 'Bell Peppers', quantity: '2', price: 30.0, category: 'Vegetables', unit: 'pc'),
          IngredientItem(name: 'Curd', quantity: '50', price: 12.0, category: 'Dairy', unit: 'g'),
          IngredientItem(name: 'Tandoori Masala', quantity: '20', price: 15.0, category: 'Spices', unit: 'g'),
          IngredientItem(name: 'Onion', quantity: '1', price: 4.0, category: 'Vegetables', unit: 'pc'),
        ],
      ),
    ];

    final dinnerOptions = [
      RecipeSuggestion(
        id: 'pd$day',
        name: 'Butter Chicken with Naan',
        time: '8:30 PM',
        mealType: 'Dinner',
        description: 'Rich and creamy butter chicken with soft butter naan',
        preparation: '1. Marinate chicken with spices\n2. Cook in tomato-butter gravy\n3. Add cream for richness\n4. Serve with fresh butter naan',
        ingredients: [
          IngredientItem(name: 'Chicken', quantity: '250', price: 100.0, category: 'Meat', unit: 'g'),
          IngredientItem(name: 'Butter', quantity: '50', price: 60.0, category: 'Dairy', unit: 'g'),
          IngredientItem(name: 'Cream', quantity: '100', price: 50.0, category: 'Dairy', unit: 'ml'),
          IngredientItem(name: 'Tomato', quantity: '4', price: 20.0, category: 'Vegetables', unit: 'pc'),
          IngredientItem(name: 'Naan Bread', quantity: '3', price: 45.0, category: 'Bakery', unit: 'pc'),
        ],
      ),
      RecipeSuggestion(
        id: 'pd$day',
        name: 'Paneer Butter Masala with Roti',
        time: '8:30 PM',
        mealType: 'Dinner',
        description: 'Cottage cheese in rich tomato-butter gravy with whole wheat roti',
        preparation: '1. Prepare creamy tomato gravy\n2. Add fried paneer cubes\n3. Finish with butter and cream\n4. Serve with fresh rotis',
        ingredients: [
          IngredientItem(name: 'Fresh Paneer', quantity: '250', price: 150.0, category: 'Dairy', unit: 'g'),
          IngredientItem(name: 'Butter', quantity: '40', price: 50.0, category: 'Dairy', unit: 'g'),
          IngredientItem(name: 'Cream', quantity: '80', price: 40.0, category: 'Dairy', unit: 'ml'),
          IngredientItem(name: 'Tomato', quantity: '4', price: 20.0, category: 'Vegetables', unit: 'pc'),
          IngredientItem(name: 'Wheat Flour', quantity: '150', price: 12.0, category: 'Staples', unit: 'g'),
        ],
      ),
    ];

    return [
      breakfastOptions[day % breakfastOptions.length],
      lunchOptions[day % lunchOptions.length],
      snackOptions[day % snackOptions.length],
      dinnerOptions[day % dinnerOptions.length],
    ];
  }

  double get _totalMonthlyPrice {
    return _dailyPlans.fold(0.0, (sum, day) => sum + day.dailyPrice);
  }

  double get _dailyAveragePrice {
    return _totalMonthlyPrice / 30;
  }

  int get _totalIngredients {
    return _dailyPlans[_selectedDay - 1].recipes.fold(
          0,
          (sum, recipe) => sum + recipe.ingredients.where((i) => i.isSelected).length,
        );
  }

  Color _getMealTypeColor(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return const Color(0xFFFF9066);
      case 'lunch':
        return const Color(0xFF4CAF50);
      case 'snack':
        return const Color(0xFFFFB74D);
      case 'dinner':
        return const Color(0xFF5C6BC0);
      default:
        return const Color(0xFF667eea);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: _buildTierSelector()),
          SliverToBoxAdapter(child: _buildPriceOverview()),
          SliverToBoxAdapter(child: _buildInfoBanner()),
          SliverToBoxAdapter(child: _buildDaySelector()),
          SliverToBoxAdapter(child: _buildRecipesList()),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
      floatingActionButton: _buildSubscribeButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: _selectedTier == PricingTier.affordable
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4FC3F7),
                      Color(0xFF29B6F6),
                      Color(0xFF03A9F4),
                    ],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFD700),
                      Color(0xFFFFB300),
                      Color(0xFFFFA000),
                    ],
                  ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          _selectedTier == PricingTier.affordable 
                              ? Icons.kitchen 
                              : Icons.diamond,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedTier == PricingTier.affordable 
                                  ? 'Fresh Veg Plan' 
                                  : 'Premium Gourmet Plan',
                              style: const TextStyle(
                                fontFamily: 'HennyPenny',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              _selectedTier == PricingTier.affordable
                                  ? 'Fresh ingredients for your kitchen'
                                  : 'Luxurious ingredients for fine dining',
                              style: const TextStyle(
                                fontFamily: 'HennyPenny',
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _selectedTier == PricingTier.affordable
                                ? 'Fresh ingredients delivered • You cook at home'
                                : 'Premium ingredients delivered • Chef-quality at home',
                            style: const TextStyle(
                              fontFamily: 'HennyPenny',
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildTierSelector() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTier = PricingTier.affordable;
                  _updatePlansForTier();
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: _selectedTier == PricingTier.affordable
                      ? LinearGradient(
                          colors: [Colors.green.shade600, Colors.green.shade400],
                        )
                      : null,
                  color: _selectedTier == PricingTier.affordable ? null : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _selectedTier == PricingTier.affordable
                        ? Colors.transparent
                        : Colors.grey.shade300,
                    width: 2,
                  ),
                  boxShadow: _selectedTier == PricingTier.affordable
                      ? [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      color: _selectedTier == PricingTier.affordable
                          ? Colors.white
                          : Colors.green.shade700,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Middle Class',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _selectedTier == PricingTier.affordable
                            ? Colors.white
                            : const Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      'Affordable',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 11,
                        color: _selectedTier == PricingTier.affordable
                            ? Colors.white.withOpacity(0.9)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _selectedTier == PricingTier.affordable
                            ? Colors.white.withOpacity(0.2)
                            : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '₹100-150/day',
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _selectedTier == PricingTier.affordable
                              ? Colors.white
                              : Colors.green.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTier = PricingTier.premium;
                  _updatePlansForTier();
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: _selectedTier == PricingTier.premium
                      ? const LinearGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                        )
                      : null,
                  color: _selectedTier == PricingTier.premium ? null : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _selectedTier == PricingTier.premium
                        ? Colors.transparent
                        : Colors.grey.shade300,
                    width: 2,
                  ),
                  boxShadow: _selectedTier == PricingTier.premium
                      ? [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.diamond,
                      color: _selectedTier == PricingTier.premium
                          ? Colors.white
                          : Colors.orange.shade700,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Premium',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _selectedTier == PricingTier.premium
                            ? Colors.white
                            : const Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      'Rich & Gourmet',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 11,
                        color: _selectedTier == PricingTier.premium
                            ? Colors.white.withOpacity(0.9)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _selectedTier == PricingTier.premium
                            ? Colors.white.withOpacity(0.2)
                            : Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '₹250-350/day',
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _selectedTier == PricingTier.premium
                              ? Colors.white
                              : Colors.orange.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceOverview() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _selectedTier == PricingTier.affordable
              ? [Colors.green.shade50, Colors.blue.shade50]
              : [Colors.orange.shade50, Colors.amber.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _selectedTier == PricingTier.affordable
              ? Colors.green.shade200
              : Colors.orange.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: (_selectedTier == PricingTier.affordable 
                ? Colors.green 
                : Colors.orange).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.shopping_basket,
                  color: _selectedTier == PricingTier.affordable
                      ? Colors.green.shade700
                      : Colors.orange.shade700,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Ingredient Plan Cost',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      'Customize to fit your budget',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Monthly Total',
                          style: TextStyle(
                            fontFamily: 'HennyPenny',
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${_totalMonthlyPrice.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontFamily: 'HennyPenny',
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: _selectedTier == PricingTier.affordable
                                ? Colors.green.shade700
                                : Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Per Day',
                          style: TextStyle(
                            fontFamily: 'HennyPenny',
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${_dailyAveragePrice.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontFamily: 'HennyPenny',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _selectedTier == PricingTier.affordable
                        ? Colors.green.shade50
                        : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 18,
                        color: _selectedTier == PricingTier.affordable
                            ? Colors.green.shade700
                            : Colors.orange.shade700,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Add/remove ingredients to adjust cost',
                          style: TextStyle(
                            fontFamily: 'HennyPenny',
                            fontSize: 11,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.lightbulb_outline, color: Colors.blue.shade700, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recipe Suggestions Included',
                  style: TextStyle(
                    fontFamily: 'HennyPenny',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'We deliver fresh ingredients, you cook at home',
                  style: TextStyle(
                    fontFamily: 'HennyPenny',
                    fontSize: 10,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Day $_selectedDay',
                style: const TextStyle(
                  fontFamily: 'HennyPenny',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              Text(
                '₹${_dailyPlans[_selectedDay - 1].dailyPrice.toStringAsFixed(0)} worth ingredients',
                style: TextStyle(
                  fontFamily: 'HennyPenny',
                  fontSize: 12,
                  color: _selectedTier == PricingTier.affordable
                      ? Colors.green.shade700
                      : Colors.orange.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: 30,
            itemBuilder: (context, index) {
              final day = index + 1;
              final isSelected = _selectedDay == day;
              return GestureDetector(
                onTap: () => setState(() => _selectedDay = day),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 56,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? (_selectedTier == PricingTier.affordable
                            ? const LinearGradient(
                                colors: [Color(0xFF4FC3F7), Color(0xFF03A9F4)],
                              )
                            : const LinearGradient(
                                colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                              ))
                        : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? Colors.transparent : const Color(0xFFE5E7EB),
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: (_selectedTier == PricingTier.affordable
                                  ? const Color(0xFF03A9F4)
                                  : const Color(0xFFFFA500)).withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'DAY',
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white.withOpacity(0.8) : const Color(0xFF9CA3AF),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$day',
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : const Color(0xFF1F2937),
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
    );
  }

  Widget _buildRecipesList() {
    final recipes = _dailyPlans[_selectedDay - 1].recipes;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Recipe Suggestions',
                style: TextStyle(
                  fontFamily: 'HennyPenny',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _selectedTier == PricingTier.affordable
                      ? Colors.green.shade100
                      : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      size: 14,
                      color: _selectedTier == PricingTier.affordable
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$_totalIngredients items',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _selectedTier == PricingTier.affordable
                            ? Colors.green.shade700
                            : Colors.orange.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...recipes.map((recipe) => _RecipeCard(
                recipe: recipe,
                mealTypeColor: _getMealTypeColor(recipe.mealType),
                onToggle: () {
                  setState(() {
                    recipe.isIncluded = !recipe.isIncluded;
                  });
                },
                onCustomize: () => _showCustomizeDialog(recipe),
              )),
        ],
      ),
    );
  }

  Widget _buildSubscribeButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: (_selectedTier == PricingTier.affordable
                ? Colors.green
                : Colors.orange).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _subscribe,
          borderRadius: BorderRadius.circular(18),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _selectedTier == PricingTier.affordable
                    ? [Colors.green.shade600, Colors.green.shade400]
                    : [Colors.orange.shade600, Colors.orange.shade400],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Subscribe to Plan',
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '₹${_totalMonthlyPrice.toStringAsFixed(0)}/month',
                        style: const TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 11,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCustomizeDialog(RecipeSuggestion recipe) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _getMealTypeColor(recipe.mealType).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.edit,
                        color: _getMealTypeColor(recipe.mealType),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Customize Ingredients',
                            style: TextStyle(
                              fontFamily: 'HennyPenny',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          Text(
                            recipe.name,
                            style: const TextStyle(
                              fontFamily: 'HennyPenny',
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline, size: 20, color: Colors.blue.shade700),
                              const SizedBox(width: 8),
                              const Text(
                                'Select Ingredients to Order',
                                style: TextStyle(
                                  fontFamily: 'HennyPenny',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Cost: ₹${recipe.totalPrice.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontFamily: 'HennyPenny',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Required Ingredients:',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...recipe.ingredients.map((ingredient) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: ingredient.isSelected ? Colors.green.shade50 : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: ingredient.isSelected ? Colors.green.shade300 : Colors.grey.shade300,
                          ),
                        ),
                        child: CheckboxListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ingredient.name,
                                      style: const TextStyle(
                                        fontFamily: 'HennyPenny',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF374151),
                                      ),
                                    ),
                                    Text(
                                      '${ingredient.quantity}${ingredient.unit} • ${ingredient.category}',
                                      style: const TextStyle(
                                        fontFamily: 'HennyPenny',
                                        fontSize: 10,
                                        color: Color(0xFF9CA3AF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '₹${ingredient.price.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontFamily: 'HennyPenny',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                          value: ingredient.isSelected,
                          onChanged: (val) {
                            setModalState(() {
                              ingredient.isSelected = val ?? false;
                            });
                            setState(() {});
                          },
                          activeColor: Colors.green.shade600,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                    const Text(
                      'About this recipe:',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      recipe.description,
                      style: const TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'How to prepare:',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        recipe.preparation,
                        style: const TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 12,
                          color: Color(0xFF374151),
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: 'HennyPenny',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Ingredients updated successfully!',
                                style: TextStyle(fontFamily: 'HennyPenny'),
                              ),
                              backgroundColor: Colors.green.shade600,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontFamily: 'HennyPenny',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _subscribe() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _selectedTier == PricingTier.affordable
                      ? [Colors.green.shade600, Colors.green.shade400]
                      : [Colors.orange.shade600, Colors.orange.shade400],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 48),
            ),
            const SizedBox(height: 20),
            const Text(
              'Subscription Confirmed!',
              style: TextStyle(
                fontFamily: 'HennyPenny',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _selectedTier == PricingTier.affordable
                  ? 'Fresh ingredients will be delivered to your doorstep'
                  : 'Premium ingredients will be delivered to your doorstep',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'HennyPenny',
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _selectedTier == PricingTier.affordable
                    ? Colors.green.shade50
                    : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _selectedTier == PricingTier.affordable
                      ? Colors.green.shade200
                      : Colors.orange.shade200,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_shipping,
                        size: 18,
                        color: _selectedTier == PricingTier.affordable
                            ? const Color(0xFF4CAF50)
                            : Colors.orange.shade700,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'First delivery: Tomorrow',
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _selectedTier == PricingTier.affordable
                              ? const Color(0xFF4CAF50)
                              : Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '₹${_totalMonthlyPrice.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontFamily: 'HennyPenny',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: _selectedTier == PricingTier.affordable
                          ? const Color(0xFF4CAF50)
                          : Colors.orange.shade700,
                    ),
                  ),
                  const Text(
                    'per month',
                    style: TextStyle(
                      fontFamily: 'HennyPenny',
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedTier == PricingTier.affordable
                    ? Colors.green.shade600
                    : Colors.orange.shade600,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Start Cooking!',
                style: TextStyle(
                  fontFamily: 'HennyPenny',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Recipe Card Widget
class _RecipeCard extends StatelessWidget {
  final RecipeSuggestion recipe;
  final Color mealTypeColor;
  final VoidCallback onToggle;
  final VoidCallback onCustomize;

  const _RecipeCard({
    required this.recipe,
    required this.mealTypeColor,
    required this.onToggle,
    required this.onCustomize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: recipe.isIncluded ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: recipe.isIncluded ? mealTypeColor.withOpacity(0.3) : Colors.grey.shade300,
          width: 1.5,
        ),
        boxShadow: recipe.isIncluded
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: mealTypeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.restaurant_menu, color: mealTypeColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: mealTypeColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          recipe.mealType.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'HennyPenny',
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: mealTypeColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        recipe.name,
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: recipe.isIncluded ? const Color(0xFF1F2937) : const Color(0xFF9CA3AF),
                        ),
                      ),
                      Text(
                        '${recipe.time} • ₹${recipe.totalPrice.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 11,
                          color: recipe.isIncluded ? Colors.green.shade700 : const Color(0xFF9CA3AF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Switch(
                      value: recipe.isIncluded,
                      onChanged: (val) => onToggle(),
                      activeColor: Colors.green.shade600,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    if (recipe.isIncluded)
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.edit, size: 16, color: Colors.blue.shade700),
                        ),
                        onPressed: onCustomize,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                  ],
                ),
              ],
            ),
            if (recipe.isIncluded) ...[
              const SizedBox(height: 12),
              Text(
                recipe.description,
                style: const TextStyle(
                  fontFamily: 'HennyPenny',
                  fontSize: 11,
                  color: Color(0xFF6B7280),
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.shopping_basket, size: 14, color: Colors.grey.shade700),
                        const SizedBox(width: 6),
                        const Text(
                          'Ingredients to be delivered:',
                          style: TextStyle(
                            fontFamily: 'HennyPenny',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: recipe.ingredients.where((i) => i.isSelected).map((ingredient) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle, size: 10, color: Colors.green.shade600),
                              const SizedBox(width: 4),
                              Text(
                                ingredient.name,
                                style: const TextStyle(
                                  fontFamily: 'HennyPenny',
                                  fontSize: 9,
                                  color: Color(0xFF374151),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}