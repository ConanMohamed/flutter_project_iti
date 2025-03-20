import 'package:flutter/material.dart';
import 'package:flutter_project_iti/constant/colors.dart';
import 'package:flutter_project_iti/models/recipe.dart';

class RecipeCard extends StatefulWidget {
  const RecipeCard({super.key, required this.recipe});
  final Recipe recipe;

  @override
  RecipeCardState createState() => RecipeCardState();
}

class RecipeCardState extends State<RecipeCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with Floating Favorite Button
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.network(
                  widget.recipe.image, // Replace with actual image URL
                  width: double.infinity,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor:isFavorite? MyColors.pink:const Color.fromARGB(255, 245, 175, 198),
                    radius: 20,
                    child: Image.asset(
                      'assets/love.png',
                      color: isFavorite ? Colors.white: MyColors.pink,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Recipe Details
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.recipe.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              widget.recipe.mealType.join(', '),
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          SizedBox(height: 8),
          // Rating and Time Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 20),
                SizedBox(width: 4),
                Text('5'),
                SizedBox(width: 16),
                Icon(Icons.access_time, color: Colors.grey, size: 20),
                SizedBox(width: 4),
                Text('20min'),
              ],
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
