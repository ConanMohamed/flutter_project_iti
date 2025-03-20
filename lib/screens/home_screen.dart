// home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_project_iti/api/api_service.dart';
// import 'package:flutter_project_iti/constant/colors.dart';
import 'package:flutter_project_iti/models/recipe.dart';
import 'package:flutter_project_iti/presentation/recipe_details.dart';

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

  // If your second link is empty, we’ll fetch all recipes once
  // and filter them locally by mealType:
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
      _recipes = result; // show all by default
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
        // Filter locally based on each recipe’s mealType array
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
        leading: Image.asset('assets/Vector (1).png'),
        actions: [Image.asset('assets/Icon-Header.png')],
        centerTitle: true,
        title: Text(
          _selectedMealType,
          style: TextStyle(color: Colors.pinkAccent),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Horizontal meal-type tabs
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
                      color: isSelected ? Colors.pinkAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      type,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
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
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                      child: recipe.image.isNotEmpty
                                          ? Image.network(
                                              recipe.image,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            )
                                          : Container(
                                              color: Colors.grey[200],
                                              child: const Icon(Icons.fastfood),
                                            ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      recipe.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      recipe.mealType.join(", "),
                                      style: const TextStyle(fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
