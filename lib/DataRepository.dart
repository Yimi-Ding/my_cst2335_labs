import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class DataRepository {
  // Variables to store the user data
  static String firstName = '';
  static String lastName = '';
  static String phone = '';
  static String email = '';

  // Variables to store the login data
  static String username = '';
  static String password = '';

  // EncryptedSharedPreferences instance
  static final EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();

  // Method to load user and login data
  static Future<void> loadData() async {
    // Load user data
    firstName = await _prefs.getString('firstName') ?? '';
    lastName = await _prefs.getString('lastName') ?? '';
    phone = await _prefs.getString('phone') ?? '';
    email = await _prefs.getString('email') ?? '';

    // Load login data
    username = await _prefs.getString('username') ?? '';
    password = await _prefs.getString('password') ?? '';
  }

  // Method to save user and login data
  static Future<void> saveData() async {
    // Save user data
    await _prefs.setString('firstName', firstName);
    await _prefs.setString('lastName', lastName);
    await _prefs.setString('phone', phone);
    await _prefs.setString('email', email);

    // Save login data
    await _prefs.setString('username', username);
    await _prefs.setString('password', password);
  }
}
