import 'package:flutter/material.dart';

// 🏷️ Models
class IngredientItem {
  final String name;
  final String quantity;
  final double price;
  final String category;
  final String unit;
  final int protein; // grams of protein
  final int calories;
  bool isSelected;

  IngredientItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.category,
    required this.unit,
    required this.protein,
    required this.calories,
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
  final String muscleBenefit;
  final int totalProtein;
  final int totalCalories;
  bool isIncluded;

  RecipeSuggestion({
    required this.id,
    required this.name,
    required this.time,
    required this.mealType,
    required this.ingredients,
    required this.preparation,
    required this.description,
    required this.muscleBenefit,
    required this.totalProtein,
    required this.totalCalories,
    this.isIncluded = true,
  });

  double get totalPrice {
    if (!isIncluded) return 0;
    return ingredients.where((i) => i.isSelected).fold(0.0, (sum, i) => sum + i.price);
  }

  int get currentProtein {
    if (!isIncluded) return 0;
    return ingredients.where((i) => i.isSelected).fold(0, (sum, i) => sum + i.protein);
  }

  int get currentCalories {
    if (!isIncluded) return 0;
    return ingredients.where((i) => i.isSelected).fold(0, (sum, i) => sum + i.calories);
  }
}

class DailyPlan {
  final int day;
  final List<RecipeSuggestion> recipes;

  DailyPlan({required this.day, required this.recipes});

  double get dailyPrice => recipes.fold(0.0, (sum, recipe) => sum + recipe.totalPrice);
  int get dailyProtein => recipes.fold(0, (sum, recipe) => sum + recipe.currentProtein);
  int get dailyCalories => recipes.fold(0, (sum, recipe) => sum + recipe.currentCalories);
}

enum PricingTier { bulking, cutting }

class MuscleBuilderPage extends StatefulWidget {
  const MuscleBuilderPage({super.key});

  @override
  State<MuscleBuilderPage> createState() => _MuscleBuilderPageState();
}

