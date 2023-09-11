import 'package:brasov_earth/screens/home_page/view/home_page.dart';
import 'package:brasov_earth/screens/search_page/search_page.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/search':
        return MaterialPageRoute(builder: (_) => const SearchPage());
      default:
        throw Exception("The route name is not valid");
    }
  }
}
