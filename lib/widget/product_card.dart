import 'package:alkher/constants/api_constant.dart';
import 'package:alkher/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  const ProductCard({super.key, required this.product});

  String _getImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) {
      return imagePath;
    }

    // تنظيف أي سلاش زائدة من بداية مسار الصورة القادم من السيرفر
    if (imagePath.startsWith('/')) {
      imagePath = imagePath.substring(1);
    }

    // جلب الـ baseUrl كاملًا: http://192.168.100.13:3000/alkher/v1
    String baseUrl = ApiConstant.baseUrl;

    // تنظيف السلاش من نهاية الـ baseUrl إن وُجدت
    if (baseUrl.endsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }

    String finalUrl;
    // إذا كان السيرفر يرسل كلمة "uploads/" ضمن الـ Path، ندمجها مباشرة مع الـ baseUrl
    if (imagePath.contains('uploads')) {
      finalUrl = '$baseUrl/$imagePath';
    } else {
      // إذا كان يرسل اسم الملف مجرداً، نقوم نحن بإضافة uploads/ في المنتصف
      finalUrl = '$baseUrl/uploads/$imagePath';
    }

    print("🎯 الرابط النهائي الفعلي للتحميل: $finalUrl");
    return finalUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child:
                  product
                      .images
                      .isNotEmpty // 💡 تعديل: تم تغييرها إلى images لتطابق الموديل
                  ? Image.network(
                      _getImageUrl(
                        product
                            .images[0], // 💡 تعديل: تم تغييرها إلى images للوصول لأول صورة بأمان
                      ),
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, error, ___) {
                        print("Error loading image: $error");
                        return Container(
                          color: Colors.grey.shade100,
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey.shade100,
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  // 💡 ملاحظة: بما أن السعر نل لبعض الحالات (مثل التبرعات والوظائف)، قمت بإضافة حماية بالنل `?` وقيمة افتراضية
                  product.price != null
                      ? '\$${product.price!.toStringAsFixed(2)}'
                      : 'N/A',
                  style: const TextStyle(
                    color: Color(0xFF1A73E8),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
