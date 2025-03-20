import 'package:flutter/material.dart';
import 'package:flutter_project_iti/api/api_service.dart';
import 'package:flutter_project_iti/constant/colors.dart';
import 'package:flutter_project_iti/models/recipe.dart';
import 'package:flutter_project_iti/presentation/recipe_details_screen.dart';
import 'package:flutter_project_iti/presentation/widgets/recipe_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  List<Recipe> _recipes = [];
  bool _isLoading = false;
  String _selectedMealType = 'All';

  List<Recipe> _allRecipes = [];

  final List<String> _mealTypes = [
    'All',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
    'Dessert',
  ];

  @override
  void initState() {
    super.initState();
    _fetchAllRecipes();
  }

  Future<void> _fetchAllRecipes() async {
    setState(() => _isLoading = true);
    try {
      final result = await _apiService.fetchAllRecipes();
      _allRecipes = result;
      _recipes = result;
    } catch (e) {
      debugPrint('Error fetching recipes: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterByMealType(String mealType) {
    setState(() {
      _selectedMealType = mealType;
      if (mealType == 'All') {
        _recipes = _allRecipes;
      } else {
        _recipes = _allRecipes
            .where((r) => r.mealType
                .map((m) => m.toLowerCase())
                .contains(mealType.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/back.png'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Image.asset('assets/actions.png'),
          ),
        ],
        centerTitle: true,
        title: Text(
          _selectedMealType,
          style: TextStyle(color: MyColors.pink),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Horizontal filter buttons
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _mealTypes.length,
              itemBuilder: (context, index) {
                final type = _mealTypes[index];
                final isSelected = (type == _selectedMealType);
                return GestureDetector(
                  onTap: () => _filterByMealType(type),
                  child: Container(
                    alignment: Alignment.center,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? MyColors.pink : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      type,
                      style: TextStyle(
                        color: isSelected ? Colors.white : MyColors.pink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Recipes grid
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _recipes.isEmpty
                    ? const Center(child: Text('No recipes found.'))
                    : GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: _recipes.length,
                        itemBuilder: (context, index) {
                          final recipe = _recipes[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      RecipeDetailPage(recipe: recipe),
                                ),
                              );
                            },
                            child: RecipeCard(recipe:recipe)
                          );
                        },
                      ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: MyColors.pink,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.home_outlined, color: Colors.white),
              onPressed: () {
              },
            ),
            IconButton(
              icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
              onPressed: () {
              },
            ),
            IconButton(
              icon: const Icon(Icons.layers_outlined, color: Colors.white),
              onPressed: () {
              },
            ),
            IconButton(
              icon: const Icon(Icons.person_outline, color: Colors.white),
              onPressed: () {
              },
            ),
          ],
        ),
      ),
    );
  }
}
