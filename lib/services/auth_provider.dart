import 'package:flutter/material.dart';
import 'package:alkher/models/login_response.dart';
import 'package:alkher/services/auth_service.dart';
import 'package:alkher/services/token_services.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final TokenServices _tokenServices = TokenServices();

  LoginResponse? _loginResponse;

  LoginResponse? get currentUser => _loginResponse;

  bool get isAuthenticated => _loginResponse != null;

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      _loginResponse = await _authService.login(
        email: email,
        password: password,
      );

      if (_loginResponse != null && _loginResponse!.token.isNotEmpty) {
        await _tokenServices.saveToken(_loginResponse!.token);
        await _tokenServices.saveRole(_loginResponse!.role);
        await _tokenServices.saveUserInfo(
          name: _loginResponse!.name,
          email: _loginResponse!.email,
        );
      }

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadUserFromStorage() async {
    final token = await _tokenServices.getToken();
    if (token == null || token.isEmpty) return;

    final name = await _tokenServices.getUserName();
    final email = await _tokenServices.getUserEmail();
    final role = await _tokenServices.getRole();

    if (name != null && email != null) {
      _loginResponse = LoginResponse(
        token: token,
        name: name,
        email: email,
        role: role ?? 'customer',
      );
      notifyListeners();
    }
  }

  void logoutUser() {
    _loginResponse = null;
    _tokenServices.deleteToken();
    notifyListeners();
  }
}