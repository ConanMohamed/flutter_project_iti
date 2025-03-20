// api_service.dart
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_project_iti/models/recipe.dart';

class ApiService {
  late Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://dummyjson.com/',
        connectTimeout: const Duration(seconds: 5), // 5s timeout
      ),
    );

    // Interceptor to log requests/responses/errors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          log('REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log('RESPONSE[${response.statusCode}] => DATA: ${response.data.toString().substring(0, 80)}...');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          log('ERROR[${e.response?.statusCode}] => MESSAGE: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  /// Fetch all recipes
  Future<List<Recipe>> fetchAllRecipes() async {
    try {
      final response = await _dio.get('recipes');
      final data = response.data['recipes'] as List;
      return data.map((e) => Recipe.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch recipes by meal type (e.g. 'breakfast', 'lunch', etc.)
  /// NOTE: Currently returns an empty array if your second link has no data.
  Future<List<Recipe>> fetchRecipesByMealType(String type) async {
    try {
      final response = await _dio.get('recipes/meal-type/$type');
      final data = response.data['recipes'] as List;
      return data.map((e) => Recipe.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
