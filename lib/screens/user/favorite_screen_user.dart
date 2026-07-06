import 'package:alkher/models/product_model.dart';
import 'package:alkher/providers/favorite_provider.dart';
import 'package:alkher/screens/user/widgets/custom_card.dart';
import 'package:alkher/services/favorite_service.dart';
import 'package:alkher/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteScreenUser extends StatefulWidget {
  const FavoriteScreenUser({super.key});

  @override
  State<FavoriteScreenUser> createState() => _FavoriteScreenUserState();
}

class _FavoriteScreenUserState extends State<FavoriteScreenUser> {
  List<ProductModel> _products = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await FavoriteService().getFavoriteProducts();
      setState(() {
        _products = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'فشل تحميل المفضلة';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // بنراقب مجموعة المفضلة الحالية، عشان لو أُلغيت مفضلة من هون
    // أو من شاشة تانية، القائمة تتحدث فورًا بدون إعادة تحميل من السيرفر
    final favoriteIds = context.watch<FavoriteProvider>().favoriteIds;
    final visibleProducts =
        _products.where((p) => favoriteIds.contains(p.id)).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: AppColors.primaryDark,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: const Text(
                'المفضلة',
                style: TextStyle(
                  color: AppColors.textOnPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(child: _buildBody(visibleProducts)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(List<ProductModel> products) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.textHint),
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadFavorites,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: AppColors.textOnPrimary,
              ),
            ),
          ],
        ),
      );
    }

    if (products.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border, size: 56, color: AppColors.textHint),
            SizedBox(height: 12),
            Text(
              'لا توجد عناصر في المفضلة بعد',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            SizedBox(height: 6),
            Text(
              'اضغط على أيقونة القلب بأي إعلان لإضافته هنا',
              style: TextStyle(color: AppColors.textHint, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _loadFavorites,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.72,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) => CustomCard(product: products[index]),
      ),
    );
  }
}