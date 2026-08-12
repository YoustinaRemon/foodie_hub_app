import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:foodie_hup/core/constants/api_constants.dart';
import 'package:foodie_hup/models/meal_model.dart';
import 'package:foodie_hup/services/api_exceptions.dart';

class RecipeApiService {
  final http.Client _client;

  RecipeApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<MealModel>> searchMeals(String query) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.searchMeals}?s=$query');
    return _fetchMealList(url);
  }

  Future<List<MealModel>> getPopularMeals() async {
    // TheMealDB free tier doesn't have a specific 'popular' endpoint.
    // Searching with an empty string returns a general list of meals.
    return searchMeals('');
  }

  Future<MealModel?> getMealDetails(String mealId) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getMealDetails}?i=$mealId');
    try {
      final response = await _client.get(url);
      _handleHttpErrors(response);

      final data = json.decode(response.body);
      if (data['meals'] == null || (data['meals'] as List).isEmpty) {
        return null;
      }

      return MealModel.fromJson(data['meals'][0]);
    } on SocketException {
      throw NetworkException();
    } on FormatException {
      throw InvalidResponseException();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ServerException();
    }
  }

  Future<List<MealModel>> getMealsByCategory(String category) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.filterByCategory}?c=$category');
    return _fetchMealList(url);
  }

  Future<List<MealModel>> getMealsByArea(String area) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.filterByArea}?a=$area');
    return _fetchMealList(url);
  }

  Future<List<String>> getCategories() async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getCategories}');
    try {
      final response = await _client.get(url);
      _handleHttpErrors(response);

      final data = json.decode(response.body);
      if (data['categories'] == null) {
        return [];
      }

      final categories = (data['categories'] as List)
          .map((c) => c['strCategory']?.toString() ?? '')
          .where((c) => c.isNotEmpty)
          .toList();
          
      return categories;
    } on SocketException {
      throw NetworkException();
    } on FormatException {
      throw InvalidResponseException();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ServerException();
    }
  }

  Future<List<MealModel>> _fetchMealList(Uri url) async {
    try {
      final response = await _client.get(url);
      _handleHttpErrors(response);

      final data = json.decode(response.body);
      
      // If the API returns a valid response but no meals, return an empty list.
      if (data['meals'] == null) {
        return [];
      }

      final mealsList = data['meals'] as List;
      return mealsList.map((mealJson) => MealModel.fromJson(mealJson)).toList();
    } on SocketException {
      throw NetworkException();
    } on FormatException {
      throw InvalidResponseException();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ServerException();
    }
  }

  void _handleHttpErrors(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    if (response.statusCode >= 500) {
      throw ServerException('The server is currently unavailable (Error ${response.statusCode}).');
    }
    throw ServerException('Failed to fetch data from the server (Error ${response.statusCode}).');
  }
}
