import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_submission_dicoding/ui/search/search_restaurant_list_page.dart';

class SearchPage extends StatelessWidget {
  static const routeName = '/restaurant/search';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SearchRestaurantListPage(),
    );
  }
}
