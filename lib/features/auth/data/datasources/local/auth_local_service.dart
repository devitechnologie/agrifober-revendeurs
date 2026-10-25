import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// local imports
import 'package:agrifober_resellers/features/auth/data/models/index.dart';

const String userKey = "auth_user";

class AuthLocalService {
  Future<void> saveUser(AuthUserModel user) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(userKey, jsonEncode(user.toJson()));
  }

  Future<AuthUserModel?> getUser() async {
    final preferences = await SharedPreferences.getInstance();
    final userData = preferences.getString(userKey);
    if (userData != null) {
      return AuthUserModel.fromJson(jsonDecode(userData));
    }
    return null;
  }

  Future<void> clearUser() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(userKey);
  }
}
