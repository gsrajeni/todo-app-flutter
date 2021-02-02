
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/ui/addNew/AddNewPage.dart';
import 'package:todo/ui/home/HomePage.dart';
import 'package:todo/ui/splash/SplashPage.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => SplashPage());
      case "/home":
        return MaterialPageRoute(builder: (_) => HomePage());
      case "/addNew":
        return MaterialPageRoute(builder: (_) => AddNewPage());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text(
                          '${"No_route_defined_for"} ${settings.name}')),
                ));
    }
  }
}
