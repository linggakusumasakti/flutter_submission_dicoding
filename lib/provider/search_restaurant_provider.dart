import 'package:flutter/material.dart';
import 'package:flutter_submission_dicoding/data/api/api_service.dart';
import 'package:flutter_submission_dicoding/data/model/restaurant.dart';
import 'package:flutter_submission_dicoding/utils/result_state.dart';

class SearchRestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  SearchRestaurantProvider({required this.apiService});

  late RestaurantResult _restaurantResult;
  late ResultState _state = ResultState.NoData;
  String _message = '';
  String _query = '';

  String get message => _message;

  RestaurantResult get restaurantResult => _restaurantResult;

  ResultState get state => _state;

  String get query => _query;

  String onSearch(String query) {
    notifyListeners();
    return _query = query;
  }

  Future<dynamic> fetchSearchRestaurants(String query) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurants = await apiService.searchRestaurants(query);
      if (restaurants.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Restaurant tidak ditemukan';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantResult = restaurants;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Pastikan terhubung ke internet';
    }
  }
}
