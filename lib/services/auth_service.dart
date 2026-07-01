import 'dart:convert';
import 'package:alkher/constants/api_constant.dart';
import 'package:alkher/models/login_response.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConstant.baseUrl}/users/login'),
      headers: {'Content-type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    print("Login status: ${response.statusCode}");
    print("Login body: ${response.body}");

    final data = jsonDecode(response.body);
    return LoginResponse.fromJson(data);
  }

  Future<LoginResponse> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConstant.baseUrl}/users/register'),
      headers: {'Content-type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      }),
    );

    print("Register status: ${response.statusCode}");
    print("Register body: ${response.body}");

    final data = jsonDecode(response.body);
    return LoginResponse.fromJson(data);
  }
}