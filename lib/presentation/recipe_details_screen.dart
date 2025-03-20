import 'package:flutter/material.dart';
import 'package:flutter_project_iti/constant/colors.dart';
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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset('assets/back.png'),
          color: MyColors.pink,
        ),
        title: Text(recipe.name),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/love.png',
              color: isFavorite ? MyColors.pink : Colors.blueGrey,
            ),
            onPressed: _toggleFavorite,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                recipe.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: MyColors.pink,
                ),
              ),
            ),
            Text(
                'Cuisine: ${recipe.cuisine} | Difficulty: ${recipe.difficulty}'),
            const SizedBox(height: 8),
            Text('Rating: ${recipe.rating} (${recipe.reviewCount} reviews)'),
            const Divider(thickness: 1, height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ingredients',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: MyColors.pink),
                ),
              ),
            ),
            for (final ing in recipe.ingredients)
              ListTile(
                leading: const Text(
                  '.',
                  style: TextStyle(color: MyColors.pink, fontSize: 35),
                ),
                title: Text(ing),
              ),
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
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
                  backgroundColor: MyColors.pink,
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
