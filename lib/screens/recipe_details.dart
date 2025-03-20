// recipe_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_project_iti/helpers/dp_helper.dart';
import 'package:flutter_project_iti/models/recipe.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  final dbHelper = DBHelper();
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    final fav = await dbHelper.isFavorite(widget.recipe.id);
    setState(() => isFavorite = fav);
  }

  Future<void> _toggleFavorite() async {
    if (isFavorite) {
      await dbHelper.removeFavorite(widget.recipe.id);
    } else {
      await dbHelper.insertFavorite(widget.recipe);
    }
    await _checkFavorite();
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        backgroundColor: Colors.pinkAccent,
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFavorite,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Recipe image
            if (recipe.image.isNotEmpty)
              Image.network(
                recipe.image,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              )
            else
              Container(
                width: double.infinity,
                height: 250,
                color: Colors.grey[300],
                child: const Icon(Icons.fastfood, size: 50),
              ),
            const SizedBox(height: 16),
            // Basic info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                recipe.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                ),
              ),
            ),
            Text('Cuisine: ${recipe.cuisine} | Difficulty: ${recipe.difficulty}'),
            const SizedBox(height: 8),
            Text('Rating: ${recipe.rating} (${recipe.reviewCount} reviews)'),
            const Divider(thickness: 1, height: 24),
            // Ingredients
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ingredients',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            for (final ing in recipe.ingredients)
              ListTile(
                leading: const Icon(Icons.check),
                title: Text(ing),
              ),
            // Instructions
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Instructions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            for (int i = 0; i < recipe.instructions.length; i++)
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.pinkAccent,
                  child: Text('${i + 1}'),
                ),
                title: Text(recipe.instructions[i]),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
