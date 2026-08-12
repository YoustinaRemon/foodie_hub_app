import 'package:cloud_firestore/cloud_firestore.dart';

class CustomIngredient {
  final String name;
  final String measure;

  CustomIngredient({required this.name, required this.measure});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'measure': measure,
    };
  }

  factory CustomIngredient.fromJson(Map<String, dynamic> json) {
    return CustomIngredient(
      name: json['name'] as String? ?? '',
      measure: json['measure'] as String? ?? '',
    );
  }
}

class CustomRecipeModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String? imageUrl;
  final String category;
  final int preparationTime;
  final int servings;
  final List<CustomIngredient> ingredients;
  final List<String> instructions;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CustomRecipeModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.category,
    required this.preparationTime,
    required this.servings,
    required this.ingredients,
    required this.instructions,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'preparationTime': preparationTime,
      'servings': servings,
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
      'instructions': instructions,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory CustomRecipeModel.fromJson(Map<String, dynamic> json) {
    final ingredientsList = json['ingredients'] as List<dynamic>? ?? [];
    final instructionsList = json['instructions'] as List<dynamic>? ?? [];

    return CustomRecipeModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] as String? ?? '',
      preparationTime: json['preparationTime'] as int? ?? 0,
      servings: json['servings'] as int? ?? 0,
      ingredients: ingredientsList.map((e) => CustomIngredient.fromJson(e as Map<String, dynamic>)).toList(),
      instructions: instructionsList.map((e) => e.toString()).toList(),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
}
