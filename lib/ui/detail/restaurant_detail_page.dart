import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_submission_dicoding/data/model/restaurant.dart';
import 'package:flutter_submission_dicoding/provider/detail_restaurant_provider.dart';
import 'package:flutter_submission_dicoding/utils/result_state.dart';
import 'package:provider/provider.dart';

import '../../data/api/api_service.dart';

class RestaurantDetailPage extends StatelessWidget {
  static const routeName = '/restaurant/detail';

  final Restaurant restaurant;

  const RestaurantDetailPage({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(restaurant.name),
        ),
        body: ChangeNotifierProvider<DetailRestaurantProvider>(
          create: (_) => DetailRestaurantProvider(
              apiService: ApiService(), id: restaurant.id),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Hero(
                    tag: "https://restaurant-api.dicoding.dev/images/small/" +
                        restaurant.pictureId,
                    child: Image.network(
                        "https://restaurant-api.dicoding.dev/images/small/" +
                            restaurant.pictureId)),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: Colors.transparent),
                      Text(
                        restaurant.city,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Divider(color: Colors.transparent),
                      RichText(
                        text: TextSpan(children: [
                          WidgetSpan(
                              child: Icon(
                            Icons.star,
                            color: Colors.amber,
                          )),
                          TextSpan(
                              text: restaurant.rating.toString(),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16))
                        ]),
                      ),
                      Divider(color: Colors.transparent),
                      Text(
                        'Description',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Divider(color: Colors.transparent),
                      Text(
                        restaurant.description,
                        style: TextStyle(fontSize: 16),
                      ),
                      Divider(color: Colors.transparent),
                    ],
                  ),
                ),
                Consumer<DetailRestaurantProvider>(
                  builder: (context, state, _) {
                    if (state.state == ResultState.Loading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state.state == ResultState.HasData) {
                      return Column(
                        children: [_foodMenu(state), _drinkMenu(state)],
                      );
                    } else {
                      return Center(child: Text(''));
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }

  Widget _foodMenu(DetailRestaurantProvider state) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Food Menu',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Divider(color: Colors.transparent),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount:
                  state.detailRestaurantResult.restaurant.menus.foods.length,
              itemBuilder: (context, index) {
                var detail =
                    state.detailRestaurantResult.restaurant.menus.foods[index];
                return Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Text(detail.name),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _drinkMenu(DetailRestaurantProvider state) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Drink Menu',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Divider(color: Colors.transparent),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount:
                  state.detailRestaurantResult.restaurant.menus.drinks.length,
              itemBuilder: (context, index) {
                var detail =
                    state.detailRestaurantResult.restaurant.menus.drinks[index];
                return Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Text(detail.name),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
