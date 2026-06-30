import 'dart:convert';

import 'package:alkher/constants/api_constant.dart';
import 'package:alkher/models/category_model.dart';
import 'package:alkher/services/token_services.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  Future<List<CategoryModel>> getCategories() async {
    final token = await TokenServices().getToken();
    final response = await http.get(
      Uri.parse('${ApiConstant.baseUrl}/categories'),
      headers: {'Authroization': 'Bearer $token'},
    );
    final List data = jsonDecode(response.body) as List;
    return data.map((c) => CategoryModel.fromJson(c)).toList();
  }
}
