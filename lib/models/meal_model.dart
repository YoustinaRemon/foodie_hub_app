class Ingredient {
  final String name;
  final String measure;

  Ingredient({required this.name, required this.measure});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'measure': measure,
    };
  }
}

class MealModel {
  final String idMeal;
  final String strMeal;
  final String? strDrinkAlternate;
  final String? strCategory;
  final String? strArea;
  final String? strInstructions;
  final String? strMealThumb;
  final String? strTags;
  final String? strYoutube;
  final String? strSource;
  final String? strImageSource;
  final List<Ingredient> ingredients;

  MealModel({
    required this.idMeal,
    required this.strMeal,
    this.strDrinkAlternate,
    this.strCategory,
    this.strArea,
    this.strInstructions,
    this.strMealThumb,
    this.strTags,
    this.strYoutube,
    this.strSource,
    this.strImageSource,
    required this.ingredients,
  });

  Map<String, dynamic> toJson() {
    return {
      'idMeal': idMeal,
      'strMeal': strMeal,
      'strDrinkAlternate': strDrinkAlternate,
      'strCategory': strCategory,
      'strArea': strArea,
      'strInstructions': strInstructions,
      'strMealThumb': strMealThumb,
      'strTags': strTags,
      'strYoutube': strYoutube,
      'strSource': strSource,
      'strImageSource': strImageSource,
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
    };
  }

  factory MealModel.fromJson(Map<String, dynamic> json) {
    List<Ingredient> parsedIngredients = [];
    
    if (json['ingredients'] != null && json['ingredients'] is List) {
      final List<dynamic> ingredientsList = json['ingredients'];
      for (var item in ingredientsList) {
        if (item is Map<String, dynamic>) {
          parsedIngredients.add(Ingredient(
            name: item['name']?.toString() ?? '',
            measure: item['measure']?.toString() ?? '',
          ));
        }
      }
    } else {
      for (int i = 1; i <= 20; i++) {
        final ingredientName = json['strIngredient$i']?.toString().trim();
        final ingredientMeasure = json['strMeasure$i']?.toString().trim();

        if (ingredientName != null && ingredientName.isNotEmpty) {
          parsedIngredients.add(
            Ingredient(
              name: ingredientName,
              measure: ingredientMeasure ?? '',
            ),
          );
        }
      }
    }

    return MealModel(
      idMeal: json['idMeal'] ?? '',
      strMeal: json['strMeal'] ?? 'Unknown Meal',
      strDrinkAlternate: json['strDrinkAlternate'],
      strCategory: json['strCategory'],
      strArea: json['strArea'],
      strInstructions: json['strInstructions'],
      strMealThumb: json['strMealThumb'],
      strTags: json['strTags'],
      strYoutube: json['strYoutube'],
      strSource: json['strSource'],
      strImageSource: json['strImageSource'],
      ingredients: parsedIngredients,
    );
  }
}
