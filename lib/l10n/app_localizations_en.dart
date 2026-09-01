// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get login => 'Login';

  @override
  String get enterEmail => 'Enter your email.';

  @override
  String get enterPassword => 'Enter your password.';

  @override
  String get invalidEmail => 'The email address is invalid.';

  @override
  String get userNotFound => 'User not found.';

  @override
  String get wrongPassword => 'Incorrect password.';

  @override
  String get invalidCredential => 'Incorrect email or password.';

  @override
  String get emailAlreadyInUse => 'This email is already registered.';

  @override
  String get weakPassword => 'The password is too weak.';

  @override
  String get networkRequestFailed => 'Check your internet connection.';

  @override
  String get tooManyRequests => 'Too many attempts. Please try again later.';

  @override
  String get authenticationError => 'An error occurred during authentication.';
}
