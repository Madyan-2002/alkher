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
  final _formKey = GlobalKey<FormState>();

  File? selectedImage;
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _salaryController = TextEditingController();
  final _locationController = TextEditingController();

  List<CategoryModel> _categories = [];
  CategoryModel? _selectedCategory;
  DateTime? _deadline;
  bool _isLoading = false;
  String _selectedType = 'sell';

  final List<_TypeOption> _types = const [
    _TypeOption('sell', 'بيع', Icons.sell_outlined),
    _TypeOption('donation', 'تبرع', Icons.volunteer_activism_outlined),
    _TypeOption('job', 'وظيفة', Icons.work_outline),
    _TypeOption('other', 'أخرى', Icons.category_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final cats = await CategoryService().getCategories();
      setState(() => _categories = cats);
    } catch (_) {}
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _targetAmountController.dispose();
    _salaryController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => selectedImage = File(image.path));
    }
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _deadline = picked);
    }
  }

  void _resetForm() {
    _nameController.clear();
    _descController.clear();
    _priceController.clear();
    _stockController.clear();
    _targetAmountController.clear();
    _salaryController.clear();
    _locationController.clear();
    setState(() {
      selectedImage = null;
      _selectedCategory = null;
      _deadline = null;
      _selectedType = 'sell';
    });
    _formKey.currentState?.reset();
  }

  Future<void> _submit() async {
    if (selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار صورة للإعلان')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final success = await ProductServices().createProduct(
      title: _nameController.text.trim(),
      description: _descController.text.trim(),
      type: _selectedType,
      image: selectedImage!,
      categoryId: _selectedType == 'sell' ? _selectedCategory?.id : null,
      price: _selectedType == 'sell'
          ? double.tryParse(_priceController.text)
          : null,
      stock: _selectedType == 'sell'
          ? int.tryParse(_stockController.text)
          : null,
      targetAmount: _selectedType == 'donation'
          ? double.tryParse(_targetAmountController.text)
          : null,
      deadline: _selectedType == 'donation' ? _deadline : null,
      salary: _selectedType == 'job'
          ? double.tryParse(_salaryController.text)
          : null,
      location: _selectedType == 'job' ? _locationController.text.trim() : null,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم إضافة الإعلان بنجاح')));
      _resetForm();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل إضافة الإعلان، حاول مرة أخرى')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'إضافة إعلان',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  _buildTypeSelector(theme),
                  const SizedBox(height: 16),

                  _buildImagePicker(theme),
                  const SizedBox(height: 16),

                  _buildCard(
                    theme: theme,
                    children: [
                      _buildField(
                        theme: theme,
                        label: 'اسم الإعلان',
                        hint: 'مثلاً: سماعات لاسلكية',
                        controller: _nameController,
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'هذا الحقل مطلوب'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        theme: theme,
                        label: 'الوصف',
                        hint: 'اكتب تفاصيل أكثر...',
                        controller: _descController,
                        maxLines: 3,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (_selectedType == 'sell') _buildSellFields(theme),
                  if (_selectedType == 'donation') _buildDonationFields(theme),
                  if (_selectedType == 'job') _buildJobFields(theme),

                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _resetForm,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: theme.dividerColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'إلغاء',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.hintColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _submit,
                          icon: _isLoading
                              ? SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    color: theme.colorScheme.onPrimary,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.add, size: 18),
                          label: Text(
                            _isLoading ? 'جاري النشر...' : 'نشر الإعلان',
                            style: const TextStyle(fontSize: 15),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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
      ),
    );
  }

  Widget _buildTypeSelector(ThemeData theme) {
    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _types.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final option = _types[index];
          final isSelected = _selectedType == option.value;
          return GestureDetector(
            onTap: () => setState(() => _selectedType = option.value),
            child: Container(
              width: 84,
              decoration: BoxDecoration(
                color: isSelected ? theme.colorScheme.primary : theme.cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.dividerColor,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    option.icon,
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.hintColor,
                    size: 26,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    option.label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSellFields(ThemeData theme) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildCard(
                theme: theme,
                children: [
                  _buildField(
                    theme: theme,
                    label: 'السعر',
                    hint: '0.00',
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    prefix: '\$ ',
                    validator: (val) =>
                        val == null || val.isEmpty ? 'مطلوب' : null,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCard(
                theme: theme,
                children: [
                  _buildField(
                    theme: theme,
                    label: 'الكمية',
                    hint: '0',
                    controller: _stockController,
                    keyboardType: TextInputType.number,
                    validator: (val) =>
                        val == null || val.isEmpty ? 'مطلوب' : null,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildCard(
          theme: theme,
          children: [
            Text(
              'التصنيف',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<CategoryModel>(
              value: _selectedCategory,
              hint: const Text('اختر التصنيف'),
              dropdownColor: theme.cardColor,
              style: theme.textTheme.bodyLarge,
              items: _categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedCategory = val),
              validator: (val) => val == null ? 'الرجاء اختيار تصنيف' : null,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDonationFields(ThemeData theme) {
    return _buildCard(
      theme: theme,
      children: [
        _buildField(
          theme: theme,
          label: 'المبلغ المستهدف',
          hint: '0.00',
          controller: _targetAmountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          prefix: '\$ ',
          validator: (val) =>
              val == null || val.isEmpty ? 'هذا الحقل مطلوب' : null,
        ),
        const SizedBox(height: 12),
        Text(
          'آخر موعد',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.hintColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        FormField<DateTime>(
          initialValue: _deadline,
          validator: (_) =>
              _deadline == null ? 'الرجاء اختيار التاريخ النهائي' : null,
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    await _pickDeadline();
                    state.didChange(_deadline);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: state.hasError
                            ? theme.colorScheme.error
                            : theme.dividerColor,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 18,
                          color: theme.hintColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _deadline == null
                              ? 'اختر التاريخ'
                              : '${_deadline!.day}/${_deadline!.month}/${_deadline!.year}',
                          style: TextStyle(
                            color: _deadline == null
                                ? theme.hintColor
                                : theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, right: 8),
                    child: Text(
                      state.errorText!,
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildJobFields(ThemeData theme) {
    return _buildCard(
      theme: theme,
      children: [
        _buildField(
          theme: theme,
          label: 'الراتب',
          hint: '0.00',
          controller: _salaryController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          prefix: '\$ ',
          validator: (val) =>
              val == null || val.isEmpty ? 'هذا الحقل مطلوب' : null,
        ),
        const SizedBox(height: 12),
        _buildField(
          theme: theme,
          label: 'الموقع',
          hint: 'مثلاً: عمّان، الأردن',
          controller: _locationController,
          validator: (val) =>
              val == null || val.trim().isEmpty ? 'هذا الحقل مطلوب' : null,
        ),
      ],
    );
  }

  Widget _buildImagePicker(ThemeData theme) {
    return GestureDetector(
      onTap: pickImage,
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selectedImage == null
                ? theme.dividerColor
                : theme.colorScheme.primary.withValues(alpha: 0.5),
            width: selectedImage == null ? 1.5 : 2,
          ),
        ),
        child: selectedImage == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 40,
                    color: theme.hintColor,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'اضغط لاختيار صورة',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: theme.hintColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'PNG, JPG حتى 10 ميجابايت',
                    style: TextStyle(fontSize: 12, color: theme.hintColor),
                  ),
                ],
              )
            : Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      selectedImage!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => setState(() => selectedImage = null),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCard({
    required ThemeData theme,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildField({
    required ThemeData theme,
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? prefix,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.hintColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefix,
            hintStyle: TextStyle(color: theme.hintColor, fontSize: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.colorScheme.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }
}

class _TypeOption {
  final String value;
  final String label;
  final IconData icon;
  const _TypeOption(this.value, this.label, this.icon);
}
