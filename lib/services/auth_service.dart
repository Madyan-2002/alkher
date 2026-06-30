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
}