import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/address_info_section_widget.dart';
import './widgets/contact_info_section_widget.dart';
import './widgets/personal_info_section_widget.dart';
import './widgets/review_section_widget.dart';

class FamilyHeadRegistrationScreen extends StatefulWidget {
  const FamilyHeadRegistrationScreen({super.key});

  @override
  State<FamilyHeadRegistrationScreen> createState() =>
      _FamilyHeadRegistrationScreenState();
}

class _FamilyHeadRegistrationScreenState
    extends State<FamilyHeadRegistrationScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 4;

  // Form keys for validation
  final GlobalKey<FormState> _personalInfoFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _contactInfoFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _addressInfoFormKey = GlobalKey<FormState>();

  // Form data storage
  final Map<String, dynamic> _formData = {
    'personalInfo': <String, dynamic>{},
    'contactInfo': <String, dynamic>{},
    'addressInfo': <String, dynamic>{},
  };

  final FamilyController _familyController = Get.find<FamilyController>();

  // Dynamic data with auto-linking
  List<String> get _genderOptions => ['Male', 'Female', 'Other'];
  List<String> get _maritalStatusOptions =>
      ['Single', 'Married', 'Divorced', 'Widowed'];
  List<String> get _samajOptions => _familyController.availableSamaj;
  List<String> get _occupationSuggestions => [
        'Software Engineer',
        'Doctor',
        'Teacher',
        'Business Owner',
        'Lawyer',
        'Accountant',
        'Farmer',
        'Government Employee',
        'Retired',
        'Student'
      ];
  List<String> get _qualificationSuggestions => [
        'High School',
        'Bachelor\'s Degree',
        'Master\'s Degree',
        'PhD',
        'Diploma',
        'Professional Certificate',
        'Other'
      ];

  // Auto-linking computed properties
  List<String> get _recommendedSamaj {
    final lastName = _formData['personalInfo']['lastName'] ?? '';
    final address = _formData['addressInfo']['fullAddress'] ?? '';
    return _familyController.getRecommendedSamaj(lastName, address);
  }

  List<String> get _recommendedTemples {
    final address = _formData['addressInfo']['fullAddress'] ?? '';
    final samaj = _formData['personalInfo']['samaj'] ?? '';
    return _familyController.getRecommendedTemples(address, samaj);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      if (_currentStep < _totalSteps - 1) {
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        HapticFeedback.lightImpact();
      } else {
        _submitForm();
      }
    } else {
      HapticFeedback.heavyImpact();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      HapticFeedback.lightImpact();
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _personalInfoFormKey.currentState?.validate() ?? false;
      case 1:
        return _contactInfoFormKey.currentState?.validate() ?? false;
      case 2:
        return _addressInfoFormKey.currentState?.validate() ?? false;
      case 3:
        return true; // Review step
      default:
        return false;
    }
  }

  void _submitForm() async {
    await _familyController.saveFamilyHead(_formData);

    if (_familyController.errorMessage.value.isEmpty) {
      // Navigate to dashboard
      Get.offAllNamed(AppRoutes.dashboardScreen);
    }
  }

  void _showExitConfirmation() {
    if (_hasSignificantProgress()) {
      Get.dialog(
        AlertDialog(
          title: Text('Exit Registration?'),
          content:
              Text('You have unsaved progress. Are you sure you want to exit?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                Get.back();
              },
              child: Text('Exit'),
            ),
          ],
        ),
      );
    } else {
      Get.back();
    }
  }

  bool _hasSignificantProgress() {
    return _currentStep > 0 || _formData['personalInfo'].isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showExitConfirmation();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Obx(() => Column(
                children: [
                  _buildHeader(),
                  _buildProgressIndicator(),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        PersonalInfoSectionWidget(
                          formKey: _personalInfoFormKey,
                          formData: _formData['personalInfo'],
                          genderOptions: _genderOptions,
                          maritalStatusOptions: _maritalStatusOptions,
                          samajOptions: _samajOptions,
                          occupationSuggestions: _occupationSuggestions,
                          qualificationSuggestions: _qualificationSuggestions,
                          recommendedSamaj: _recommendedSamaj,
                          recommendedTemples: _recommendedTemples,
                          onDataChanged: (data) {
                            setState(() {
                              _formData['personalInfo'] = data;
                            });
                          },
                        ),
                        ContactInfoSectionWidget(
                          formKey: _contactInfoFormKey,
                          formData: _formData['contactInfo'],
                          onDataChanged: (data) {
                            setState(() {
                              _formData['contactInfo'] = data;
                            });
                          },
                        ),
                        AddressInfoSectionWidget(
                          formKey: _addressInfoFormKey,
                          formData: _formData['addressInfo'],
                          onDataChanged: (data) {
                            setState(() {
                              _formData['addressInfo'] = data;
                            });
                          },
                        ),
                        ReviewSectionWidget(
                          formData: _formData,
                        ),
                      ],
                    ),
                  ),
                  _buildBottomNavigation(),
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _showExitConfirmation,
            child: CustomIconWidget(
              iconName: 'arrow_back',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Family Head Registration',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Step ${_currentStep + 1} of $_totalSteps',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // Show loading indicator when saving
          if (_familyController.isLoading.value)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: List.generate(_totalSteps, (index) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              height: 4,
              decoration: BoxDecoration(
                color: index <= _currentStep
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            offset: Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed:
                    _familyController.isLoading.value ? null : _previousStep,
                child: Text('Previous'),
              ),
            ),
          if (_currentStep > 0) SizedBox(width: 4.w),
          Expanded(
            flex: _currentStep == 0 ? 1 : 1,
            child: ElevatedButton(
              onPressed: _familyController.isLoading.value ? null : _nextStep,
              child: _familyController.isLoading.value
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(
                      _currentStep == _totalSteps - 1 ? 'Submit' : 'Continue'),
            ),
          ),
        ],
      ),
    );
  }
}
