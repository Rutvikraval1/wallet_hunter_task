import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ContactInfoSectionWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> formData;
  final Function(Map<String, dynamic>) onDataChanged;

  const ContactInfoSectionWidget({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onDataChanged,
  });

  @override
  State<ContactInfoSectionWidget> createState() =>
      _ContactInfoSectionWidgetState();
}

class _ContactInfoSectionWidgetState extends State<ContactInfoSectionWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _alternatePhoneController =
      TextEditingController();
  final TextEditingController _landlineController = TextEditingController();
  final TextEditingController _socialMediaController = TextEditingController();

  bool _showAdditionalContacts = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _emailController.text = widget.formData['email'] ?? '';
    _phoneController.text = widget.formData['phone'] ?? '';
    _alternatePhoneController.text = widget.formData['alternatePhone'] ?? '';
    _landlineController.text = widget.formData['landline'] ?? '';
    _socialMediaController.text = widget.formData['socialMedia'] ?? '';
    _showAdditionalContacts =
        widget.formData['showAdditionalContacts'] ?? false;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _alternatePhoneController.dispose();
    _landlineController.dispose();
    _socialMediaController.dispose();
    super.dispose();
  }

  void _updateFormData() {
    final data = {
      'email': _emailController.text,
      'phone': _phoneController.text,
      'alternatePhone': _alternatePhoneController.text,
      'landline': _landlineController.text,
      'socialMedia': _socialMediaController.text,
      'showAdditionalContacts': _showAdditionalContacts,
    };
    widget.onDataChanged(data);
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^[6-9]\d{9}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[^\d]'), ''))) {
      return 'Please enter a valid 10-digit mobile number';
    }
    return null;
  }

  String? _validateAlternatePhone(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      final phoneRegex = RegExp(r'^[6-9]\d{9}$');
      if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[^\d]'), ''))) {
        return 'Please enter a valid 10-digit mobile number';
      }
    }
    return null;
  }

  String? _validateLandline(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      final landlineRegex = RegExp(r'^\d{2,4}-?\d{6,8}$');
      if (!landlineRegex.hasMatch(value.replaceAll(RegExp(r'[^\d-]'), ''))) {
        return 'Please enter a valid landline number';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Information',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 2.h),

            // Primary Contact Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Primary Contact',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email Address *',
                        hintText: 'Enter your email address',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'email',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: _validateEmail,
                      onChanged: (_) => _updateFormData(),
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Mobile Number *',
                        hintText: 'Enter 10-digit mobile number',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'phone',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                        prefixText: '+91 ',
                      ),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validator: _validatePhone,
                      onChanged: (_) => _updateFormData(),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Additional Contacts Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Additional Contacts',
                            style: AppTheme.lightTheme.textTheme.titleMedium,
                          ),
                        ),
                        Switch(
                          value: _showAdditionalContacts,
                          onChanged: (value) {
                            setState(() {
                              _showAdditionalContacts = value;
                            });
                            _updateFormData();
                          },
                        ),
                      ],
                    ),
                    if (_showAdditionalContacts) ...[
                      SizedBox(height: 1.h),
                      TextFormField(
                        controller: _alternatePhoneController,
                        decoration: InputDecoration(
                          labelText: 'Alternate Mobile Number',
                          hintText: 'Enter alternate mobile number',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(3.w),
                            child: CustomIconWidget(
                              iconName: 'phone_android',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                          prefixText: '+91 ',
                        ),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: _validateAlternatePhone,
                        onChanged: (_) => _updateFormData(),
                      ),
                      SizedBox(height: 1.h),
                      TextFormField(
                        controller: _landlineController,
                        decoration: InputDecoration(
                          labelText: 'Landline Number',
                          hintText: 'Enter landline number with STD code',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(3.w),
                            child: CustomIconWidget(
                              iconName: 'phone_in_talk',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        validator: _validateLandline,
                        onChanged: (_) => _updateFormData(),
                      ),
                      SizedBox(height: 1.h),
                      TextFormField(
                        controller: _socialMediaController,
                        decoration: InputDecoration(
                          labelText: 'Social Media Link',
                          hintText: 'Enter social media profile link',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(3.w),
                            child: CustomIconWidget(
                              iconName: 'link',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        onChanged: (_) => _updateFormData(),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Contact Preferences Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact Preferences',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primaryContainer
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'info',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              'Your mobile number will be used for OTP verification and important community notifications.',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}
