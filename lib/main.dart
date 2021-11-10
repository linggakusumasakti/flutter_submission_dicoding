import 'dart:io';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_submission_dicoding/common/styles.dart';
import 'package:flutter_submission_dicoding/data/db/database_helper.dart';
import 'package:flutter_submission_dicoding/data/model/restaurant.dart';
import 'package:flutter_submission_dicoding/provider/database_provider.dart';
import 'package:flutter_submission_dicoding/provider/preferences_provider.dart';
import 'package:flutter_submission_dicoding/provider/restaurant_provider.dart';
import 'package:flutter_submission_dicoding/provider/scheduling_provider.dart';
import 'package:flutter_submission_dicoding/provider/search_restaurant_provider.dart';
import 'package:flutter_submission_dicoding/ui/detail/restaurant_detail_page.dart';
import 'package:flutter_submission_dicoding/ui/home/home_page.dart';
import 'package:flutter_submission_dicoding/ui/search/search_page.dart';
import 'package:flutter_submission_dicoding/ui/splash/splash_page.dart';
import 'package:flutter_submission_dicoding/utils/background_service.dart';
import 'package:flutter_submission_dicoding/utils/notification_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/api/api_service.dart';
import 'data/preferences/preferences_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  _service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RestaurantProvider>(
            create: (_) => RestaurantProvider(apiService: ApiService())),
        ChangeNotifierProvider<SearchRestaurantProvider>(
            create: (_) => SearchRestaurantProvider(apiService: ApiService())),
        ChangeNotifierProvider<SchedulingProvider>(
            create: (_) => SchedulingProvider()),
        ChangeNotifierProvider<PreferencesProvider>(
            create: (_) => PreferencesProvider(
                preferencesHelper: PreferencesHelper(
                    sharedPreferences: SharedPreferences.getInstance()))),
        ChangeNotifierProvider(
            create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()))
      ],
      child: MaterialApp(
        title: 'Restaurant App',
        theme: ThemeData(
          primaryColor: Colors.blueAccent,
          accentColor: secondaryColor,
          scaffoldBackgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: myTextTheme,
          appBarTheme: AppBarTheme(
            textTheme: myTextTheme.apply(bodyColor: Colors.white),
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: secondaryColor,
              textStyle: TextStyle(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(0),
                ),
              ),
            ),
          ),
        ),
        initialRoute: SplashPage.routeName,
        routes: {
          HomePage.routeName: (context) => HomePage(),
          RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
              restaurant:
                  ModalRoute.of(context)?.settings.arguments as Restaurant),
          SplashPage.routeName: (context) => SplashPage(),
          SearchPage.routeName: (context) => SearchPage()
        },
      ),
    );
  }
}
