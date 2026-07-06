import 'package:alkher/providers/product_provider.dart';
import 'package:alkher/screens/user/widgets/custom_card.dart';
import 'package:alkher/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuyScreen extends StatefulWidget {
  const BuyScreen({super.key});

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  static const _type = 'sell';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchByType(_type);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.primaryDark,
            padding: const EdgeInsets.fromLTRB(20, 50, 30, 16),
            child: const Text(
              'الشراء',
              style: TextStyle(color: AppColors.textOnPrimary, fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, child) {
                final status = provider.statusFor(_type);
      
                switch (status) {
                  case LoadStatus.initial:
                  case LoadStatus.loading:
                    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
      
                  case LoadStatus.error:
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.textHint),
                          const SizedBox(height: 12),
                          Text(provider.errorFor(_type) ?? 'حدث خطأ',
                              style: const TextStyle(color: AppColors.textSecondary)),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => provider.fetchByType(_type),
                            icon: const Icon(Icons.refresh, size: 18),
                            label: const Text('إعادة المحاولة'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryDark, foregroundColor: AppColors.textOnPrimary),
                          ),
                        ],
                      ),
                    );
      
                  case LoadStatus.loaded:
                    final products = provider.productsFor(_type);
                    if (products.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.shopping_bag_outlined, size: 56, color: AppColors.textHint),
                            SizedBox(height: 12),
                            Text('لا توجد منتجات حاليًا', style: TextStyle(color: AppColors.textSecondary)),
                          ],
                        ),
                      );
                    }
      
                    return RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () => provider.refresh(_type),
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
              },
            ),
          ),
        ],
      ),
    );
  }
}