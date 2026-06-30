import 'dart:io';
import 'package:alkher/models/category_model.dart';
import 'package:alkher/services/category_service.dart';
import 'package:alkher/services/product_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  File? selectedImage;
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  List<CategoryModel> _categories = [];
  CategoryModel? _selectedCategory;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final cats = await CategoryService().getCategories();
    setState(() => _categories = cats);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => selectedImage = File(image.path));
    }
  }

  void _resetForm() {
    _nameController.clear();
    _descController.clear();
    _priceController.clear();
    _stockController.clear();
    setState(() {
      selectedImage = null;
      _selectedCategory = null;
    });
  }

  Future<void> _submit() async {
    if (selectedImage == null ||
        _nameController.text.isEmpty ||
        _selectedCategory == null) return;

    setState(() => _isLoading = true);

    final success = await ProductServices().createProduct(
      title: _nameController.text,
      description: _descController.text,
      price: double.tryParse(_priceController.text) ?? 0,
      stock: int.tryParse(_stockController.text) ?? 0,
      categoryId: _selectedCategory!.id,
      image: selectedImage!,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إضافة المنتج بنجاح')),
      );
      _resetForm();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل إضافة المنتج، حاول مرة أخرى')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // تم إضافة Scaffold هنا لتوفير سياق Material الـTextFields وتجنب الـ Crash
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Add Product',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                _buildImagePicker(),
                const SizedBox(height: 16),
                _buildCard(children: [
                  _buildField('Product name', 'e.g. Wireless headphones', _nameController),
                  const SizedBox(height: 12),
                  _buildField('Description', 'What makes this product special?',
                      _descController, maxLines: 3),
                ]),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildCard(children: [
                        _buildField('Price', '0.00', _priceController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true), prefix: '\$'),
                      ]),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildCard(children: [
                        _buildField('Stock', '0', _stockController,
                            keyboardType: TextInputType.number),
                      ]),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildCard(children: [
                  const Text('Category',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<CategoryModel>(
                    value: _selectedCategory,
                    hint: const Text('Select category'),
                    items: _categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedCategory = val),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ]),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _resetForm,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Cancel',
                            style: TextStyle(color: Colors.black54, fontSize: 15)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _submit,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : const Icon(Icons.add, size: 18),
                        label: Text(_isLoading ? 'Adding...' : 'Add Product',
                            style: const TextStyle(fontSize: 15)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A73E8),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: pickImage,
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selectedImage == null ? Colors.grey.shade300 : Colors.blue.shade300,
            width: selectedImage == null ? 1.5 : 2,
          ),
        ),
        child: selectedImage == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload_outlined,
                      size: 40, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  const Text('Tap to choose image',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.black54)),
                  const SizedBox(height: 4),
                  Text('PNG, JPG up to 10MB',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
                ],
              )
            : Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(selectedImage!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => setState(() => selectedImage = null),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _buildField(
    String label,
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? prefix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black54)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefix,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF1A73E8), width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }
}