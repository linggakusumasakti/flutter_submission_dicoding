import 'package:flutter/cupertino.dart';
import 'package:flutter_submission_dicoding/data/api/api_service.dart';
import 'package:flutter_submission_dicoding/data/model/restaurant.dart';
import 'package:flutter_submission_dicoding/utils/result_state.dart';
import 'package:http/http.dart' as http;

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService}) {
    fetchAllRestaurants();
  }

  late RestaurantResult _restaurantResult;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  RestaurantResult get restaurantResult => _restaurantResult;

  ResultState get state => _state;

  Future<dynamic> fetchAllRestaurants() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurants = await apiService.listRestaurants(http.Client());
      if (restaurants.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
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
