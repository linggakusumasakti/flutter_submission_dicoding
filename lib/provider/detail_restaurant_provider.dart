import 'package:flutter/material.dart';
import 'package:flutter_submission_dicoding/data/model/detail_restaurant.dart';
import 'package:flutter_submission_dicoding/utils/result_state.dart';

import '../data/api/api_service.dart';

class DetailRestaurantProvider extends ChangeNotifier {
  final ApiService apiService;
  final String id;

  DetailRestaurantProvider({required this.apiService, required this.id}) {
    _fetchDetailRestaurants(id);
  }

  late DetailRestaurantResult _detailRestaurantResult;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  ResultState get state => _state;

  DetailRestaurantResult get detailRestaurantResult => _detailRestaurantResult;

  Future<dynamic> _fetchDetailRestaurants(String id) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final detail = await apiService.detailRestaurant(id);
      _state = ResultState.HasData;
      notifyListeners();
      return _detailRestaurantResult = detail;
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Pastikan terhubung ke internet';
    }
  }
}
