import 'package:flutter/material.dart';
import 'package:alkher/models/product_model.dart';
import 'package:alkher/services/product_services.dart';

enum LoadStatus { initial, loading, loaded, error }

class ProductProvider extends ChangeNotifier {
  final ProductServices _service = ProductServices();

  // كل نوع (sell/donation/job/other) إله قائمة وحالة منفصلة
  final Map<String, List<ProductModel>> _productsByType = {};
  final Map<String, LoadStatus> _statusByType = {};
  final Map<String, String?> _errorByType = {};

  List<ProductModel> productsFor(String type) => _productsByType[type] ?? [];
  LoadStatus statusFor(String type) => _statusByType[type] ?? LoadStatus.initial;
  String? errorFor(String type) => _errorByType[type];

  Future<void> fetchByType(String type) async {
    _statusByType[type] = LoadStatus.loading;
    notifyListeners();

    try {
      final result = await _service.getProducts(type: type);
      _productsByType[type] = result;
      _statusByType[type] = LoadStatus.loaded;
      notifyListeners();
    } catch (e) {
      _errorByType[type] = 'فشل تحميل البيانات';
      _statusByType[type] = LoadStatus.error;
      notifyListeners();
    }
  }

  Future<void> refresh(String type) => fetchByType(type);

  // كل الأنواع مع بعض (لقسم الاستكشاف)
  List<ProductModel> get allLoaded =>
      _productsByType.values.expand((list) => list).toList();
}