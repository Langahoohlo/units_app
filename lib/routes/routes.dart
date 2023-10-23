import 'package:backendless_todo_starter/pages/loading.dart';
import 'package:backendless_todo_starter/pages/login.dart';
import 'package:backendless_todo_starter/pages/register.dart';
import 'package:backendless_todo_starter/pages/unit_reflections_page.dart';
import 'package:backendless_todo_starter/pages/units_view.dart';
import 'package:backendless_todo_starter/pages/unit_create.dart';
import 'package:flutter/material.dart';

class RouteManager {
  static const String loginPage = '/';
  static const String registerPage = '/registerPage';
  static const String todoPage = '/todoPage';
  static const String loadingPage = '/loadingPage';
  static const String unitPage = '/unitPage';
  static const String unitDetails = '/unitDetails';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(
          builder: (context) => Login(),
        );

      case registerPage:
        return MaterialPageRoute(
          builder: (context) => Register(),
        );

      case todoPage:
        return MaterialPageRoute(
          builder: (context) => UnitReflectionsPage(),
        );

      case unitPage:
        return MaterialPageRoute(
          builder: (context) => UnitCreatePage(),
        );

      case loadingPage:
        return MaterialPageRoute(
          builder: (context) => Loading(),
        );

      case unitDetails:
        return MaterialPageRoute(
          builder: (context) => UnitsView(
            unitDesc: '',
            reflections: '',
          ),
        );

      default:
        throw FormatException('Route not found! Check routes again!');
    }
  }
}
