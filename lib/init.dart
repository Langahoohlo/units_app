import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:backendless_todo_starter/routes/routes.dart';
import 'package:backendless_todo_starter/services/unit_service.dart';
import 'package:backendless_todo_starter/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class InitApp {
  // Get the api keys from backendless
  static const String apiKeyAndroid = ''; 
  static const String apiKeyiOS = '';
  static const String appID = '';

  static void initializeApp(BuildContext context) async {
    await Backendless.initApp(
        applicationId: appID,
        iosApiKey: apiKeyiOS,
        androidApiKey: apiKeyAndroid);
    String result = await context.read<UserService>().checkIfUserLoggedIn();
    if (result == 'OK') {
      context
          .read<TodoService>()
          .getTodos(context.read<UserService>().currentUser!.email);
      Navigator.popAndPushNamed(context, RouteManager.todoPage);
    } else {
      Navigator.popAndPushNamed(context, RouteManager.loginPage);
    }
  }
}
