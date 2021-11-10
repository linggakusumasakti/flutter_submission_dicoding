import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_submission_dicoding/provider/restaurant_provider.dart';
import 'package:flutter_submission_dicoding/ui/search/search_page.dart';
import 'package:flutter_submission_dicoding/utils/result_state.dart';
import 'package:flutter_submission_dicoding/widgets/card_restaurant.dart';
import 'package:flutter_submission_dicoding/widgets/platform_widget.dart';
import 'package:provider/provider.dart';

class RestaurantListPage extends StatelessWidget {
  Widget _buildList() {
    return Consumer<RestaurantProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.Loading) {
          return Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.HasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.restaurantResult.restaurants.length,
            itemBuilder: (context, index) {
              var restaurant = state.restaurantResult.restaurants[index];
              return CardRestaurant(restaurant: restaurant);
            },
          );
        } else if (state.state == ResultState.NoData) {
          return Center(child: Text(state.message));
        } else if (state.state == ResultState.Error) {
          return Center(child: Text(state.message));
        } else {
          return Center(child: Text(''));
        }
      },
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Restaurants'),
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(SearchPage.routeName);
            },
            child: Icon(
              Icons.search,
            ),
          ),
        ),
        body: _buildList());
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Restaurants'),
          trailing: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(SearchPage.routeName);
            },
            child: Icon(
              CupertinoIcons.search,
              color: CupertinoColors.black,
            ),
          ),
          transitionBetweenRoutes: false,
        ),
        child: _buildList());
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }
}
