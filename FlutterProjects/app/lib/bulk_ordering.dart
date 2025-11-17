import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// 🏷️ Models
class EventType {
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  const EventType({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class MealCategory {
  final String name;
  final String description;
  final IconData icon;
  bool isSelected;

  MealCategory({
    required this.name,
    required this.description,
    required this.icon,
    this.isSelected = false,
  });
}

class MenuItem {
  final String name;
  final String category;
  final double pricePerPerson;
  final String description;
  bool isSelected;
  int servings;

  MenuItem({
    required this.name,
    required this.category,
    required this.pricePerPerson,
    required this.description,
    this.isSelected = false,
    this.servings = 0,
  });
}

const eventTypes = [
  EventType(
    name: 'Marriage/Wedding',
    description: 'Wedding ceremonies & receptions',
    icon: Icons.celebration,
    color: Color(0xFFE91E63),
  ),
  EventType(
    name: 'College Event',
    description: 'Fests, seminars & gatherings',
    icon: Icons.school,
    color: Color(0xFF2196F3),
  ),
  EventType(
    name: 'Corporate Event',
    description: 'Meetings, conferences & parties',
    icon: Icons.business,
    color: Color(0xFF673AB7),
  ),
  EventType(
    name: 'Birthday Party',
    description: 'Birthday celebrations',
    icon: Icons.cake,
    color: Color(0xFFFF9800),
  ),
  EventType(
    name: 'Religious Event',
    description: 'Prayers, festivals & ceremonies',
    icon: Icons.temple_hindu,
    color: Color(0xFF4CAF50),
  ),
  EventType(
    name: 'Other Event',
    description: 'Custom events & gatherings',
    icon: Icons.event,
    color: Color(0xFF9C27B0),
  ),
];

class BulkOrderingPage extends StatefulWidget {
  const BulkOrderingPage({super.key});

  @override
  State<BulkOrderingPage> createState() => _BulkOrderingPageState();
}

class _BulkOrderingPageState extends State<BulkOrderingPage> {
  int _currentStep = 0;
  String? _selectedEventType;
  int _numberOfPeople = 50;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _deliveryAddress = '';
  String _contactPerson = '';
  String _contactNumber = '';
  String _specialRequirements = '';

  final List<MealCategory> _mealCategories = [
    MealCategory(name: 'Breakfast', description: 'Morning meals', icon: Icons.free_breakfast),
    MealCategory(name: 'Lunch', description: 'Afternoon meals', icon: Icons.lunch_dining),
    MealCategory(name: 'Snacks', description: 'Tea time snacks', icon: Icons.local_cafe),
    MealCategory(name: 'Dinner', description: 'Evening meals', icon: Icons.dinner_dining),
  ];

  final Map<String, List<MenuItem>> _menuItems = {
    'Breakfast': [
      MenuItem(name: 'Idli Sambar', category: 'Breakfast', pricePerPerson: 35.0, description: 'Soft idlis with sambar & chutney'),
      MenuItem(name: 'Masala Dosa', category: 'Breakfast', pricePerPerson: 45.0, description: 'Crispy dosa with potato filling'),
      MenuItem(name: 'Poha', category: 'Breakfast', pricePerPerson: 30.0, description: 'Flattened rice with vegetables'),
      MenuItem(name: 'Paratha with Curd', category: 'Breakfast', pricePerPerson: 40.0, description: 'Stuffed parathas with curd'),
      MenuItem(name: 'Puri Bhaji', category: 'Breakfast', pricePerPerson: 38.0, description: 'Fried puris with potato curry'),
    ],
    'Lunch': [
      MenuItem(name: 'Veg Thali', category: 'Lunch', pricePerPerson: 80.0, description: 'Rice, dal, 2 sabzi, roti, salad, sweet'),
      MenuItem(name: 'Non-Veg Thali', category: 'Lunch', pricePerPerson: 120.0, description: 'Rice, dal, chicken/mutton curry, roti'),
      MenuItem(name: 'Veg Biryani', category: 'Lunch', pricePerPerson: 90.0, description: 'Aromatic vegetable biryani with raita'),
      MenuItem(name: 'Chicken Biryani', category: 'Lunch', pricePerPerson: 140.0, description: 'Hyderabadi chicken biryani with raita'),
      MenuItem(name: 'Paneer Butter Masala Meal', category: 'Lunch', pricePerPerson: 100.0, description: 'Paneer curry with rice & roti'),
      MenuItem(name: 'Dal Khichdi Meal', category: 'Lunch', pricePerPerson: 70.0, description: 'Comfort khichdi with curd & papad'),
    ],
    'Snacks': [
      MenuItem(name: 'Samosa', category: 'Snacks', pricePerPerson: 20.0, description: '2 pieces with chutney'),
      MenuItem(name: 'Pakora Platter', category: 'Snacks', pricePerPerson: 25.0, description: 'Mixed vegetable pakoras'),
      MenuItem(name: 'Sandwich', category: 'Snacks', pricePerPerson: 30.0, description: 'Veg sandwich with sauce'),
      MenuItem(name: 'Tea/Coffee', category: 'Snacks', pricePerPerson: 10.0, description: 'Hot beverage'),
      MenuItem(name: 'Cake', category: 'Snacks', pricePerPerson: 40.0, description: 'Fresh cake slice'),
      MenuItem(name: 'Spring Rolls', category: 'Snacks', pricePerPerson: 35.0, description: 'Crispy vegetable spring rolls'),
    ],
    'Dinner': [
      MenuItem(name: 'Veg Thali', category: 'Dinner', pricePerPerson: 85.0, description: 'Rice, dal, 2 sabzi, roti, salad, sweet'),
      MenuItem(name: 'Non-Veg Thali', category: 'Dinner', pricePerPerson: 130.0, description: 'Rice, dal, chicken/mutton curry, roti'),
      MenuItem(name: 'Paneer Tikka Meal', category: 'Dinner', pricePerPerson: 110.0, description: 'Paneer tikka with dal & roti'),
      MenuItem(name: 'Mutton Biryani', category: 'Dinner', pricePerPerson: 160.0, description: 'Premium mutton biryani with raita'),
      MenuItem(name: 'Chole Bhature', category: 'Dinner', pricePerPerson: 75.0, description: 'Spicy chickpeas with fried bread'),
    ],
  };

  double get _totalCost {
    double total = 0;
    for (var category in _mealCategories) {
      if (category.isSelected) {
        final items = _menuItems[category.name] ?? [];
        for (var item in items) {
          if (item.isSelected) {
            total += item.pricePerPerson * _numberOfPeople;
          }
        }
      }
    }
    return total;
  }

  int get _selectedItemsCount {
    int count = 0;
    for (var category in _mealCategories) {
      if (category.isSelected) {
        final items = _menuItems[category.name] ?? [];
        count += items.where((item) => item.isSelected).length;
      }
    }
    return count;
  }

  bool get _canProceedToNextStep {
    switch (_currentStep) {
      case 0:
        return _selectedEventType != null;
      case 1:
        return _numberOfPeople >= 20 && _selectedDate != null;
      case 2:
        return _mealCategories.any((cat) => cat.isSelected) &&
            _menuItems.values.any((items) => items.any((item) => item.isSelected));
      case 3:
        return _deliveryAddress.isNotEmpty &&
            _contactPerson.isNotEmpty &&
            _contactNumber.length == 10;
      default:
        return false;
    }
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final minDate = now.add(const Duration(days: 2));
    final maxDate = now.add(const Duration(days: 90));

    final picked = await showDatePicker(
      context: context,
      initialDate: minDate,
      firstDate: minDate,
      lastDate: maxDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.orange.shade600,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.orange.shade600,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _submitOrder() {
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
                  colors: [Colors.orange.shade600, Colors.orange.shade400],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 48),
            ),
            const SizedBox(height: 20),
            const Text(
              'Order Received!',
              style: TextStyle(
                fontFamily: 'HennyPenny',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Our team will contact you within 2 hours to confirm the order details',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'HennyPenny',
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Event:',
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      Text(
                        _selectedEventType ?? '',
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'People:',
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      Text(
                        '$_numberOfPeople',
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Date:',
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      Text(
                        _selectedDate != null
                            ? DateFormat('dd MMM yyyy').format(_selectedDate!)
                            : '',
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade900,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Text(
                    '₹${_totalCost.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontFamily: 'HennyPenny',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
                    ),
                  ),
                  const Text(
                    'Estimated Total',
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
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade600,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Done',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Bulk Ordering',
          style: TextStyle(
            fontFamily: 'HennyPenny',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange.shade600,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _buildCurrentStep(),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStep(0, 'Event', Icons.event),
          _buildStepConnector(0),
          _buildStep(1, 'Details', Icons.info),
          _buildStepConnector(1),
          _buildStep(2, 'Menu', Icons.restaurant_menu),
          _buildStepConnector(2),
          _buildStep(3, 'Confirm', Icons.check_circle),
        ],
      ),
    );
  }

  Widget _buildStep(int index, String label, IconData icon) {
    final isActive = _currentStep >= index;
    final isCurrent = _currentStep == index;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: isActive
                  ? LinearGradient(
                      colors: [Colors.orange.shade600, Colors.orange.shade400],
                    )
                  : null,
              color: isActive ? null : Colors.grey.shade300,
              shape: BoxShape.circle,
              border: isCurrent
                  ? Border.all(color: Colors.orange.shade700, width: 3)
                  : null,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'HennyPenny',
              fontSize: 10,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              color: isActive ? Colors.orange.shade700 : const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector(int index) {
    final isActive = _currentStep > index;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 30),
        color: isActive ? Colors.orange.shade600 : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildEventTypeSelection();
      case 1:
        return _buildEventDetails();
      case 2:
        return _buildMenuSelection();
      case 3:
        return _buildConfirmation();
      default:
        return const SizedBox();
    }
  }

  Widget _buildEventTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Event Type',
          style: TextStyle(
            fontFamily: 'HennyPenny',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Choose the type of event you\'re organizing',
          style: TextStyle(
            fontFamily: 'HennyPenny',
            fontSize: 13,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 20),
        ...eventTypes.map((event) => _buildEventTypeCard(event)),
      ],
    );
  }

  Widget _buildEventTypeCard(EventType event) {
    final isSelected = _selectedEventType == event.name;

    return GestureDetector(
      onTap: () => setState(() => _selectedEventType = event.name),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? event.color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? event.color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: event.color.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: event.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(event.icon, color: event.color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: TextStyle(
                      fontFamily: 'HennyPenny',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? event.color : const Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    event.description,
                    style: const TextStyle(
                      fontFamily: 'HennyPenny',
                      fontSize: 11,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: event.color, size: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildEventDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event Details',
          style: TextStyle(
            fontFamily: 'HennyPenny',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Provide details about your event',
          style: TextStyle(
            fontFamily: 'HennyPenny',
            fontSize: 13,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 20),
        
        // Number of People
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.people, color: Colors.orange.shade600, size: 24),
                  const SizedBox(width: 12),
                  const Text(
                    'Number of People',
                    style: TextStyle(
                      fontFamily: 'HennyPenny',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      if (_numberOfPeople > 20) {
                        setState(() => _numberOfPeople -= 10);
                      }
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.remove, color: Colors.orange.shade700),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '$_numberOfPeople',
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                      ),
                      const Text(
                        'people',
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      if (_numberOfPeople < 1000) {
                        setState(() => _numberOfPeople += 10);
                      }
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.add, color: Colors.orange.shade700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700, size: 18),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Minimum 20 people required for bulk orders',
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
        const SizedBox(height: 16),

        // Date Selection
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _selectedDate != null ? Colors.orange.shade300 : Colors.grey.shade300,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.calendar_today, color: Colors.orange.shade700, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Event Date',
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedDate != null
                            ? DateFormat('EEEE, dd MMMM yyyy').format(_selectedDate!)
                            : 'Select date (min. 2 days in advance)',
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _selectedDate != null
                              ? const Color(0xFF1F2937)
                              : const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 18),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Time Selection
        GestureDetector(
          onTap: _selectTime,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _selectedTime != null ? Colors.orange.shade300 : Colors.grey.shade300,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.access_time, color: Colors.orange.shade700, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Delivery Time',
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedTime != null
                            ? _selectedTime!.format(context)
                            : 'Select preferred time',
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _selectedTime != null
                              ? const Color(0xFF1F2937)
                              : const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 18),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Important Notice
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade50, Colors.amber.shade50],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.orange.shade200),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info, color: Colors.orange.shade700, size: 24),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Important Notice',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Orders must be placed at least 2 days in advance. Our team will contact you to confirm the final details.',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Menu Selection',
          style: TextStyle(
            fontFamily: 'HennyPenny',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select meal categories and items',
          style: TextStyle(
            fontFamily: 'HennyPenny',
            fontSize: 13,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 20),

        // Meal Categories
        const Text(
          'Meal Categories',
          style: TextStyle(
            fontFamily: 'HennyPenny',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _mealCategories.map((category) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  category.isSelected = !category.isSelected;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: category.isSelected
                      ? LinearGradient(
                          colors: [Colors.orange.shade600, Colors.orange.shade400],
                        )
                      : null,
                  color: category.isSelected ? null : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: category.isSelected ? Colors.transparent : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      category.icon,
                      color: category.isSelected ? Colors.white : Colors.orange.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      category.name,
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: category.isSelected ? Colors.white : const Color(0xFF1F2937),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        // Menu Items
        ..._mealCategories.where((cat) => cat.isSelected).map((category) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${category.name} Menu',
                style: const TextStyle(
                  fontFamily: 'HennyPenny',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 12),
              ...(_menuItems[category.name] ?? []).map((item) {
                return _buildMenuItem(item);
              }),
              const SizedBox(height: 20),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildMenuItem(MenuItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: item.isSelected ? Colors.orange.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.isSelected ? Colors.orange.shade300 : Colors.grey.shade300,
        ),
      ),
      child: CheckboxListTile(
        value: item.isSelected,
        onChanged: (val) {
          setState(() {
            item.isSelected = val ?? false;
          });
        },
        activeColor: Colors.orange.shade600,
        title: Text(
          item.name,
          style: const TextStyle(
            fontFamily: 'HennyPenny',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              item.description,
              style: const TextStyle(
                fontFamily: 'HennyPenny',
                fontSize: 11,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '₹${item.pricePerPerson.toStringAsFixed(0)}/person',
                    style: TextStyle(
                      fontFamily: 'HennyPenny',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (item.isSelected)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Total: ₹${(item.pricePerPerson * _numberOfPeople).toStringAsFixed(0)}',
                      style: TextStyle(
                        fontFamily: 'HennyPenny',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildConfirmation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Confirmation',
          style: TextStyle(
            fontFamily: 'HennyPenny',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Provide delivery and contact details',
          style: TextStyle(
            fontFamily: 'HennyPenny',
            fontSize: 13,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 20),

        // Contact Person
        TextField(
          onChanged: (value) => setState(() => _contactPerson = value),
          style: const TextStyle(fontFamily: 'HennyPenny'),
          decoration: InputDecoration(
            labelText: 'Contact Person Name',
            labelStyle: const TextStyle(fontFamily: 'HennyPenny'),
            prefixIcon: const Icon(Icons.person),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.orange.shade600, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Contact Number
        TextField(
          onChanged: (value) => setState(() => _contactNumber = value),
          keyboardType: TextInputType.phone,
          maxLength: 10,
          style: const TextStyle(fontFamily: 'HennyPenny'),
          decoration: InputDecoration(
            labelText: 'Contact Number',
            labelStyle: const TextStyle(fontFamily: 'HennyPenny'),
            prefixIcon: const Icon(Icons.phone),
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.orange.shade600, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Delivery Address
        TextField(
          onChanged: (value) => setState(() => _deliveryAddress = value),
          maxLines: 3,
          style: const TextStyle(fontFamily: 'HennyPenny'),
          decoration: InputDecoration(
            labelText: 'Delivery Address',
            labelStyle: const TextStyle(fontFamily: 'HennyPenny'),
            prefixIcon: const Icon(Icons.location_on),
            alignLabelWithHint: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.orange.shade600, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Special Requirements
        TextField(
          onChanged: (value) => setState(() => _specialRequirements = value),
          maxLines: 3,
          style: const TextStyle(fontFamily: 'HennyPenny'),
          decoration: InputDecoration(
            labelText: 'Special Requirements (Optional)',
            labelStyle: const TextStyle(fontFamily: 'HennyPenny'),
            prefixIcon: const Icon(Icons.notes),
            alignLabelWithHint: true,
            hintText: 'Any specific requirements or preferences...',
            hintStyle: const TextStyle(fontFamily: 'HennyPenny', fontSize: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.orange.shade600, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Order Summary
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade50, Colors.amber.shade50],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.orange.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Order Summary',
                style: TextStyle(
                  fontFamily: 'HennyPenny',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 16),
              _buildSummaryRow('Event Type', _selectedEventType ?? ''),
              _buildSummaryRow('Number of People', '$_numberOfPeople'),
              _buildSummaryRow(
                'Event Date',
                _selectedDate != null ? DateFormat('dd MMM yyyy').format(_selectedDate!) : '',
              ),
              _buildSummaryRow(
                'Delivery Time',
                _selectedTime != null ? _selectedTime!.format(context) : '',
              ),
              _buildSummaryRow('Selected Items', '$_selectedItemsCount items'),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Estimated Total',
                    style: TextStyle(
                      fontFamily: 'HennyPenny',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  Text(
                    '₹${_totalCost.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontFamily: 'HennyPenny',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700, size: 18),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Final price will be confirmed after discussion with our team',
                        style: TextStyle(
                          fontFamily: 'HennyPenny',
                          fontSize: 10,
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
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'HennyPenny',
              fontSize: 13,
              color: Color(0xFF6B7280),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'HennyPenny',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
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
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _currentStep--),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.orange.shade600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Back',
                  style: TextStyle(
                    fontFamily: 'HennyPenny',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade600,
                  ),
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _canProceedToNextStep
                  ? () {
                      if (_currentStep < 3) {
                        setState(() => _currentStep++);
                      } else {
                        _submitOrder();
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade600,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentStep < 3 ? 'Continue' : 'Submit Order',
                    style: const TextStyle(
                      fontFamily: 'HennyPenny',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _currentStep < 3 ? Icons.arrow_forward : Icons.check,
                    color: Colors.white,
                    size: 20,
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