import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';

import '../models/unit_entry.dart';

class UserService with ChangeNotifier {
  BackendlessUser? _currentUser;
  BackendlessUser? get currentUser => _currentUser;

  void setCurrentUserNull() {
    _currentUser = null;
  }

  bool _userExists = false;
  bool get userExits => _userExists;

  set userExits(bool value) {
    _userExists = value;
    notifyListeners();
  }

  bool _showUserProgress = false;
  bool get showUserProgress => _showUserProgress;

  String _userProgressText = '';
  String get userProgressText => _userProgressText;

  Future<String> resetPassword(String username) async {
    String result = 'OK';

    _showUserProgress = true;
    _userProgressText = 'Sending reset instruction.... Please wait....';
    notifyListeners();
    await Backendless.userService
        .restorePassword(username)
        .onError((error, stackTrace) {
      result = getHumanReadableError(error.toString());
    });
    _showUserProgress = false;
    notifyListeners();
    return result;
  }

  Future<String> loginUser(String username, String password) async {
    String result = 'OK';

    _showUserProgress = true;
    _userProgressText = 'Logging you in...please wait...';
    notifyListeners();

    BackendlessUser? user = await Backendless.userService
        .login(username, password, true)
        .onError((error, stackTrace) {
      result = getHumanReadableError(error.toString());
      return null;
    });
    if (user != null) {
      _currentUser = user;
    }
    _showUserProgress = false;
    notifyListeners();

    return result;
  }

  Future<String> logoutUser() async {
    String result = 'OK';

    _showUserProgress = true;
    _userProgressText = 'Signing you out';
    notifyListeners();

    await Backendless.userService.logout().onError((error, stackTrace) {
      result = error.toString();
    });

    _showUserProgress = false;
    notifyListeners();

    return result;
  }

  // Shared prefrences to mcheck if user is logged in.
  Future<String> checkIfUserLoggedIn() async {
    String result = 'OK';

    bool? validLogin = await Backendless.userService
        .isValidLogin()
        .onError((error, stackTrace) {
      result = error.toString();
      return null;
    });

    if (validLogin != null && validLogin) {
      String? currentUserObjectid = await Backendless.userService
          .loggedInUser()
          .onError((error, stackTrace) {
        result = error.toString();
        return null;
      });
      if (currentUserObjectid != null) {
        Map<dynamic, dynamic>? maopOfCurrentUser = await Backendless.data
            .of("Users")
            .findById(currentUserObjectid)
            .onError((error, stackTrace) {
          result = error.toString();
          return null;
        });
        if (maopOfCurrentUser != null) {
          _currentUser = BackendlessUser.fromJson(maopOfCurrentUser);
          notifyListeners();
        } else {
          result = 'NOT OK';
        }
      } else {
        result = 'NOT OK';
      }
    } else {
      result = 'NOT OK';
    }

    return result;
  }

  // To avoid duplicates in our database we will check for every email before login
  void checkIfUserExists(String username) async {
    DataQueryBuilder queryBuilder = DataQueryBuilder()
      ..whereClause = "email = '$username'";

    await Backendless.data
        .withClass<BackendlessUser>()
        .find(queryBuilder)
        .then((value) {
      if (value == null || value.length == 0) {
        _userExists = false;
        notifyListeners();
      } else {
        _userExists = true;
        notifyListeners();
      }
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }

  Future<String> createUser(BackendlessUser user) async {
    String result = 'OK';
    _showUserProgress = true;
    _userProgressText = 'Creating a new user...please wait...';
    notifyListeners();
    try {
      await Backendless.userService.register(user);
      UnitEntry emptyEntry = UnitEntry(todos: {}, username: user.email);
      await Backendless.data
          .of('UnitEntry')
          .save(emptyEntry.toJson())
          .onError((error, stackTrace) {
        result = error.toString();
        return null;
      });
    } catch (e) {
      result = getHumanReadableError(e.toString());
    }
    _showUserProgress = false;
    notifyListeners();
    return result;
  }
}

String getHumanReadableError(String message) {
  if (message.contains('email address must be confirmed first')) {
    return 'Please check your inbox and confirm your email address and try to login again.';
  }
  if (message.contains('User already exists')) {
    return 'This user already exists in our database. Please create a new user.';
  }
  if (message.contains('Invalid login or password')) {
    return 'Please check your username or password. The combination do not match any entry in our database.';
  }
  if (message
      .contains('User account is locked out due to too many failed logins')) {
    return 'Your account is locked due to too many failed login attempts. Please wait 30 minutes and try again.';
  }
  if (message.contains('Unable to find a user with the specified identity')) {
    return 'Your email address does not exist in our database. Please check for spelling mistakes.';
  }
  if (message.contains(
      'Unable to resolve host "api.backendless.com": No address associated with hostname')) {
    return 'It seems as if you do not have an internet connection. Please connect and try again.';
  }
  return message;
}

// Validators
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email address';
  } else if (!RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(value)) {
    return 'Re-check your email and enter a valid email address';
  }
  return null;
}

String? validateEmptyTitle(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter the title of your Note';
  }
  return null;
}
