import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodie_hup/models/meal_model.dart';
import 'package:foodie_hup/services/api_exceptions.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference _favoritesRef(String uid) {
    return _firestore.collection('users').doc(uid).collection('favorites');
  }

  Future<void> addFavorite(String uid, MealModel meal) async {
    try {
      final docRef = _favoritesRef(uid).doc(meal.idMeal);
      
      final mealData = meal.toJson();
      mealData['createdAt'] = FieldValue.serverTimestamp();
      
      await docRef.set(mealData);
    } catch (e) {
      throw ApiException('Failed to add recipe to favorites. Please try again.');
    }
  }

  Future<void> removeFavorite(String uid, String mealId) async {
    try {
      await _favoritesRef(uid).doc(mealId).delete();
    } catch (e) {
      throw ApiException('Failed to remove recipe from favorites. Please try again.');
    }
  }

  Future<List<MealModel>> getFavorites(String uid) async {
    try {
      final snapshot = await _favoritesRef(uid).orderBy('createdAt', descending: true).get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Ensure idMeal is present from doc ID if missing
        if (!data.containsKey('idMeal') || data['idMeal'] == null) {
          data['idMeal'] = doc.id;
        }
        return MealModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw ApiException('Failed to load favorite recipes.');
    }
  }
}