class _MuscleBuilderPageState extends State<MuscleBuilderPage> {
  var _selectedDay = 1;
  var _selectedTier = PricingTier.bulking;
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
    if (tier == PricingTier.bulking) {
      return _getBulkingRecipes(day);
    } else {
      return _getCuttingRecipes(day);
    }
  }

  List<RecipeSuggestion> _getBulkingRecipes(int day) {
    final breakfastOptions = [
      RecipeSuggestion(
        id: 'b$day',
        name: 'Egg White Scramble with Oats',
        time: '7:00 AM',
        mealType: 'Breakfast',
        description: 'High protein breakfast to kickstart muscle building',
        muscleBenefit: '35g protein for muscle repair & growth',
        totalProtein: 35,
        totalCalories: 450,
        preparation: '1. Scramble 6 egg whites\n2. Cook oats in milk\n3. Add banana slices\n4. Top with peanut butter',
        ingredients: [
          IngredientItem(name: 'Egg Whites', quantity: '6', price: 30.0, category: 'Protein', unit: 'pc', protein: 20, calories: 100),
          IngredientItem(name: 'Oats', quantity: '80', price: 24.0, category: 'Carbs', unit: 'g', protein: 10, calories: 280),
          IngredientItem(name: 'Banana', quantity: '1', price: 10.0, category: 'Fruits', unit: 'pc', protein: 1, calories: 105),
          IngredientItem(name: 'Peanut Butter', quantity: '20', price: 15.0, category: 'Fats', unit: 'g', protein: 4, calories: 120),
        ],
      ),
      RecipeSuggestion(
        id: 'b$day',
        name: 'Protein Pancakes with Berries',
        time: '7:00 AM',
        mealType: 'Breakfast',
        description: 'Delicious high-protein pancakes for muscle fuel',
        muscleBenefit: '40g protein for morning muscle recovery',
        totalProtein: 40,
        totalCalories: 520,
        preparation: '1. Mix protein powder with eggs\n2. Add oat flour\n3. Cook pancakes\n4. Top with berries and honey',
        ingredients: [
          IngredientItem(name: 'Whey Protein', quantity: '30', price: 60.0, category: 'Supplements', unit: 'g', protein: 24, calories: 120),
          IngredientItem(name: 'Eggs', quantity: '3', price: 18.0, category: 'Protein', unit: 'pc', protein: 18, calories: 210),
          IngredientItem(name: 'Oat Flour', quantity: '50', price: 20.0, category: 'Carbs', unit: 'g', protein: 5, calories: 180),
          IngredientItem(name: 'Mixed Berries', quantity: '80', price: 40.0, category: 'Fruits', unit: 'g', protein: 1, calories: 50),
        ],
      ),
    ];

    final lunchOptions = [
      RecipeSuggestion(
        id: 'l$day',
        name: 'Grilled Chicken with Brown Rice',
        time: '1:00 PM',
        mealType: 'Lunch',
        description: 'Lean protein with complex carbs for sustained energy',
        muscleBenefit: '55g protein for maximum muscle building',
        totalProtein: 55,
        totalCalories: 680,
        preparation: '1. Grill chicken breast\n2. Cook brown rice\n3. Steam broccoli\n4. Serve together',
        ingredients: [
          IngredientItem(name: 'Chicken Breast', quantity: '250', price: 125.0, category: 'Protein', unit: 'g', protein: 62, calories: 275),
          IngredientItem(name: 'Brown Rice', quantity: '150', price: 20.0, category: 'Carbs', unit: 'g', protein: 8, calories: 350),
          IngredientItem(name: 'Broccoli', quantity: '150', price: 30.0, category: 'Vegetables', unit: 'g', protein: 4, calories: 55),
        ],
      ),
      RecipeSuggestion(
        id: 'l$day',
        name: 'Tuna Steak with Sweet Potato',
        time: '1:00 PM',
        mealType: 'Lunch',
        description: 'Omega-3 rich fish with complex carbohydrates',
        muscleBenefit: '50g protein plus healthy fats for muscle',
        totalProtein: 50,
        totalCalories: 620,
        preparation: '1. Sear tuna steak\n2. Bake sweet potato\n3. Prepare salad\n4. Serve with lemon',
        ingredients: [
          IngredientItem(name: 'Tuna Steak', quantity: '200', price: 180.0, category: 'Protein', unit: 'g', protein: 50, calories: 240),
          IngredientItem(name: 'Sweet Potato', quantity: '250', price: 35.0, category: 'Carbs', unit: 'g', protein: 4, calories: 215),
          IngredientItem(name: 'Mixed Salad', quantity: '100', price: 25.0, category: 'Vegetables', unit: 'g', protein: 2, calories: 25),
        ],
      ),
    ];

    final snackOptions = [
      RecipeSuggestion(
        id: 's$day',
        name: 'Protein Shake with Banana',
        time: '4:00 PM - Pre Workout',
        mealType: 'Pre-Workout',
        description: 'Quick protein and carbs before training',
        muscleBenefit: '30g fast-absorbing protein for workout fuel',
        totalProtein: 30,
        totalCalories: 350,
        preparation: '1. Blend protein powder with milk\n2. Add banana\n3. Add oats\n4. Blend until smooth',
        ingredients: [
          IngredientItem(name: 'Whey Protein', quantity: '30', price: 60.0, category: 'Supplements', unit: 'g', protein: 24, calories: 120),
          IngredientItem(name: 'Milk', quantity: '300', price: 18.0, category: 'Dairy', unit: 'ml', protein: 9, calories: 180),
          IngredientItem(name: 'Banana', quantity: '1', price: 10.0, category: 'Fruits', unit: 'pc', protein: 1, calories: 105),
          IngredientItem(name: 'Oats', quantity: '30', price: 10.0, category: 'Carbs', unit: 'g', protein: 4, calories: 110),
        ],
      ),
      RecipeSuggestion(
        id: 's$day',
        name: 'Chicken Sandwich with Avocado',
        time: '4:00 PM - Pre Workout',
        mealType: 'Pre-Workout',
        description: 'Solid meal option before intense training',
        muscleBenefit: '35g protein with healthy fats',
        totalProtein: 35,
        totalCalories: 420,
        preparation: '1. Grill chicken breast\n2. Toast whole wheat bread\n3. Mash avocado\n4. Assemble sandwich',
        ingredients: [
          IngredientItem(name: 'Chicken Breast', quantity: '120', price: 60.0, category: 'Protein', unit: 'g', protein: 30, calories: 132),
          IngredientItem(name: 'Whole Wheat Bread', quantity: '2', price: 12.0, category: 'Carbs', unit: 'slices', protein: 6, calories: 160),
          IngredientItem(name: 'Avocado', quantity: '0.5', price: 30.0, category: 'Fats', unit: 'pc', protein: 1, calories: 120),
        ],
      ),
    ];

    final dinnerOptions = [
      RecipeSuggestion(
        id: 'd$day',
        name: 'Grilled Salmon with Quinoa',
        time: '8:00 PM - Post Workout',
        mealType: 'Dinner',
        description: 'Recovery meal with omega-3 and complete protein',
        muscleBenefit: '45g protein for overnight muscle recovery',
        totalProtein: 45,
        totalCalories: 580,
        preparation: '1. Grill salmon fillet\n2. Cook quinoa\n3. Roast asparagus\n4. Serve together',
        ingredients: [
          IngredientItem(name: 'Salmon Fillet', quantity: '200', price: 220.0, category: 'Protein', unit: 'g', protein: 40, calories: 360),
          IngredientItem(name: 'Quinoa', quantity: '100', price: 40.0, category: 'Carbs', unit: 'g', protein: 14, calories: 120),
          IngredientItem(name: 'Asparagus', quantity: '150', price: 50.0, category: 'Vegetables', unit: 'g', protein: 3, calories: 30),
        ],
      ),
      RecipeSuggestion(
        id: 'd$day',
        name: 'Lean Beef with Vegetables',
        time: '8:00 PM - Post Workout',
        mealType: 'Dinner',
        description: 'Iron-rich beef for muscle building and recovery',
        muscleBenefit: '52g protein with creatine for muscle gains',
        totalProtein: 52,
        totalCalories: 620,
        preparation: '1. Grill lean beef\n2. Roast mixed vegetables\n3. Cook brown rice\n4. Serve hot',
        ingredients: [
          IngredientItem(name: 'Lean Beef', quantity: '200', price: 180.0, category: 'Protein', unit: 'g', protein: 52, calories: 380),
          IngredientItem(name: 'Mixed Vegetables', quantity: '200', price: 40.0, category: 'Vegetables', unit: 'g', protein: 4, calories: 80),
          IngredientItem(name: 'Brown Rice', quantity: '100', price: 15.0, category: 'Carbs', unit: 'g', protein: 5, calories: 230),
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

  List<RecipeSuggestion> _getCuttingRecipes(int day) {
    final breakfastOptions = [
      RecipeSuggestion(
        id: 'b$day',
        name: 'Egg White Omelette with Veggies',
        time: '7:00 AM',
        mealType: 'Breakfast',
        description: 'Low-calorie, high-protein breakfast',
        muscleBenefit: '28g protein with minimal calories',
        totalProtein: 28,
        totalCalories: 220,
        preparation: '1. Beat 5 egg whites\n2. Add vegetables\n3. Cook in spray oil\n4. Serve hot',
        ingredients: [
          IngredientItem(name: 'Egg Whites', quantity: '5', price: 25.0, category: 'Protein', unit: 'pc', protein: 18, calories: 85),
          IngredientItem(name: 'Spinach', quantity: '100', price: 12.0, category: 'Vegetables', unit: 'g', protein: 3, calories: 23),
          IngredientItem(name: 'Mushrooms', quantity: '80', price: 20.0, category: 'Vegetables', unit: 'g', protein: 3, calories: 22),
          IngredientItem(name: 'Tomato', quantity: '1', price: 8.0, category: 'Vegetables', unit: 'pc', protein: 1, calories: 22),
        ],
      ),
      RecipeSuggestion(
        id: 'b$day',
        name: 'Greek Yogurt with Berries',
        time: '7:00 AM',
        mealType: 'Breakfast',
        description: 'High-protein, low-fat breakfast option',
        muscleBenefit: '25g protein for muscle maintenance',
        totalProtein: 25,
        totalCalories: 250,
        preparation: '1. Take Greek yogurt\n2. Add fresh berries\n3. Sprinkle chia seeds\n4. Mix well',
        ingredients: [
          IngredientItem(name: 'Greek Yogurt', quantity: '200', price: 50.0, category: 'Protein', unit: 'g', protein: 20, calories: 130),
          IngredientItem(name: 'Mixed Berries', quantity: '100', price: 50.0, category: 'Fruits', unit: 'g', protein: 1, calories: 57),
          IngredientItem(name: 'Chia Seeds', quantity: '10', price: 15.0, category: 'Fats', unit: 'g', protein: 2, calories: 49),
        ],
      ),
    ];

    final lunchOptions = [
      RecipeSuggestion(
        id: 'l$day',
        name: 'Grilled Chicken Salad',
        time: '1:00 PM',
        mealType: 'Lunch',
        description: 'Low-carb, high-protein lunch for cutting',
        muscleBenefit: '48g protein with minimal carbs',
        totalProtein: 48,
        totalCalories: 380,
        preparation: '1. Grill chicken breast\n2. Prepare large salad\n3. Add olive oil dressing\n4. Toss and serve',
        ingredients: [
          IngredientItem(name: 'Chicken Breast', quantity: '200', price: 100.0, category: 'Protein', unit: 'g', protein: 50, calories: 220),
          IngredientItem(name: 'Mixed Greens', quantity: '200', price: 40.0, category: 'Vegetables', unit: 'g', protein: 4, calories: 40),
          IngredientItem(name: 'Cherry Tomatoes', quantity: '100', price: 25.0, category: 'Vegetables', unit: 'g', protein: 1, calories: 18),
          IngredientItem(name: 'Olive Oil', quantity: '10', price: 10.0, category: 'Fats', unit: 'ml', protein: 0, calories: 90),
        ],
      ),
      RecipeSuggestion(
        id: 'l$day',
        name: 'Tuna with Cauliflower Rice',
        time: '1:00 PM',
        mealType: 'Lunch',
        description: 'Low-calorie, high-protein lunch option',
        muscleBenefit: '42g protein for lean muscle maintenance',
        totalProtein: 42,
        totalCalories: 320,
        preparation: '1. Grill fresh tuna\n2. Prepare cauliflower rice\n3. Add steamed broccoli\n4. Season and serve',
        ingredients: [
          IngredientItem(name: 'Tuna Steak', quantity: '180', price: 160.0, category: 'Protein', unit: 'g', protein: 45, calories: 216),
          IngredientItem(name: 'Cauliflower Rice', quantity: '200', price: 35.0, category: 'Vegetables', unit: 'g', protein: 4, calories: 50),
          IngredientItem(name: 'Broccoli', quantity: '100', price: 20.0, category: 'Vegetables', unit: 'g', protein: 3, calories: 34),
        ],
      ),
    ];

    final snackOptions = [
      RecipeSuggestion(
        id: 's$day',
        name: 'Protein Shake - Lean',
        time: '4:00 PM',
        mealType: 'Snack',
        description: 'Low-calorie protein boost',
        muscleBenefit: '25g protein with minimal sugar',
        totalProtein: 25,
        totalCalories: 150,
        preparation: '1. Mix protein powder with water\n2. Add ice\n3. Blend\n4. Drink immediately',
        ingredients: [
          IngredientItem(name: 'Isolate Protein', quantity: '30', price: 80.0, category: 'Supplements', unit: 'g', protein: 27, calories: 110),
          IngredientItem(name: 'Almond Milk', quantity: '200', price: 25.0, category: 'Dairy', unit: 'ml', protein: 2, calories: 40),
        ],
      ),
      RecipeSuggestion(
        id: 's$day',
        name: 'Boiled Eggs & Cucumber',
        time: '4:00 PM',
        mealType: 'Snack',
        description: 'Simple high-protein snack',
        muscleBenefit: '18g protein, zero processed foods',
        totalProtein: 18,
        totalCalories: 180,
        preparation: '1. Boil 3 eggs\n2. Slice cucumber\n3. Season with salt\n4. Eat together',
        ingredients: [
          IngredientItem(name: 'Eggs', quantity: '3', price: 18.0, category: 'Protein', unit: 'pc', protein: 18, calories: 210),
          IngredientItem(name: 'Cucumber', quantity: '1', price: 10.0, category: 'Vegetables', unit: 'pc', protein: 1, calories: 16),
        ],
      ),
    ];

    final dinnerOptions = [
      RecipeSuggestion(
        id: 'd$day',
        name: 'Grilled Fish with Vegetables',
        time: '8:00 PM',
        mealType: 'Dinner',
        description: 'Light, protein-rich dinner for cutting',
        muscleBenefit: '40g protein with omega-3 fats',
        totalProtein: 40,
        totalCalories: 350,
        preparation: '1. Grill white fish\n2. Steam vegetables\n3. Add lemon juice\n4. Serve hot',
        ingredients: [
          IngredientItem(name: 'White Fish', quantity: '200', price: 140.0, category: 'Protein', unit: 'g', protein: 42, calories: 220),
          IngredientItem(name: 'Zucchini', quantity: '150', price: 30.0, category: 'Vegetables', unit: 'g', protein: 2, calories: 25),
          IngredientItem(name: 'Bell Peppers', quantity: '100', price: 25.0, category: 'Vegetables', unit: 'g', protein: 1, calories: 31),
        ],
      ),
      RecipeSuggestion(
        id: 'd$day',
        name: 'Chicken Breast with Salad',
        time: '8:00 PM',
        mealType: 'Dinner',
        description: 'Classic cutting dinner - low carb, high protein',
        muscleBenefit: '50g protein for overnight recovery',
        totalProtein: 50,
        totalCalories: 340,
        preparation: '1. Bake chicken breast\n2. Make large mixed salad\n3. Add vinegar dressing\n4. Serve',
        ingredients: [
          IngredientItem(name: 'Chicken Breast', quantity: '220', price: 110.0, category: 'Protein', unit: 'g', protein: 55, calories: 242),
          IngredientItem(name: 'Mixed Salad', quantity: '200', price: 40.0, category: 'Vegetables', unit: 'g', protein: 3, calories: 50),
          IngredientItem(name: 'Balsamic Vinegar', quantity: '15', price: 10.0, category: 'Condiments', unit: 'ml', protein: 0, calories: 14),
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
    if (mealType.toLowerCase().contains('workout')) return const Color(0xFFFF6B35);
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
          SliverToBoxAdapter(child: _buildMacroOverview()),
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
            gradient: _selectedTier == PricingTier.bulking
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1A1A1A),
                      Color(0xFF2D2D2D),
                      Color(0xFF404040),
                    ],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFF6B35),
                      Color(0xFFF7931E),
                      Color(0xFFFDC830),
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
                          Icons.fitness_center,
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
                              _selectedTier == PricingTier.bulking 
                                  ? 'Muscle Builder - Bulking' 
                                  : 'Muscle Builder - Cutting',
                              style: const TextStyle(
                                fontFamily: 'HennyPenny',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              _selectedTier == PricingTier.bulking
                                  ? 'High protein & calories for mass gain'
                                  : 'High protein, low carbs for lean muscle',
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
                            _selectedTier == PricingTier.bulking
                                ? 'Premium protein • 150-180g daily protein • Muscle fuel'
                                : 'Lean protein • 130-150g daily protein • Fat loss focused',
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
                  _selectedTier = PricingTier.bulking;
                  _updatePlansForTier();
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: _selectedTier == PricingTier.bulking
                      ? const LinearGradient(
                          colors: [Color(0xFF1A1A1A), Color(0xFF404040)],
                        )
                      : null,
                  color: _selectedTier == PricingTier.bulking ? null : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _selectedTier == PricingTier.bulking
                        ? Colors.transparent
                        : Colors.grey.shade300,
                    width: 2,
                  ),
                  boxShadow: _selectedTier == PricingTier.bulking
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: _selectedTier == PricingTier.bulking
                          ? Colors.white
                          : Colors.black87,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bulking',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _selectedTier == PricingTier.bulking
                            ? Colors.white
                            : const Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      'Gain Mass',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 11,
                        color: _selectedTier == PricingTier.bulking
                            ? Colors.white.withOpacity(0.9)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _selectedTier == PricingTier.bulking
                            ? Colors.white.withOpacity(0.2)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '2500+ cal/day',
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _selectedTier == PricingTier.bulking
                              ? Colors.white
                              : Colors.black87,
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
                  _selectedTier = PricingTier.cutting;
                  _updatePlansForTier();
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: _selectedTier == PricingTier.cutting
                      ? const LinearGradient(
                          colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
                        )
                      : null,
                  color: _selectedTier == PricingTier.cutting ? null : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _selectedTier == PricingTier.cutting
                        ? Colors.transparent
                        : Colors.grey.shade300,
                    width: 2,
                  ),
                  boxShadow: _selectedTier == PricingTier.cutting
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
                      Icons.trending_down,
                      color: _selectedTier == PricingTier.cutting
                          ? Colors.white
                          : Colors.orange.shade700,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Cutting',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _selectedTier == PricingTier.cutting
                            ? Colors.white
                            : const Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      'Lean & Shred',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 11,
                        color: _selectedTier == PricingTier.cutting
                            ? Colors.white.withOpacity(0.9)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _selectedTier == PricingTier.cutting
                            ? Colors.white.withOpacity(0.2)
                            : Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '1500-1800 cal/day',
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _selectedTier == PricingTier.cutting
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

  Widget _buildMacroOverview() {
    final dailyPlan = _dailyPlans[_selectedDay - 1];
    
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _selectedTier == PricingTier.bulking
              ? [Colors.grey.shade900, Colors.grey.shade800]
              : [Colors.orange.shade50, Colors.amber.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _selectedTier == PricingTier.bulking
              ? Colors.grey.shade700
              : Colors.orange.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: (_selectedTier == PricingTier.bulking 
                ? Colors.black 
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
                  Icons.fitness_center,
                  color: _selectedTier == PricingTier.bulking
                      ? Colors.black
                      : Colors.orange.shade700,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Nutrition Stats',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _selectedTier == PricingTier.bulking
                            ? Colors.white
                            : const Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      'Optimize your muscle gains',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 11,
                        color: _selectedTier == PricingTier.bulking
                            ? Colors.white70
                            : const Color(0xFF6B7280),
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _MacroCard(
                      label: 'Protein',
                      value: '${dailyPlan.dailyProtein}g',
                      icon: Icons.egg,
                      color: Colors.red.shade400,
                    ),
                    _MacroCard(
                      label: 'Calories',
                      value: '${dailyPlan.dailyCalories}',
                      icon: Icons.local_fire_department,
                      color: Colors.orange.shade600,
                    ),
                    _MacroCard(
                      label: 'Cost',
                      value: '₹${dailyPlan.dailyPrice.toStringAsFixed(0)}',
                      icon: Icons.currency_rupee,
                      color: Colors.green.shade600,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _selectedTier == PricingTier.bulking
                        ? Colors.grey.shade900
                        : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 18,
                        color: _selectedTier == PricingTier.bulking
                            ? Colors.white
                            : Colors.orange.shade700,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _selectedTier == PricingTier.bulking
                              ? 'High protein & calories for maximum muscle growth'
                              : 'High protein, controlled calories for lean muscle',
                          style: TextStyle(
                            fontFamily: 'HennyPenny',
                            fontSize: 11,
                            color: _selectedTier == PricingTier.bulking
                                ? Colors.white
                                : const Color(0xFF374151),
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
        color: _selectedTier == PricingTier.bulking
            ? Colors.grey.shade900
            : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _selectedTier == PricingTier.bulking
              ? Colors.grey.shade700
              : Colors.orange.shade200,
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
              Icons.restaurant_menu,
              color: _selectedTier == PricingTier.bulking
                  ? Colors.black
                  : Colors.orange.shade700,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Muscle-Building Meal Plans',
                  style: TextStyle(
                    fontFamily: 'HennyPenny',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: _selectedTier == PricingTier.bulking
                        ? Colors.white
                        : Colors.orange.shade900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Pre & post workout nutrition included',
                  style: TextStyle(
                    fontFamily: 'HennyPenny',
                    fontSize: 10,
                    color: _selectedTier == PricingTier.bulking
                        ? Colors.white70
                        : const Color(0xFF6B7280),
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
                '${_dailyPlans[_selectedDay - 1].dailyProtein}g protein • ${_dailyPlans[_selectedDay - 1].dailyCalories} cal',
                style: TextStyle(
                  fontFamily: 'HennyPenny',
                  fontSize: 12,
                  color: _selectedTier == PricingTier.bulking
                      ? Colors.black87
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
                        ? (_selectedTier == PricingTier.bulking
                            ? const LinearGradient(
                                colors: [Color(0xFF1A1A1A), Color(0xFF404040)],
                              )
                            : const LinearGradient(
                                colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
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
                              color: (_selectedTier == PricingTier.bulking
                                  ? Colors.black
                                  : Colors.orange).withOpacity(0.3),
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
                'Meal Plan',
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
                  color: _selectedTier == PricingTier.bulking
                      ? Colors.grey.shade900
                      : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.restaurant,
                      size: 14,
                      color: _selectedTier == PricingTier.bulking
                          ? Colors.white
                          : Colors.orange.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$_totalIngredients items',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _selectedTier == PricingTier.bulking
                            ? Colors.white
                            : Colors.orange.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...recipes.map((recipe) => _MuscleRecipeCard(
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
            color: (_selectedTier == PricingTier.bulking
                ? Colors.black
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
                colors: _selectedTier == PricingTier.bulking
                    ? [Colors.grey.shade900, Colors.grey.shade700]
                    : [Colors.orange.shade600, Colors.orange.shade400],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.fitness_center, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedTier == PricingTier.bulking
                            ? 'Start Bulking Journey'
                            : 'Start Cutting Journey',
                        style: const TextStyle(
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
    // Similar implementation to holistic_wellness.dart
  }

  void _subscribe() {
    // Similar implementation to holistic_wellness.dart
  }
}

// Macro Card Widget
class _MacroCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MacroCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'HennyPenny',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'HennyPenny',
            fontSize: 10,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}

// Muscle Recipe Card Widget
class _MuscleRecipeCard extends StatelessWidget {
  final RecipeSuggestion recipe;
  final Color mealTypeColor;
  final VoidCallback onToggle;
  final VoidCallback onCustomize;

  const _MuscleRecipeCard({
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
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.egg, size: 10, color: Colors.red.shade700),
                                const SizedBox(width: 4),
                                Text(
                                  '${recipe.currentProtein}g',
                                  style: TextStyle(
                                    fontFamily: 'HennyPenny',
                                    fontSize: 9,
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.local_fire_department, size: 10, color: Colors.orange.shade700),
                                const SizedBox(width: 4),
                                Text(
                                  '${recipe.currentCalories}cal',
                                  style: TextStyle(
                                    fontFamily: 'HennyPenny',
                                    fontSize: 9,
                                    color: Colors.orange.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.fitness_center, size: 16, color: Colors.green.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        recipe.muscleBenefit,
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