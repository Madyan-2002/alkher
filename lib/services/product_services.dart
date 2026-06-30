import 'dart:convert';
import 'dart:io';
import 'package:alkher/constants/api_constant.dart';
import 'package:alkher/models/product_model.dart';
import 'package:alkher/services/token_services.dart';
import 'package:http/http.dart' as http;

class ProductServices {
  Future<List<ProductModel>> getProducts() async {
    final token = await TokenServices().getToken();
    final response = await http.get(
      Uri.parse("${ApiConstant.baseUrl}/products"),
      headers: {
        'Authorization' : 'Bearer $token'
      }
    );

    final decoded = jsonDecode(response.body);

     // البيانات ترجع كـ Array مباشرة وليس داخل مفتاح
    final List data = decoded as List;

    print(response.statusCode);
    print(response.body);
    return data.map((p) => ProductModel.fromJson(p)).toList();
  }

   Future<bool> createProduct({
  required String title,
  required String description,
  required double price,
  required int stock,
  required String categoryId,
  required File image,
}) async {
  final token = await TokenServices().getToken();
  
  print("=== createProduct ===");
  print("Token: $token");
  print("URL: ${ApiConstant.baseUrl}/products");
  print("categoryId: $categoryId");

  final request = http.MultipartRequest(
    'POST',
    Uri.parse("${ApiConstant.baseUrl}/products"),
  );
  request.headers['Authorization'] = 'Bearer $token';
  request.fields['title'] = title;
  request.fields['description'] = description;
  request.fields['price'] = price.toString();
  request.fields['stock'] = stock.toString();
  request.fields['category'] = categoryId;
  request.files.add(await http.MultipartFile.fromPath('image', image.path));
  
  final response = await request.send();
  final responseBody = await response.stream.bytesToString();
  
  print("Status: ${response.statusCode}");
  print("Body: $responseBody");
  print("Token: $token");
  
  return response.statusCode == 201;
}
}
