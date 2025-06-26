import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ReviewSectionWidget extends StatelessWidget {
  final Map<String, dynamic> formData;

  const ReviewSectionWidget({
    super.key,
    required this.formData,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review & Submit',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Please review your information before submitting',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),

          // Personal Information Review
          _buildReviewCard(
            title: 'Personal Information',
            icon: 'person',
            children: [
              _buildReviewItem(
                'Full Name',
                '${formData['personalInfo']?['firstName'] ?? ''} ${formData['personalInfo']?['middleName'] ?? ''} ${formData['personalInfo']?['lastName'] ?? ''}'
                    .trim(),
              ),
              _buildReviewItem(
                'Age',
                formData['personalInfo']?['age'] ?? 'Not specified',
              ),
              _buildReviewItem(
                'Birth Date',
                formData['personalInfo']?['birthDate'] != null
                    ? '${(formData['personalInfo']['birthDate'] as DateTime).day}/${(formData['personalInfo']['birthDate'] as DateTime).month}/${(formData['personalInfo']['birthDate'] as DateTime).year}'
                    : 'Not specified',
              ),
              _buildReviewItem(
                'Gender',
                formData['personalInfo']?['gender'] ?? 'Not specified',
              ),
              _buildReviewItem(
                'Marital Status',
                formData['personalInfo']?['maritalStatus'] ?? 'Not specified',
              ),
              _buildReviewItem(
                'Blood Group',
                formData['personalInfo']?['bloodGroup'] ?? 'Not specified',
              ),
              _buildReviewItem(
                'Occupation',
                formData['personalInfo']?['occupation'] ?? 'Not specified',
              ),
              _buildReviewItem(
                'Qualification',
                formData['personalInfo']?['qualification'] ?? 'Not specified',
              ),
              _buildReviewItem(
                'Samaj',
                formData['personalInfo']?['samaj'] ?? 'Not specified',
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Contact Information Review
          _buildReviewCard(
            title: 'Contact Information',
            icon: 'contact_phone',
            children: [
              _buildReviewItem(
                'Email',
                formData['contactInfo']?['email'] ?? 'Not specified',
              ),
              _buildReviewItem(
                'Mobile Number',
                formData['contactInfo']?['phone'] != null
                    ? '+91 ${formData['contactInfo']['phone']}'
                    : 'Not specified',
              ),
              if (formData['contactInfo']?['alternatePhone'] != null &&
                  (formData['contactInfo']['alternatePhone'] as String)
                      .isNotEmpty)
                _buildReviewItem(
                  'Alternate Mobile',
                  '+91 ${formData['contactInfo']['alternatePhone']}',
                ),
              if (formData['contactInfo']?['landline'] != null &&
                  (formData['contactInfo']['landline'] as String).isNotEmpty)
                _buildReviewItem(
                  'Landline',
                  formData['contactInfo']['landline'],
                ),
              if (formData['contactInfo']?['socialMedia'] != null &&
                  (formData['contactInfo']['socialMedia'] as String).isNotEmpty)
                _buildReviewItem(
                  'Social Media',
                  formData['contactInfo']['socialMedia'],
                ),
            ],
          ),

          SizedBox(height: 2.h),

          // Address Information Review
          _buildReviewCard(
            title: 'Address Information',
            icon: 'location_on',
            children: [
              _buildReviewItem(
                'Current Address',
                _buildFullAddress(formData['addressInfo']),
              ),
              if (formData['addressInfo']?['showNativePlace'] == true &&
                  formData['addressInfo']?['nativeCity'] != null &&
                  (formData['addressInfo']['nativeCity'] as String).isNotEmpty)
                _buildReviewItem(
                  'Native Place',
                  '${formData['addressInfo']['nativeCity']}, ${formData['addressInfo']['nativeState'] ?? ''}',
                ),
            ],
          ),

          SizedBox(height: 2.h),

          // Submission Guidelines
          Card(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'verified_user',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Submission Guidelines',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                    ],
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'By submitting this form, you confirm that:',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          '• All information provided is accurate and complete\n• You are authorized to register as the family head\n• You agree to community guidelines and terms\n• Your mobile number will be verified via OTP\n• Temple association will be based on selected samaj',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
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
    );
  }

  Widget _buildReviewCard({
    required String title,
    required String icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: icon,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: 1.h),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            ': ',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'Not specified',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: value.isNotEmpty
                    ? AppTheme.lightTheme.colorScheme.onSurface
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _buildFullAddress(Map<String, dynamic>? addressData) {
    if (addressData == null) return 'Not specified';

    final List<String> addressParts = [];

    if (addressData['flatNumber'] != null &&
        (addressData['flatNumber'] as String).isNotEmpty) {
      addressParts.add(addressData['flatNumber']);
    }
    if (addressData['buildingName'] != null &&
        (addressData['buildingName'] as String).isNotEmpty) {
      addressParts.add(addressData['buildingName']);
    }
    if (addressData['streetName'] != null &&
        (addressData['streetName'] as String).isNotEmpty) {
      addressParts.add(addressData['streetName']);
    }
    if (addressData['landmark'] != null &&
        (addressData['landmark'] as String).isNotEmpty) {
      addressParts.add('Near ${addressData['landmark']}');
    }
    if (addressData['city'] != null &&
        (addressData['city'] as String).isNotEmpty) {
      addressParts.add(addressData['city']);
    }
    if (addressData['district'] != null &&
        (addressData['district'] as String).isNotEmpty) {
      addressParts.add(addressData['district']);
    }
    if (addressData['state'] != null &&
        (addressData['state'] as String).isNotEmpty) {
      addressParts.add(addressData['state']);
    }
    if (addressData['country'] != null &&
        (addressData['country'] as String).isNotEmpty) {
      addressParts.add(addressData['country']);
    }
    if (addressData['pincode'] != null &&
        (addressData['pincode'] as String).isNotEmpty) {
      addressParts.add(addressData['pincode']);
    }

    return addressParts.isNotEmpty ? addressParts.join(', ') : 'Not specified';
  }
}
