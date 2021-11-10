import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_submission_dicoding/common/styles.dart';
import 'package:flutter_submission_dicoding/data/model/restaurant.dart';
import 'package:flutter_submission_dicoding/provider/database_provider.dart';
import 'package:flutter_submission_dicoding/ui/detail/restaurant_detail_page.dart';
import 'package:provider/provider.dart';

class CardRestaurant extends StatelessWidget {
  final Restaurant restaurant;

  const CardRestaurant({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(builder: (context, provider, child) {
      return FutureBuilder<bool>(
          future: provider.isFavorite(restaurant.id),
          builder: (context, snapshot) {
            var isFavorite = snapshot.data ?? false;
            return Material(
              color: primaryColor,
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                leading: Hero(
                    tag: "https://restaurant-api.dicoding.dev/images/small/" +
                        restaurant.pictureId,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        "https://restaurant-api.dicoding.dev/images/small/" +
                            restaurant.pictureId,
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width / 6,
                        fit: BoxFit.cover,
                      ),
                    )),
                title: Text(restaurant.name),
                subtitle: Text(restaurant.city),
                trailing: isFavorite
                    ? IconButton(
                        icon: Icon(Icons.favorite),
                        color: Theme.of(context).accentColor,
                        onPressed: () => provider.removeFavorite(restaurant.id),
                      )
                    : IconButton(
                        icon: Icon(Icons.favorite_border),
                        color: Theme.of(context).accentColor,
                        onPressed: () => provider.addFavorite(restaurant),
                      ),
                onTap: () => Navigator.pushNamed(
                  context,
                  RestaurantDetailPage.routeName,
                  arguments: restaurant,
                ),
              ),
            );
          });
    });
  }
}
