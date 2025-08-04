import 'package:flutter/material.dart';

class AppLocalizations {
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Add localization strings here as the app grows
  String get appTitle => 'Stock Manager';

  String get welcome => 'Welcome';

  String get login => 'Login';

  String get logout => 'Logout';

  String get email => 'Email';

  String get password => 'Password';

  String get rememberMe => 'Remember Me';

  String get forgotPassword => 'Forgot Password?';

  String get dashboard => 'Dashboard';

  String get products => 'Products';

  String get suppliers => 'Suppliers';

  String get users => 'Users';

  String get settings => 'Settings';

  String get save => 'Save';

  String get cancel => 'Cancel';

  String get delete => 'Delete';

  String get edit => 'Edit';

  String get add => 'Add';

  String get search => 'Search';

  String get filter => 'Filter';

  String get loading => 'Loading...';

  String get error => 'Error';

  String get success => 'Success';

  String get noDataFound => 'No data found';
}
