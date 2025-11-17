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
  final String transformBenefit;
  bool isIncluded;

  RecipeSuggestion({
    required this.id,
    required this.name,
    required this.time,
    required this.mealType,
    required this.ingredients,
    required this.preparation,
    required this.description,
    required this.transformBenefit,
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

enum PricingTier { standard, premium }

class SculptTransformPage extends StatefulWidget {
  const SculptTransformPage({super.key});

  @override
  State<SculptTransformPage> createState() => _SculptTransformPageState();
}

class _SculptTransformPageState extends State<SculptTransformPage> {
  var _selectedDay = 1;
  var _selectedTier = PricingTier.standard;
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
    if (tier == PricingTier.standard) {
      return _getStandardRecipes(day);
    } else {
      return _getPremiumRecipes(day);
    }
  }

  List<RecipeSuggestion> _getStandardRecipes(int day) {
    final breakfastOptions = [
      RecipeSuggestion(
        id: 'b$day',
        name: 'Green Smoothie Bowl',
        time: '7:30 AM',
        mealType: 'Breakfast',
        description: 'Nutrient-dense smoothie packed with greens and fruits',
        transformBenefit: 'Boosts metabolism & provides sustained energy',
        preparation: '1. Blend spinach with banana\n2. Add protein powder\n3. Top with chia seeds and berries\n4. Enjoy fresh',
        ingredients: [
          IngredientItem(name: 'Spinach', quantity: '100', price: 15.0, category: 'Vegetables', unit: 'g'),
          IngredientItem(name: 'Banana', quantity: '1', price: 10.0, category: 'Fruits', unit: 'pc'),
          IngredientItem(name: 'Protein Powder', quantity: '20', price: 40.0, category: 'Supplements', unit: 'g'),
          IngredientItem(name: 'Chia Seeds', quantity: '15', price: 20.0, category: 'Seeds', unit: 'g'),
          IngredientItem(name: 'Berries', quantity: '50', price: 30.0, category: 'Fruits', unit: 'g'),
        ],
      ),
      RecipeSuggestion(
        id: 'b$day',
        name: 'Quinoa Porridge with Fruits',
        time: '7:30 AM',
        mealType: 'Breakfast',
        description: 'Protein-rich quinoa with natural sweetness',
        transformBenefit: 'Complete protein for muscle tone & fiber for satiety',
        preparation: '1. Cook quinoa in almond milk\n2. Add cinnamon\n3. Top with fresh fruits\n4. Drizzle honey',
        ingredients: [
          IngredientItem(name: 'Quinoa', quantity: '80', price: 35.0, category: 'Staples', unit: 'g'),
          IngredientItem(name: 'Almond Milk', quantity: '200', price: 30.0, category: 'Dairy', unit: 'ml'),
          IngredientItem(name: 'Apple', quantity: '1', price: 15.0, category: 'Fruits', unit: 'pc'),
          IngredientItem(name: 'Berries', quantity: '40', price: 25.0, category: 'Fruits', unit: 'g'),
          IngredientItem(name: 'Honey', quantity: '10', price: 10.0, category: 'Sweeteners', unit: 'g'),
        ],
      ),
    ];

    final lunchOptions = [
      RecipeSuggestion(
        id: 'l$day',
        name: 'Grilled Chicken Buddha Bowl',
        time: '1:00 PM',
        mealType: 'Lunch',
        description: 'Balanced bowl with lean protein and colorful veggies',
        transformBenefit: 'Balanced macros for lean muscle & fat loss',
        preparation: '1. Grill chicken breast\n2. Prepare quinoa\n3. Arrange vegetables\n4. Add tahini dressing',
        ingredients: [
          IngredientItem(name: 'Chicken Breast', quantity: '150', price: 75.0, category: 'Protein', unit: 'g'),
          IngredientItem(name: 'Quinoa', quantity: '80', price: 35.0, category: 'Staples', unit: 'g'),
          IngredientItem(name: 'Mixed Vegetables', quantity: '150', price: 30.0, category: 'Vegetables', unit: 'g'),
          IngredientItem(name: 'Avocado', quantity: '0.5', price: 30.0, category: 'Fats', unit: 'pc'),
          IngredientItem(name: 'Chickpeas', quantity: '50', price: 15.0, category: 'Protein', unit: 'g'),
        ],
      ),
      RecipeSuggestion(
        id: 'l$day',
        name: 'Salmon with Roasted Vegetables',
        time: '1:00 PM',
        mealType: 'Lunch',
        description: 'Omega-3 rich salmon with rainbow vegetables',
        transformBenefit: 'Healthy fats for hormones & colorful antioxidants',
        preparation: '1. Bake salmon fillet\n2. Roast mixed vegetables\n3. Prepare lemon herb sauce\n4. Serve together',
        ingredients: [
          IngredientItem(name: 'Salmon Fillet', quantity: '150', price: 165.0, category: 'Seafood', unit: 'g'),
          IngredientItem(name: 'Sweet Potato', quantity: '150', price: 20.0, category: 'Vegetables', unit: 'g'),
          IngredientItem(name: 'Broccoli', quantity: '100', price: 20.0, category: 'Vegetables', unit: 'g'),
          IngredientItem(name: 'Bell Peppers', quantity: '100', price: 25.0, category: 'Vegetables', unit: 'g'),
          IngredientItem(name: 'Olive Oil', quantity: '10', price: 10.0, category: 'Oils', unit: 'ml'),
        ],
      ),
    ];

    final snackOptions = [
      RecipeSuggestion(
        id: 's$day',
        name: 'Apple with Almond Butter',
        time: '4:30 PM',
        mealType: 'Snack',
        description: 'Simple snack with fiber and healthy fats',
        transformBenefit: 'Curbs cravings with natural sweetness & protein',
        preparation: '1. Slice fresh apple\n2. Spread almond butter\n3. Sprinkle cinnamon\n4. Enjoy',
        ingredients: [
          IngredientItem(name: 'Apple', quantity: '1', price: 15.0, category: 'Fruits', unit: 'pc'),
          IngredientItem(name: 'Almond Butter', quantity: '20', price: 35.0, category: 'Fats', unit: 'g'),
        ],
      ),
      RecipeSuggestion(
        id: 's$day',
        name: 'Greek Yogurt with Nuts',
        time: '4:30 PM',
        mealType: 'Snack',
        description: 'Protein-packed snack with crunch',
        transformBenefit: 'Protein for muscle & probiotics for gut health',
        preparation: '1. Take Greek yogurt\n2. Add mixed nuts\n3. Drizzle honey\n4. Mix and eat',
        ingredients: [
          IngredientItem(name: 'Greek Yogurt', quantity: '150', price: 40.0, category: 'Dairy', unit: 'g'),
          IngredientItem(name: 'Mixed Nuts', quantity: '30', price: 35.0, category: 'Nuts', unit: 'g'),
          IngredientItem(name: 'Honey', quantity: '10', price: 10.0, category: 'Sweeteners', unit: 'g'),
        ],
      ),
    ];

    final dinnerOptions = [
      RecipeSuggestion(
        id: 'd$day',
        name: 'Grilled Tofu with Stir-Fry Vegetables',
        time: '8:00 PM',
        mealType: 'Dinner',
        description: 'Light plant-based protein with colorful veggies',
        transformBenefit: 'Low-calorie, high-nutrition dinner for transformation',
        preparation: '1. Grill marinated tofu\n2. Stir-fry vegetables\n3. Add ginger-garlic sauce\n4. Serve hot',
        ingredients: [
          IngredientItem(name: 'Tofu', quantity: '150', price: 50.0, category: 'Protein', unit: 'g'),
          IngredientItem(name: 'Mixed Vegetables', quantity: '200', price: 40.0, category: 'Vegetables', unit: 'g'),
          IngredientItem(name: 'Brown Rice', quantity: '100', price: 15.0, category: 'Staples', unit: 'g'),
          IngredientItem(name: 'Sesame Oil', quantity: '10', price: 12.0, category: 'Oils', unit: 'ml'),
        ],
      ),
      RecipeSuggestion(
        id: 'd$day',
        name: 'Vegetable Soup with Lentils',
        time: '8:00 PM',
        mealType: 'Dinner',
        description: 'Warming, nutritious soup perfect for dinner',
        transformBenefit: 'Fiber-rich, low-calorie, high-satiety meal',
        preparation: '1. Cook lentils with vegetables\n2. Add herbs and spices\n3. Simmer until creamy\n4. Serve with whole wheat bread',
        ingredients: [
          IngredientItem(name: 'Red Lentils', quantity: '100', price: 20.0, category: 'Staples', unit: 'g'),
          IngredientItem(name: 'Mixed Vegetables', quantity: '200', price: 40.0, category: 'Vegetables', unit: 'g'),
          IngredientItem(name: 'Tomato', quantity: '3', price: 15.0, category: 'Vegetables', unit: 'pc'),
          IngredientItem(name: 'Whole Wheat Bread', quantity: '1', price: 8.0, category: 'Bakery', unit: 'slice'),
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
        name: 'Acai Bowl with Superfoods',
        time: '7:30 AM',
        mealType: 'Breakfast',
        description: 'Antioxidant-rich acai with premium toppings',
        transformBenefit: 'Superfood antioxidants for cellular health & energy',
        preparation: '1. Blend frozen acai with banana\n2. Pour in bowl\n3. Top with granola, goji berries, coconut\n4. Add chia and hemp seeds',
        ingredients: [
          IngredientItem(name: 'Acai Puree', quantity: '100', price: 80.0, category: 'Superfoods', unit: 'g'),
          IngredientItem(name: 'Banana', quantity: '1', price: 10.0, category: 'Fruits', unit: 'pc'),
          IngredientItem(name: 'Granola', quantity: '50', price: 45.0, category: 'Cereals', unit: 'g'),
          IngredientItem(name: 'Goji Berries', quantity: '20', price: 50.0, category: 'Superfoods', unit: 'g'),
          IngredientItem(name: 'Coconut Flakes', quantity: '15', price: 25.0, category: 'Nuts', unit: 'g'),
          IngredientItem(name: 'Chia Seeds', quantity: '15', price: 25.0, category: 'Seeds', unit: 'g'),
        ],
      ),
      RecipeSuggestion(
        id: 'pb$day',
        name: 'Smoked Salmon Avocado Toast',
        time: '7:30 AM',
        mealType: 'Breakfast',
        description: 'Gourmet breakfast with healthy fats and protein',
        transformBenefit: 'Omega-3 fats for brain & metabolism boost',
        preparation: '1. Toast sourdough bread\n2. Mash avocado with lemon\n3. Top with smoked salmon\n4. Add poached egg',
        ingredients: [
          IngredientItem(name: 'Smoked Salmon', quantity: '80', price: 150.0, category: 'Seafood', unit: 'g'),
          IngredientItem(name: 'Avocado', quantity: '1', price: 60.0, category: 'Fruits', unit: 'pc'),
          IngredientItem(name: 'Sourdough Bread', quantity: '2', price: 30.0, category: 'Bakery', unit: 'slices'),
          IngredientItem(name: 'Free-range Egg', quantity: '1', price: 12.0, category: 'Protein', unit: 'pc'),
        ],
      ),
    ];

    final lunchOptions = [
      RecipeSuggestion(
        id: 'pl$day',
        name: 'Grilled Sea Bass with Quinoa',
        time: '1:00 PM',
        mealType: 'Lunch',
        description: 'Premium fish with ancient grains and vegetables',
        transformBenefit: 'High-quality protein & complete amino acids',
        preparation: '1. Grill sea bass fillet\n2. Cook tri-color quinoa\n3. Roast asparagus\n4. Serve with lemon butter',
        ingredients: [
          IngredientItem(name: 'Sea Bass', quantity: '200', price: 280.0, category: 'Seafood', unit: 'g'),
          IngredientItem(name: 'Tri-color Quinoa', quantity: '100', price: 60.0, category: 'Staples', unit: 'g'),
          IngredientItem(name: 'Asparagus', quantity: '150', price: 80.0, category: 'Vegetables', unit: 'g'),
          IngredientItem(name: 'Cherry Tomatoes', quantity: '100', price: 40.0, category: 'Vegetables', unit: 'g'),
          IngredientItem(name: 'Butter', quantity: '20', price: 25.0, category: 'Dairy', unit: 'g'),
        ],
      ),
      RecipeSuggestion(
        id: 'pl$day',
        name: 'Grass-fed Beef with Sweet Potato',
        time: '1:00 PM',
        mealType: 'Lunch',
        description: 'Premium quality beef with nutrient-dense carbs',
        transformBenefit: 'High-quality protein & iron for transformation',
        preparation: '1. Grill grass-fed beef\n2. Roast sweet potato wedges\n3. Prepare chimichurri sauce\n4. Serve with salad',
        ingredients: [
          IngredientItem(name: 'Grass-fed Beef', quantity: '200', price: 250.0, category: 'Protein', unit: 'g'),
          IngredientItem(name: 'Sweet Potato', quantity: '200', price: 30.0, category: 'Vegetables', unit: 'g'),
          IngredientItem(name: 'Arugula', quantity: '100', price: 40.0, category: 'Vegetables', unit: 'g'),
          IngredientItem(name: 'Cherry Tomatoes', quantity: '100', price: 40.0, category: 'Vegetables', unit: 'g'),
        ],
      ),
    ];

    final snackOptions = [
      RecipeSuggestion(
        id: 'ps$day',
        name: 'Raw Vegan Energy Balls',
        time: '4:30 PM',
        mealType: 'Snack',
        description: 'Superfood-packed energy bites',
        transformBenefit: 'Natural energy with adaptogens & superfoods',
        preparation: '1. Blend dates, nuts, cacao\n2. Add maca powder\n3. Roll into balls\n4. Coat with coconut',
        ingredients: [
          IngredientItem(name: 'Medjool Dates', quantity: '60', price: 50.0, category: 'Fruits', unit: 'g'),
          IngredientItem(name: 'Raw Almonds', quantity: '40', price: 50.0, category: 'Nuts', unit: 'g'),
          IngredientItem(name: 'Raw Cacao', quantity: '15', price: 35.0, category: 'Superfoods', unit: 'g'),
          IngredientItem(name: 'Maca Powder', quantity: '10', price: 40.0, category: 'Superfoods', unit: 'g'),
        ],
      ),
      RecipeSuggestion(
        id: 'ps$day',
        name: 'Chia Pudding with Berries',
        time: '4:30 PM',
        mealType: 'Snack',
        description: 'Omega-3 rich pudding with antioxidants',
        transformBenefit: 'Healthy fats & fiber for sustained energy',
        preparation: '1. Mix chia with coconut milk overnight\n2. Layer with berry compote\n3. Top with fresh berries\n4. Add bee pollen',
        ingredients: [
          IngredientItem(name: 'Chia Seeds', quantity: '30', price: 40.0, category: 'Seeds', unit: 'g'),
          IngredientItem(name: 'Coconut Milk', quantity: '200', price: 40.0, category: 'Dairy', unit: 'ml'),
          IngredientItem(name: 'Mixed Berries', quantity: '100', price: 60.0, category: 'Fruits', unit: 'g'),
          IngredientItem(name: 'Bee Pollen', quantity: '5', price: 25.0, category: 'Superfoods', unit: 'g'),
        ],
      ),
    ];

    final dinnerOptions = [
      RecipeSuggestion(
        id: 'pd$day',
        name: 'Miso-glazed Cod with Bok Choy',
        time: '8:00 PM',
        mealType: 'Dinner',
        description: 'Asian-inspired light dinner',
        transformBenefit: 'Low-calorie, high-protein with probiotics',
        preparation: '1. Marinate cod in miso\n2. Bake until flaky\n3. Steam bok choy\n4. Serve with brown rice',
        ingredients: [
          IngredientItem(name: 'Cod Fillet', quantity: '200', price: 220.0, category: 'Seafood', unit: 'g'),
          IngredientItem(name: 'Miso Paste', quantity: '20', price: 40.0, category: 'Condiments', unit: 'g'),
          IngredientItem(name: 'Bok Choy', quantity: '150', price: 35.0, category: 'Vegetables', unit: 'g'),
          IngredientItem(name: 'Brown Rice', quantity: '80', price: 12.0, category: 'Staples', unit: 'g'),
        ],
      ),
      RecipeSuggestion(
        id: 'pd$day',
        name: 'Zucchini Noodles with Prawns',
        time: '8:00 PM',
        mealType: 'Dinner',
        description: 'Low-carb pasta alternative with seafood',
        transformBenefit: 'Ultra-low calorie, high protein for sculpting',
        preparation: '1. Spiralize zucchini\n2. Sauté prawns with garlic\n3. Toss with cherry tomatoes\n4. Add fresh basil',
        ingredients: [
          IngredientItem(name: 'Prawns', quantity: '200', price: 250.0, category: 'Seafood', unit: 'g'),
          IngredientItem(name: 'Zucchini', quantity: '300', price: 50.0, category: 'Vegetables', unit: 'g'),
          IngredientItem(name: 'Cherry Tomatoes', quantity: '100', price: 40.0, category: 'Vegetables', unit: 'g'),
          IngredientItem(name: 'Fresh Basil', quantity: '10', price: 15.0, category: 'Herbs', unit: 'g'),
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
            gradient: _selectedTier == PricingTier.standard
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF00C9A7),
                      Color(0xFF00E5A0),
                      Color(0xFF00FF99),
                    ],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF667eea),
                      Color(0xFF764ba2),
                      Color(0xFF8e54e9),
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
                          Icons.self_improvement,
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
                              _selectedTier == PricingTier.standard 
                                  ? 'Sculpt & Transform' 
                                  : 'Premium Transformation',
                              style: const TextStyle(
                                fontFamily: 'HennyPenny',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              _selectedTier == PricingTier.standard
                                  ? 'Smart nutrition for body transformation'
                                  : 'Elite nutrition for optimal transformation',
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
                            _selectedTier == PricingTier.standard
                                ? 'Balanced nutrition • Tone & sculpt • Sustainable results'
                                : 'Premium superfoods • Optimize metabolism • Transform faster',
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
                  _selectedTier = PricingTier.standard;
                  _updatePlansForTier();
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: _selectedTier == PricingTier.standard
                      ? LinearGradient(
                          colors: [Colors.green.shade400, Colors.teal.shade400],
                        )
                      : null,
                  color: _selectedTier == PricingTier.standard ? null : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _selectedTier == PricingTier.standard
                        ? Colors.transparent
                        : Colors.grey.shade300,
                    width: 2,
                  ),
                  boxShadow: _selectedTier == PricingTier.standard
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
                      Icons.spa,
                      color: _selectedTier == PricingTier.standard
                          ? Colors.white
                          : Colors.green.shade700,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Standard Plan',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _selectedTier == PricingTier.standard
                            ? Colors.white
                            : const Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      'Balanced',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 11,
                        color: _selectedTier == PricingTier.standard
                            ? Colors.white.withOpacity(0.9)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _selectedTier == PricingTier.standard
                            ? Colors.white.withOpacity(0.2)
                            : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '₹120-160/day',
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _selectedTier == PricingTier.standard
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
                          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
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
                            color: Colors.purple.withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: _selectedTier == PricingTier.premium
                          ? Colors.white
                          : Colors.purple.shade700,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Premium Plan',
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
                      'Superfoods',
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
                            : Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '₹350-480/day',
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _selectedTier == PricingTier.premium
                              ? Colors.white
                              : Colors.purple.shade700,
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

  // Similar implementation for other build methods (buildPriceOverview, buildInfoBanner, etc.)
  // Following the same pattern as holistic_wellness.dart but with green/purple theme

  Widget _buildPriceOverview() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _selectedTier == PricingTier.standard
              ? [Colors.green.shade50, Colors.teal.shade50]
              : [Colors.purple.shade50, Colors.indigo.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _selectedTier == PricingTier.standard
              ? Colors.green.shade200
              : Colors.purple.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: (_selectedTier == PricingTier.standard 
                ? Colors.green 
                : Colors.purple).withOpacity(0.1),
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
                  Icons.self_improvement,
                  color: _selectedTier == PricingTier.standard
                      ? Colors.green.shade700
                      : Colors.purple.shade700,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Transformation Plan Cost',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      'Sculpt your dream body',
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
                            color: _selectedTier == PricingTier.standard
                                ? Colors.green.shade700
                                : Colors.purple.shade700,
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
                            color: Colors.teal.shade700,
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
                    color: _selectedTier == PricingTier.standard
                        ? Colors.green.shade50
                        : Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.trending_up,
                        size: 18,
                        color: _selectedTier == PricingTier.standard
                            ? Colors.green.shade700
                            : Colors.purple.shade700,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Transform your body in 30 days',
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
        color: _selectedTier == PricingTier.standard
            ? Colors.green.shade50
            : Colors.purple.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _selectedTier == PricingTier.standard
              ? Colors.green.shade200
              : Colors.purple.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.auto_graph,
              color: _selectedTier == PricingTier.standard
                  ? Colors.green.shade700
                  : Colors.purple.shade700,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transformation Meal Plans',
                  style: TextStyle(
                    fontFamily: 'HennyPenny',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: _selectedTier == PricingTier.standard
                        ? Colors.green.shade900
                        : Colors.purple.shade900,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Balanced nutrition for sustainable results',
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
                  color: _selectedTier == PricingTier.standard
                      ? Colors.green.shade700
                      : Colors.purple.shade700,
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
                        ? (_selectedTier == PricingTier.standard
                            ? const LinearGradient(
                                colors: [Color(0xFF00C9A7), Color(0xFF00FF99)],
                              )
                            : const LinearGradient(
                                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
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
                              color: (_selectedTier == PricingTier.standard
                                  ? Colors.green
                                  : Colors.purple).withOpacity(0.3),
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
                'Transformation Recipes',
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
                  color: _selectedTier == PricingTier.standard
                      ? Colors.green.shade100
                      : Colors.purple.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      size: 14,
                      color: _selectedTier == PricingTier.standard
                          ? Colors.green.shade700
                          : Colors.purple.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$_totalIngredients items',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _selectedTier == PricingTier.standard
                            ? Colors.green.shade700
                            : Colors.purple.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...recipes.map((recipe) => _TransformRecipeCard(
                recipe: recipe,
                mealTypeColor: _getMealTypeColor(recipe.mealType),
                onToggle: () {
                  setState(() {
                    recipe.isIncluded = !recipe.isIncluded;
                  });
                },
                onCustomize: () {}, // Implement similar to holistic_wellness
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
            color: (_selectedTier == PricingTier.standard
                ? Colors.green
                : Colors.purple).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {}, // Implement subscribe logic
          borderRadius: BorderRadius.circular(18),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _selectedTier == PricingTier.standard
                    ? [Colors.green.shade600, Colors.green.shade400]
                    : [Colors.purple.shade600, Colors.purple.shade400],
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
                        'Start Transformation',
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
}

// Transform Recipe Card Widget
class _TransformRecipeCard extends StatelessWidget {
  final RecipeSuggestion recipe;
  final Color mealTypeColor;
  final VoidCallback onToggle;
  final VoidCallback onCustomize;

  const _TransformRecipeCard({
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
                Switch(
                  value: recipe.isIncluded,
                  onChanged: (val) => onToggle(),
                  activeColor: Colors.green.shade600,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
            if (recipe.isIncluded) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome, size: 16, color: Colors.green.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        recipe.transformBenefit,
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 10,
                          color: Colors.green.shade900,
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
            ],
          ],
        ),
      ),
    );
  }
}