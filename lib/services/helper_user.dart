import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:backendless_todo_starter/routes/routes.dart';
import 'package:backendless_todo_starter/services/unit_service.dart';
import 'package:backendless_todo_starter/services/user_service.dart';
import 'package:backendless_todo_starter/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void createNewUserInUI(BuildContext context,
    {required String email,
    required String password,
    required String name}) async {
  FocusManager.instance.primaryFocus?.unfocus();

  if (email.isEmpty || name.isEmpty || password.isEmpty) {
    showSnackBar(
      context,
      'Please enter all fields!',
    );
  } else {
    BackendlessUser user = BackendlessUser()
      ..email = email.trim()
      ..password = password.trim()
      ..putProperties({
        'name': name.trim(),
      });

    String result = await context.read<UserService>().createUser(user);
    if (result != 'OK') {
      showSnackBar(context, result);
    } else {
      showSnackBar(context, 'New user successfully created!');
      Navigator.pop(context);
    }
  }
}

void loginUserInUI(BuildContext context,
    {required String email, required String password}) async {
  // Creating a user that will be saved in backendless
  FocusManager.instance.primaryFocus?.unfocus();
  if (email.isEmpty || password.isEmpty) {
    showSnackBar(context, 'Please enter all fields');
  } else {
    String result = await context
        .read<UserService>()
        .loginUser(email.trim(), password.trim());

    if (result != 'OK') {
      showSnackBar(context, result);
    } else {
      context.read<TodoService>().getTodos(email);
      Navigator.of(context).popAndPushNamed(RouteManager.todoPage);
    }
  }
}

void resetPasswordInUI(BuildContext context, {required String email}) async {
  // To reset password email will need tbe required
  if (email.isEmpty) {
    showSnackBar(context, 'Please enter your email address');
  } else {
    String result =
        await context.read<UserService>().resetPassword(email.trim());
    if (result == 'OK') {
      showSnackBar(context, 'Please check your email');
    } else {
      showSnackBar(context, result);
    }
  }
}

void logoutUserInUI(BuildContext context) async {
  String result = await context.read<UserService>().logoutUser();
  if (result == 'OK') {
    context.read<UserService>().setCurrentUserNull();
    Navigator.popAndPushNamed(context, RouteManager.loginPage);
  } else {
    showSnackBar(context, result);
  }
}
