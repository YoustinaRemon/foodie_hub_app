import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodie_hup/features/cookbook/models/custom_recipe_model.dart';
import 'package:foodie_hup/services/api_exceptions.dart';

class CustomRecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference _customRecipesRef(String uid) {
    return _firestore.collection('users').doc(uid).collection('customRecipes');
  }

  Future<void> createRecipe(String uid, CustomRecipeModel recipe) async {
    try {
      final docRef = _customRecipesRef(uid).doc(recipe.id);
      final recipeData = recipe.toJson();
      recipeData['createdAt'] = FieldValue.serverTimestamp();
      recipeData['updatedAt'] = FieldValue.serverTimestamp();
      
      await docRef.set(recipeData);
    } catch (e) {
      throw ApiException('Failed to create recipe. Please try again.');
    }
  }

  Future<List<CustomRecipeModel>> getUserRecipes(String uid) async {
    try {
      final snapshot = await _customRecipesRef(uid).orderBy('createdAt', descending: true).get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return CustomRecipeModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw ApiException('Failed to load your recipes.');
    }
  }

  Future<void> updateRecipe(String uid, CustomRecipeModel recipe) async {
    try {
      final docRef = _customRecipesRef(uid).doc(recipe.id);
      final recipeData = recipe.toJson();
      recipeData['updatedAt'] = FieldValue.serverTimestamp();
      
      await docRef.update(recipeData);
    } catch (e) {
      throw ApiException('Failed to update recipe. Please try again.');
    }
  }

  Future<void> deleteRecipe(String uid, String recipeId) async {
    try {
      await _customRecipesRef(uid).doc(recipeId).delete();
    } catch (e) {
      throw ApiException('Failed to delete recipe. Please try again.');
    }
  }
}
