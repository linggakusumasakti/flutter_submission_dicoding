import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_submission_dicoding/provider/search_restaurant_provider.dart';
import 'package:flutter_submission_dicoding/utils/result_state.dart';
import 'package:flutter_submission_dicoding/widgets/card_restaurant.dart';
import 'package:provider/provider.dart';

class SearchRestaurantListPage extends StatelessWidget {
  Widget _buildList(SearchRestaurantProvider state) {
    if (state.state == ResultState.Loading) {
      return Center(child: CircularProgressIndicator());
    } else if (state.state == ResultState.HasData) {
      return Expanded(
          child: ListView.builder(
        shrinkWrap: true,
        itemCount: state.restaurantResult.restaurants.length,
        itemBuilder: (context, index) {
          var restaurant = state.restaurantResult.restaurants[index];
          return CardRestaurant(restaurant: restaurant);
        },
      ));
    } else if (state.state == ResultState.NoData) {
      return Center(child: Text(state.message));
    } else if (state.state == ResultState.Error) {
      return Center(child: Text(state.message));
    } else {
      return Center(child: Text(''));
    }
  }

  Widget _searchBox(String query) {
    return Consumer<SearchRestaurantProvider>(
      builder: (context, state, _) {
        return Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(16.0),
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 53,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 50,
                        color: Colors.grey.withOpacity(0.5))
                  ]),
              child: TextField(
                onChanged: (value) {
                  state.onSearch(value);
                  state.fetchSearchRestaurants(value);
                },
                autofocus: false,
                decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.black),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    )),
              ),
            ),
            _buildList(state)
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Search Restaurant'),
        ),
        body: _searchBox("query"));
  }
}
