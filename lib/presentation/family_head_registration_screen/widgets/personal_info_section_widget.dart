import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class PersonalInfoSectionWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> formData;
  final List<String> genderOptions;
  final List<String> maritalStatusOptions;
  final List<String> samajOptions;
  final List<String> occupationSuggestions;
  final List<String> qualificationSuggestions;
  final List<String> recommendedSamaj;
  final List<String> recommendedTemples;
  final Function(Map<String, dynamic>) onDataChanged;

  const PersonalInfoSectionWidget({
    super.key,
    required this.formKey,
    required this.formData,
    required this.genderOptions,
    required this.maritalStatusOptions,
    required this.samajOptions,
    required this.occupationSuggestions,
    required this.qualificationSuggestions,
    required this.recommendedSamaj,
    required this.recommendedTemples,
    required this.onDataChanged,
  });

  @override
  State<PersonalInfoSectionWidget> createState() =>
      _PersonalInfoSectionWidgetState();
}

class _PersonalInfoSectionWidgetState extends State<PersonalInfoSectionWidget> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _qualificationController =
      TextEditingController();
  final TextEditingController _dutiesController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();

  DateTime? _selectedBirthDate;
  String? _selectedGender;
  String? _selectedMaritalStatus;
  String? _selectedSamaj;

  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _firstNameController.text = widget.formData['firstName'] ?? '';
    _middleNameController.text = widget.formData['middleName'] ?? '';
    _lastNameController.text = widget.formData['lastName'] ?? '';
    _ageController.text = widget.formData['age'] ?? '';
    _occupationController.text = widget.formData['occupation'] ?? '';
    _qualificationController.text = widget.formData['qualification'] ?? '';
    _dutiesController.text = widget.formData['duties'] ?? '';
    _bloodGroupController.text = widget.formData['bloodGroup'] ?? '';

    _selectedBirthDate = widget.formData['birthDate'];
    _selectedGender = widget.formData['gender'];
    _selectedMaritalStatus = widget.formData['maritalStatus'];
    _selectedSamaj = widget.formData['samaj'];
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _occupationController.dispose();
    _qualificationController.dispose();
    _dutiesController.dispose();
    _bloodGroupController.dispose();
    super.dispose();
  }

  void _updateFormData() {
    final data = {
      'firstName': _firstNameController.text,
      'middleName': _middleNameController.text,
      'lastName': _lastNameController.text,
      'age': _ageController.text,
      'birthDate': _selectedBirthDate,
      'gender': _selectedGender,
      'maritalStatus': _selectedMaritalStatus,
      'occupation': _occupationController.text,
      'qualification': _qualificationController.text,
      'duties': _dutiesController.text,
      'bloodGroup': _bloodGroupController.text,
      'samaj': _selectedSamaj,
    };
    widget.onDataChanged(data);
  }

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ??
          DateTime.now().subtract(Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: AppTheme.lightTheme.colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
        // Calculate age
        final age = DateTime.now().year - picked.year;
        _ageController.text = age.toString();
      });
      _updateFormData();
    }
  }

  void _showGenderBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Gender',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 2.h),
              ...widget.genderOptions.map((gender) {
                return ListTile(
                  title: Text(gender),
                  onTap: () {
                    setState(() {
                      _selectedGender = gender;
                    });
                    _updateFormData();
                    Navigator.pop(context);
                  },
                  trailing: _selectedGender == gender
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        )
                      : null,
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showMaritalStatusBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Marital Status',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 2.h),
              ...widget.maritalStatusOptions.map((status) {
                return ListTile(
                  title: Text(status),
                  onTap: () {
                    setState(() {
                      _selectedMaritalStatus = status;
                    });
                    _updateFormData();
                    Navigator.pop(context);
                  },
                  trailing: _selectedMaritalStatus == status
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        )
                      : null,
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showSamajBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Samaj',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 2.h),
              ...widget.samajOptions.map((value) {
                return ListTile(
                  title: Text(value),
                  onTap: () {
                    setState(() {
                      _selectedSamaj = value;
                    });
                    _updateFormData();
                    Navigator.pop(context);
                  },
                  trailing: _selectedSamaj == value
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        )
                      : null,
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAutoLinkingSuggestions() {
    if (widget.recommendedSamaj.isEmpty && widget.recommendedTemples.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'lightbulb',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Auto-Linking Suggestions',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          if (widget.recommendedSamaj.isNotEmpty) ...[
            Text(
              'Recommended Samaj: ${widget.recommendedSamaj.join(', ')}',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            SizedBox(height: 0.5.h),
          ],
          if (widget.recommendedTemples.isNotEmpty) ...[
            Text(
              'Recommended Temples: ${widget.recommendedTemples.join(', ')}',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
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
              'Personal Information',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 2.h),

            // Name Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Full Name',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        labelText: 'First Name *',
                        hintText: 'Enter first name',
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'First name is required';
                        }
                        return null;
                      },
                      onChanged: (_) => _updateFormData(),
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _middleNameController,
                      decoration: InputDecoration(
                        labelText: 'Middle Name',
                        hintText: 'Enter middle name',
                      ),
                      textCapitalization: TextCapitalization.words,
                      onChanged: (_) => _updateFormData(),
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        labelText: 'Last Name *',
                        hintText: 'Enter last name',
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Last name is required';
                        }
                        return null;
                      },
                      onChanged: (_) => _updateFormData(),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Birth Details Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Birth Details',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 1.h),
                    GestureDetector(
                      onTap: _selectBirthDate,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'calendar_today',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              _selectedBirthDate != null
                                  ? '${_selectedBirthDate!.day}/${_selectedBirthDate!.month}/${_selectedBirthDate!.year}'
                                  : 'Select Birth Date *',
                              style: AppTheme.lightTheme.textTheme.bodyLarge
                                  ?.copyWith(
                                color: _selectedBirthDate != null
                                    ? AppTheme.lightTheme.colorScheme.onSurface
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _ageController,
                      decoration: InputDecoration(
                        labelText: 'Age *',
                        hintText: 'Age will be calculated automatically',
                      ),
                      keyboardType: TextInputType.number,
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please select birth date to calculate age';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Personal Details Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Details',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 1.h),
                    GestureDetector(
                      onTap: _showGenderBottomSheet,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _selectedGender ?? 'Select Gender *',
                                style: AppTheme.lightTheme.textTheme.bodyLarge
                                    ?.copyWith(
                                  color: _selectedGender != null
                                      ? AppTheme
                                          .lightTheme.colorScheme.onSurface
                                      : AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                ),
                              ),
                            ),
                            CustomIconWidget(
                              iconName: 'arrow_drop_down',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    GestureDetector(
                      onTap: _showMaritalStatusBottomSheet,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _selectedMaritalStatus ??
                                    'Select Marital Status *',
                                style: AppTheme.lightTheme.textTheme.bodyLarge
                                    ?.copyWith(
                                  color: _selectedMaritalStatus != null
                                      ? AppTheme
                                          .lightTheme.colorScheme.onSurface
                                      : AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                ),
                              ),
                            ),
                            CustomIconWidget(
                              iconName: 'arrow_drop_down',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    DropdownButtonFormField<String>(
                      value: _bloodGroupController.text.isNotEmpty
                          ? _bloodGroupController.text
                          : null,
                      decoration: InputDecoration(
                        labelText: 'Blood Group',
                        hintText: 'Select blood group',
                      ),
                      items: _bloodGroups.map((group) {
                        return DropdownMenuItem(
                          value: group,
                          child: Text(group),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _bloodGroupController.text = value ?? '';
                        });
                        _updateFormData();
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Professional Details Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Professional Details',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 1.h),
                    Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<String>.empty();
                        }
                        return widget.occupationSuggestions.where((option) {
                          return option
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      onSelected: (String selection) {
                        _occupationController.text = selection;
                        _updateFormData();
                      },
                      fieldViewBuilder:
                          (context, controller, focusNode, onEditingComplete) {
                        _occupationController.text = controller.text;
                        return TextFormField(
                          controller: controller,
                          focusNode: focusNode,
                          onEditingComplete: onEditingComplete,
                          decoration: InputDecoration(
                            labelText: 'Occupation *',
                            hintText: 'Enter occupation',
                          ),
                          textCapitalization: TextCapitalization.words,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Occupation is required';
                            }
                            return null;
                          },
                          onChanged: (_) => _updateFormData(),
                        );
                      },
                    ),
                    SizedBox(height: 1.h),
                    Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<String>.empty();
                        }
                        return widget.qualificationSuggestions.where((option) {
                          return option
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      onSelected: (String selection) {
                        _qualificationController.text = selection;
                        _updateFormData();
                      },
                      fieldViewBuilder:
                          (context, controller, focusNode, onEditingComplete) {
                        _qualificationController.text = controller.text;
                        return TextFormField(
                          controller: controller,
                          focusNode: focusNode,
                          onEditingComplete: onEditingComplete,
                          decoration: InputDecoration(
                            labelText: 'Qualification *',
                            hintText: 'Enter qualification',
                          ),
                          textCapitalization: TextCapitalization.words,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Qualification is required';
                            }
                            return null;
                          },
                          onChanged: (_) => _updateFormData(),
                        );
                      },
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _dutiesController,
                      decoration: InputDecoration(
                        labelText: 'Exact Nature of Duties',
                        hintText: 'Describe your job responsibilities',
                      ),
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (_) => _updateFormData(),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Community Details Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Community Details',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 1.h),
                    GestureDetector(
                      onTap: _showSamajBottomSheet,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _selectedSamaj ?? 'Select Samaj *',
                                style: AppTheme.lightTheme.textTheme.bodyLarge
                                    ?.copyWith(
                                  color: _selectedSamaj != null
                                      ? AppTheme
                                          .lightTheme.colorScheme.onSurface
                                      : AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                ),
                              ),
                            ),
                            CustomIconWidget(
                              iconName: 'arrow_drop_down',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 4.h),

            _buildAutoLinkingSuggestions(),
          ],
        ),
      ),
    );
  }
}
