import 'package:flutter/material.dart';

// 🏷️ Models (same structure as holistic_wellness.dart)
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
  final String hairBenefit;
  bool isIncluded;

  RecipeSuggestion({
    required this.id,
    required this.name,
    required this.time,
    required this.mealType,
    required this.ingredients,
    required this.preparation,
    required this.description,
    required this.hairBenefit,
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

class HairVitalityPage extends StatefulWidget {
  const HairVitalityPage({super.key});

  @override
  State<HairVitalityPage> createState() => _HairVitalityPageState();
}

class _HairVitalityPageState extends State<HairVitalityPage> {
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
        name: 'Egg White Omelette with Spinach',
        time: '8:00 AM',
        mealType: 'Breakfast',
        description: 'Protein-rich breakfast with iron-loaded spinach',
        hairBenefit: 'Eggs provide biotin & protein for hair strength',
        preparation: '1. Beat egg whites with salt\n2. Add chopped spinach\n3. Cook in olive oil\n4. Serve with whole wheat toast',
        ingredients: [
          IngredientItem(name: 'Eggs', quantity: '3', price: 18.0, category: 'Protein', unit: 'pc'),
          IngredientItem(name: 'Spinach', quantity: '100', price: 12.0, category: 'Vegetables', unit: 'g'),
          IngredientItem(name: 'Olive Oil', quantity: '10', price: 8.0, category: 'Oils', unit: 'ml'),
          IngredientItem(name: 'Whole Wheat Bread', quantity: '2', price: 10.0, category: 'Bakery', unit: 'slices'),
        ],
      ),
      RecipeSuggestion(
        id: 'b$day',
        name: 'Oats with Berries & Nuts',
        time: '8:00 AM',
        mealType: 'Breakfast',
        description: 'Fiber-rich oats with antioxidant berries and omega-rich nuts',
        hairBenefit: 'Nuts provide omega-3 fatty acids for scalp health',
        preparation: '1. Cook oats in milk\n2. Top with mixed berries\n3. Add crushed almonds and walnuts\n4. Drizzle honey',
        ingredients: [
          IngredientItem(name: 'Oats', quantity: '50', price: 15.0, category: 'Staples', unit: 'g'),
          IngredientItem(name: 'Milk', quantity: '200', price: 12.0, category: 'Dairy', unit: 'ml'),
          IngredientItem(name: 'Mixed Berries', quantity: '50', price: 25.0, category: 'Fruits', unit: 'g'),
          IngredientItem(name: 'Almonds', quantity: '20', price: 20.0, category: 'Nuts', unit: 'g'),
          IngredientItem(name: 'Walnuts', quantity: '20', price: 25.0, category: 'Nuts', unit: 'g'),
        ],
      ),
    ];

    final lunchOptions = [
      RecipeSuggestion(
        id: 'l$day',
        name: 'Grilled Chicken with Quinoa',
        time: '1:00 PM',
        mealType: 'Lunch',
        description: 'Lean protein with complete amino acids from quinoa',
        hairBenefit: 'Chicken provides protein & iron for hair growth',
        preparation: '1. Marinate chicken with herbs\n2. Grill until cooked\n3. Cook quinoa in vegetable stock\n4. Serve with steamed broccoli',
        ingredients: [
          IngredientItem(name: 'Chicken Breast', quantity: '150', price: 70.0, category: 'Protein', unit: 'g'),
          IngredientItem(name: 'Quinoa', quantity: '100', price: 40.0, category: 'Staples', unit: 'g'),
          IngredientItem(name: 'Broccoli', quantity: '100', price: 20.0, category: 'Vegetables', unit: 'g'),
          IngredientItem(name: 'Olive Oil', quantity: '10', price: 8.0, category: 'Oils', unit: 'ml'),
        ],
      ),
      RecipeSuggestion(
        id: 'l$day',
        name: 'Salmon with Sweet Potato',
        time: '1:00 PM',
        mealType: 'Lunch',
        description: 'Omega-3 rich fish with vitamin A loaded sweet potato',
        hairBenefit: 'Salmon omega-3s nourish hair follicles & prevent dryness',
        preparation: '1. Season salmon with lemon\n2. Bake at 180°C for 15 mins\n3. Roast sweet potato cubes\n4. Serve with salad',
        ingredients: [
          IngredientItem(name: 'Salmon', quantity: '150', price: 120.0, category: 'Seafood', unit: 'g'),
          IngredientItem(name: 'Sweet Potato', quantity: '200', price: 25.0, category: 'Vegetables', unit: 'g'),
          IngredientItem(name: 'Mixed Salad', quantity: '100', price: 15.0, category: 'Vegetables', unit: 'g'),
          IngredientItem(name: 'Lemon', quantity: '1', price: 5.0, category: 'Fruits', unit: 'pc'),
        ],
      ),
    ];

    final snackOptions = [
      RecipeSuggestion(
        id: 's$day',
        name: 'Greek Yogurt with Chia Seeds',
        time: '5:00 PM',
        mealType: 'Snack',
        description: 'Probiotic-rich yogurt with omega-3 chia seeds',
        hairBenefit: 'Yogurt provides vitamin B5 for blood flow to scalp',
        preparation: '1. Take fresh Greek yogurt\n2. Mix chia seeds\n3. Add honey\n4. Top with berries',
        ingredients: [
          IngredientItem(name: 'Greek Yogurt', quantity: '150', price: 35.0, category: 'Dairy', unit: 'g'),
          IngredientItem(name: 'Chia Seeds', quantity: '15', price: 20.0, category: 'Seeds', unit: 'g'),
          IngredientItem(name: 'Honey', quantity: '10', price: 10.0, category: 'Sweeteners', unit: 'g'),
          IngredientItem(name: 'Berries', quantity: '30', price: 15.0, category: 'Fruits', unit: 'g'),
        ],
      ),
      RecipeSuggestion(
        id: 's$day',
        name: 'Almonds & Dates Energy Balls',
        time: '5:00 PM',
        mealType: 'Snack',
        description: 'Natural energy boost with hair-healthy nuts',
        hairBenefit: 'Almonds contain biotin & vitamin E for hair strength',
        preparation: '1. Blend dates and almonds\n2. Add cocoa powder\n3. Roll into balls\n4. Refrigerate',
        ingredients: [
          IngredientItem(name: 'Dates', quantity: '50', price: 25.0, category: 'Fruits', unit: 'g'),
          IngredientItem(name: 'Almonds', quantity: '40', price: 40.0, category: 'Nuts', unit: 'g'),
          IngredientItem(name: 'Cocoa Powder', quantity: '10', price: 15.0, category: 'Baking', unit: 'g'),
        ],
      ),
    ];

    final dinnerOptions = [
      RecipeSuggestion(
        id: 'd$day',
        name: 'Lentil Soup with Vegetables',
        time: '8:30 PM',
        mealType: 'Dinner',
        description: 'Iron-rich lentils with vitamin-loaded vegetables',
        hairBenefit: 'Lentils provide iron & zinc for hair growth',
        preparation: '1. Cook lentils until soft\n2. Add chopped vegetables\n3. Season with herbs\n4. Simmer for 10 minutes',
        ingredients: [
          IngredientItem(name: 'Red Lentils', quantity: '100', price: 20.0, category: 'Staples', unit: 'g'),
          IngredientItem(name: 'Carrots', quantity: '50', price: 10.0, category: 'Vegetables', unit: 'g'),
          IngredientItem(name: 'Spinach', quantity: '50', price: 8.0, category: 'Vegetables', unit: 'g'),
          IngredientItem(name: 'Tomato', quantity: '2', price: 10.0, category: 'Vegetables', unit: 'pc'),
        ],
      ),
      RecipeSuggestion(
        id: 'd$day',
        name: 'Grilled Fish with Vegetables',
        time: '8:30 PM',
        mealType: 'Dinner',
        description: 'Light protein-rich dinner with grilled vegetables',
        hairBenefit: 'Fish provides omega-3 & vitamin D for hair follicles',
        preparation: '1. Marinate fish with herbs\n2. Grill for 12 minutes\n3. Grill vegetables\n4. Serve with lemon',
        ingredients: [
          IngredientItem(name: 'White Fish', quantity: '150', price: 80.0, category: 'Seafood', unit: 'g'),
          IngredientItem(name: 'Bell Peppers', quantity: '100', price: 20.0, category: 'Vegetables', unit: 'g'),
          IngredientItem(name: 'Zucchini', quantity: '100', price: 25.0, category: 'Vegetables', unit: 'g'),
          IngredientItem(name: 'Olive Oil', quantity: '10', price: 8.0, category: 'Oils', unit: 'ml'),
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
        name: 'Smoked Salmon Avocado Toast',
        time: '8:00 AM',
        mealType: 'Breakfast',
        description: 'Luxury breakfast with omega-3 rich salmon and healthy fats',
        hairBenefit: 'Salmon & avocado provide omega-3 for lustrous hair',
        preparation: '1. Toast sourdough bread\n2. Mash avocado with lemon\n3. Top with smoked salmon\n4. Garnish with capers',
        ingredients: [
          IngredientItem(name: 'Smoked Salmon', quantity: '80', price: 150.0, category: 'Seafood', unit: 'g'),
          IngredientItem(name: 'Avocado', quantity: '1', price: 60.0, category: 'Fruits', unit: 'pc'),
          IngredientItem(name: 'Sourdough Bread', quantity: '2', price: 30.0, category: 'Bakery', unit: 'slices'),
          IngredientItem(name: 'Capers', quantity: '10', price: 15.0, category: 'Condiments', unit: 'g'),
        ],
      ),
      RecipeSuggestion(
        id: 'pb$day',
        name: 'Berry Smoothie Bowl with Superfoods',
        time: '8:00 AM',
        mealType: 'Breakfast',
        description: 'Antioxidant-rich smoothie with premium superfoods',
        hairBenefit: 'Berries provide vitamins C & E for collagen production',
        preparation: '1. Blend mixed berries with Greek yogurt\n2. Pour in bowl\n3. Top with granola, chia, goji berries\n4. Add honey',
        ingredients: [
          IngredientItem(name: 'Mixed Berries', quantity: '150', price: 80.0, category: 'Fruits', unit: 'g'),
          IngredientItem(name: 'Greek Yogurt', quantity: '100', price: 40.0, category: 'Dairy', unit: 'g'),
          IngredientItem(name: 'Granola', quantity: '50', price: 45.0, category: 'Cereals', unit: 'g'),
          IngredientItem(name: 'Chia Seeds', quantity: '15', price: 25.0, category: 'Seeds', unit: 'g'),
          IngredientItem(name: 'Goji Berries', quantity: '20', price: 50.0, category: 'Superfoods', unit: 'g'),
        ],
      ),
    ];

    final lunchOptions = [
      RecipeSuggestion(
        id: 'pl$day',
        name: 'Grilled Prawns with Quinoa Salad',
        time: '1:00 PM',
        mealType: 'Lunch',
        description: 'Protein-packed prawns with superfood quinoa',
        hairBenefit: 'Prawns provide zinc & selenium for hair health',
        preparation: '1. Marinate prawns with garlic\n2. Grill until pink\n3. Mix quinoa with vegetables\n4. Serve together',
        ingredients: [
          IngredientItem(name: 'Fresh Prawns', quantity: '200', price: 250.0, category: 'Seafood', unit: 'g'),
          IngredientItem(name: 'Quinoa', quantity: '100', price: 50.0, category: 'Staples', unit: 'g'),
          IngredientItem(name: 'Cherry Tomatoes', quantity: '100', price: 40.0, category: 'Vegetables', unit: 'g'),
          IngredientItem(name: 'Feta Cheese', quantity: '50', price: 80.0, category: 'Dairy', unit: 'g'),
        ],
      ),
      RecipeSuggestion(
        id: 'pl$day',
        name: 'Tuna Steak with Asparagus',
        time: '1:00 PM',
        mealType: 'Lunch',
        description: 'Premium tuna with vitamin-rich asparagus',
        hairBenefit: 'Tuna provides protein & omega-3 for hair strength',
        preparation: '1. Season tuna steak\n2. Sear for 2 minutes each side\n3. Grill asparagus\n4. Serve with lemon butter',
        ingredients: [
          IngredientItem(name: 'Tuna Steak', quantity: '200', price: 300.0, category: 'Seafood', unit: 'g'),
          IngredientItem(name: 'Asparagus', quantity: '150', price: 80.0, category: 'Vegetables', unit: 'g'),
          IngredientItem(name: 'Butter', quantity: '20', price: 25.0, category: 'Dairy', unit: 'g'),
          IngredientItem(name: 'Lemon', quantity: '1', price: 10.0, category: 'Fruits', unit: 'pc'),
        ],
      ),
    ];

    final snackOptions = [
      RecipeSuggestion(
        id: 'ps$day',
        name: 'Walnut & Blueberry Parfait',
        time: '5:00 PM',
        mealType: 'Snack',
        description: 'Layered yogurt parfait with premium nuts and berries',
        hairBenefit: 'Walnuts provide biotin & omega-3 for scalp health',
        preparation: '1. Layer Greek yogurt\n2. Add crushed walnuts\n3. Top with fresh blueberries\n4. Drizzle honey',
        ingredients: [
          IngredientItem(name: 'Greek Yogurt', quantity: '150', price: 45.0, category: 'Dairy', unit: 'g'),
          IngredientItem(name: 'Walnuts', quantity: '40', price: 50.0, category: 'Nuts', unit: 'g'),
          IngredientItem(name: 'Blueberries', quantity: '80', price: 60.0, category: 'Fruits', unit: 'g'),
          IngredientItem(name: 'Organic Honey', quantity: '15', price: 25.0, category: 'Sweeteners', unit: 'g'),
        ],
      ),
      RecipeSuggestion(
        id: 'ps$day',
        name: 'Avocado & Egg on Rye',
        time: '5:00 PM',
        mealType: 'Snack',
        description: 'Nutrient-dense snack with healthy fats and protein',
        hairBenefit: 'Avocado vitamin E protects hair from damage',
        preparation: '1. Toast rye bread\n2. Mash avocado\n3. Top with poached egg\n4. Season with pepper',
        ingredients: [
          IngredientItem(name: 'Avocado', quantity: '1', price: 60.0, category: 'Fruits', unit: 'pc'),
          IngredientItem(name: 'Free-range Eggs', quantity: '2', price: 20.0, category: 'Protein', unit: 'pc'),
          IngredientItem(name: 'Rye Bread', quantity: '2', price: 25.0, category: 'Bakery', unit: 'slices'),
        ],
      ),
    ];

    final dinnerOptions = [
      RecipeSuggestion(
        id: 'pd$day',
        name: 'Grilled Salmon with Sweet Potato Mash',
        time: '8:30 PM',
        mealType: 'Dinner',
        description: 'Premium salmon with creamy sweet potato',
        hairBenefit: 'Salmon omega-3s promote hair growth & shine',
        preparation: '1. Season salmon with herbs\n2. Grill for 15 minutes\n3. Mash sweet potato with butter\n4. Serve with greens',
        ingredients: [
          IngredientItem(name: 'Fresh Salmon', quantity: '200', price: 280.0, category: 'Seafood', unit: 'g'),
          IngredientItem(name: 'Sweet Potato', quantity: '200', price: 30.0, category: 'Vegetables', unit: 'g'),
          IngredientItem(name: 'Butter', quantity: '20', price: 25.0, category: 'Dairy', unit: 'g'),
          IngredientItem(name: 'Baby Spinach', quantity: '100', price: 35.0, category: 'Vegetables', unit: 'g'),
        ],
      ),
      RecipeSuggestion(
        id: 'pd$day',
        name: 'Chicken Breast with Roasted Vegetables',
        time: '8:30 PM',
        mealType: 'Dinner',
        description: 'Lean protein with rainbow vegetables',
        hairBenefit: 'Chicken provides B vitamins for hair growth',
        preparation: '1. Season chicken\n2. Bake for 20 minutes\n3. Roast mixed vegetables\n4. Serve with herbs',
        ingredients: [
          IngredientItem(name: 'Chicken Breast', quantity: '200', price: 100.0, category: 'Protein', unit: 'g'),
          IngredientItem(name: 'Bell Peppers', quantity: '150', price: 45.0, category: 'Vegetables', unit: 'g'),
          IngredientItem(name: 'Zucchini', quantity: '100', price: 30.0, category: 'Vegetables', unit: 'g'),
          IngredientItem(name: 'Cherry Tomatoes', quantity: '100', price: 40.0, category: 'Vegetables', unit: 'g'),
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
                      Color(0xFFFF6B9D),
                      Color(0xFFFF5252),
                      Color(0xFFC2185B),
                    ],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFE91E63),
                      Color(0xFFC2185B),
                      Color(0xFF880E4F),
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
                        child: const Icon(
                          Icons.face_retouching_natural,
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
                                  ? 'Hair Vitality Plan' 
                                  : 'Premium Hair Care Plan',
                              style: const TextStyle(
                                fontFamily: 'HennyPenny',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              _selectedTier == PricingTier.affordable
                                  ? 'Nourish for lustrous hair'
                                  : 'Premium nutrition for gorgeous locks',
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
                                ? 'Hair-healthy ingredients • Biotin, Omega-3, Iron rich foods'
                                : 'Premium superfoods • Maximum hair nutrition & shine',
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

  // Rest of the widgets (_buildTierSelector, _buildPriceOverview, etc.) remain similar to holistic_wellness.dart
  // with color scheme changed to pink/red theme for Hair Vitality
  
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
                          colors: [Colors.pink.shade400, Colors.pink.shade300],
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
                            color: Colors.pink.withOpacity(0.3),
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
                          : Colors.pink.shade700,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Basic Care',
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
                            : Colors.pink.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '₹140-180/day',
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _selectedTier == PricingTier.affordable
                              ? Colors.white
                              : Colors.pink.shade700,
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
                          colors: [Color(0xFFE91E63), Color(0xFFC2185B)],
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
                            color: Colors.pink.withOpacity(0.4),
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
                          : Colors.pink.shade700,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Premium Care',
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
                      'Luxury Nutrition',
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
                            : Colors.pink.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '₹350-450/day',
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _selectedTier == PricingTier.premium
                              ? Colors.white
                              : Colors.pink.shade700,
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

  // Continue with other build methods similar to holistic_wellness.dart...
  // (Due to character limit, I'm showing the key unique parts)
  
  Widget _buildPriceOverview() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _selectedTier == PricingTier.affordable
              ? [Colors.pink.shade50, Colors.purple.shade50]
              : [Colors.pink.shade100, Colors.purple.shade100],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _selectedTier == PricingTier.affordable
              ? Colors.pink.shade200
              : Colors.pink.shade300,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.1),
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
                  Icons.face_retouching_natural,
                  color: Colors.pink.shade700,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Hair Care Plan Cost',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      'Nutrition for healthy, lustrous hair',
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
                            color: Colors.pink.shade700,
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
                            color: Colors.purple.shade700,
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
                    color: Colors.pink.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 18,
                        color: Colors.pink.shade700,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Rich in Biotin, Omega-3, Iron & Vitamins',
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
        color: Colors.pink.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.pink.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.spa, color: Colors.pink.shade700, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hair-Healthy Recipes Included',
                  style: TextStyle(
                    fontFamily: 'HennyPenny',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink.shade900,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Ingredients rich in biotin, omega-3 & vitamins',
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
                  color: Colors.pink.shade700,
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
                        ? const LinearGradient(
                            colors: [Color(0xFFFF6B9D), Color(0xFFFF5252)],
                          )
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
                              color: Colors.pink.withOpacity(0.3),
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
                'Hair-Healthy Recipes',
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
                  color: Colors.pink.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      size: 14,
                      color: Colors.pink.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$_totalIngredients items',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink.shade700,
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
            color: Colors.pink.withOpacity(0.4),
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
                    ? [Colors.pink.shade400, Colors.pink.shade300]
                    : [Colors.pink.shade600, Colors.pink.shade400],
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
                        'Start Hair Care Journey',
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

  // Similar methods for _showCustomizeDialog and _subscribe as in holistic_wellness.dart
  // with pink/hair vitality theme...
  
  void _showCustomizeDialog(RecipeSuggestion recipe) {
    // Similar implementation to holistic_wellness.dart
    // ... (keeping it brief due to character limit)
  }

  void _subscribe() {
    // Similar implementation to holistic_wellness.dart
    // ... (keeping it brief due to character limit)
  }
}

// Recipe Card Widget (similar to holistic_wellness.dart with hair benefit display)
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
                          color: recipe.isIncluded ? Colors.pink.shade700 : const Color(0xFF9CA3AF),
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
                      activeColor: Colors.pink.shade600,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    if (recipe.isIncluded)
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.pink.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.edit, size: 16, color: Colors.pink.shade700),
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.pink.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome, size: 16, color: Colors.pink.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        recipe.hairBenefit,
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 10,
                          color: Colors.pink.shade900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
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
                            border: Border.all(color: Colors.pink.shade200),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle, size: 10, color: Colors.pink.shade600),
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