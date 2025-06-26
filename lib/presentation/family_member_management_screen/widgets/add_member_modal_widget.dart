import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AddMemberModalWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onMemberAdded;
  final Map<String, dynamic>? memberData;
  final bool isEditing;

  const AddMemberModalWidget({
    super.key,
    required this.onMemberAdded,
    this.memberData,
    this.isEditing = false,
  });

  @override
  State<AddMemberModalWidget> createState() => _AddMemberModalWidgetState();
}

class _AddMemberModalWidgetState extends State<AddMemberModalWidget> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _occupationController = TextEditingController();
  final _qualificationController = TextEditingController();

  String? _selectedGender;
  String? _selectedRelationship;
  String? _selectedMaritalStatus;
  String? _selectedBloodGroup;
  DateTime? _selectedBirthDate;
  String? _profilePhotoUrl;
  final bool _copyAddressFromHead = false;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _relationships = [
    'Spouse',
    'Son',
    'Daughter',
    'Father',
    'Mother',
    'Brother',
    'Sister',
    'Grandfather',
    'Grandmother',
    'Uncle',
    'Aunt',
    'Cousin',
    'Other'
  ];
  final List<String> _maritalStatuses = [
    'Single',
    'Married',
    'Divorced',
    'Widowed'
  ];
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
    if (widget.isEditing && widget.memberData != null) {
      _populateFields();
    }
  }

  void _populateFields() {
    final data = widget.memberData!;
    _firstNameController.text = data["firstName"] ?? '';
    _middleNameController.text = data["middleName"] ?? '';
    _lastNameController.text = data["lastName"] ?? '';
    _phoneController.text = data["phone"] ?? '';
    _emailController.text = data["email"] ?? '';
    _occupationController.text = data["occupation"] ?? '';
    _qualificationController.text = data["qualification"] ?? '';
    _selectedGender = data["gender"];
    _selectedRelationship = data["relationship"];
    _selectedMaritalStatus = data["maritalStatus"];
    _selectedBloodGroup = data["bloodGroup"];
    _profilePhotoUrl = data["profilePhoto"];
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _occupationController.dispose();
    _qualificationController.dispose();
    super.dispose();
  }

  void _selectBirthDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ??
          DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _selectedBirthDate = date;
      });
    }
  }

  void _selectPhoto() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                // Mock photo selection
                setState(() {
                  _profilePhotoUrl =
                      "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400";
                });
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'photo_library',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                // Mock photo selection
                setState(() {
                  _profilePhotoUrl =
                      "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400";
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveMember() {
    if (_formKey.currentState!.validate()) {
      final memberData = {
        "firstName": _firstNameController.text.trim(),
        "middleName": _middleNameController.text.trim(),
        "lastName": _lastNameController.text.trim(),
        "phone": _phoneController.text.trim(),
        "email": _emailController.text.trim(),
        "occupation": _occupationController.text.trim(),
        "qualification": _qualificationController.text.trim(),
        "gender": _selectedGender,
        "relationship": _selectedRelationship,
        "maritalStatus": _selectedMaritalStatus,
        "bloodGroup": _selectedBloodGroup,
        "birthDate": _selectedBirthDate?.toIso8601String(),
        "age": _selectedBirthDate != null
            ? DateTime.now().difference(_selectedBirthDate!).inDays ~/ 365
            : null,
        "profilePhoto": _profilePhotoUrl,
      };

      widget.onMemberAdded(memberData);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isEditing
              ? 'Family member updated successfully'
              : 'Family member added successfully'),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.shadowColor,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    widget.isEditing
                        ? 'Edit Family Member'
                        : 'Add Family Member',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                TextButton(
                  onPressed: _saveMember,
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Form Content
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(4.w),
                children: [
                  // Photo Section
                  Center(
                    child: GestureDetector(
                      onTap: _selectPhoto,
                      child: Container(
                        width: 25.w,
                        height: 25.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        child: _profilePhotoUrl != null
                            ? ClipOval(
                                child: CustomImageWidget(
                                  imageUrl: _profilePhotoUrl!,
                                  width: 25.w,
                                  height: 25.w,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.1),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'add_a_photo',
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      size: 32,
                                    ),
                                    SizedBox(height: 1.h),
                                    Text(
                                      'Add Photo',
                                      style: AppTheme
                                          .lightTheme.textTheme.labelSmall
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Personal Details Section
                  Text(
                    'Personal Details',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // Name Fields
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            labelText: 'First Name *',
                            prefixIcon: CustomIconWidget(
                              iconName: 'person',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 20,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'First name is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: TextFormField(
                          controller: _middleNameController,
                          decoration: InputDecoration(
                            labelText: 'Middle Name',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Last Name *',
                      prefixIcon: CustomIconWidget(
                        iconName: 'person',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Last name is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 2.h),

                  // Birth Date
                  GestureDetector(
                    onTap: _selectBirthDate,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: AppTheme.lightTheme.dividerColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'calendar_today',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            _selectedBirthDate != null
                                ? '${_selectedBirthDate!.day}/${_selectedBirthDate!.month}/${_selectedBirthDate!.year}'
                                : 'Select Birth Date *',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: _selectedBirthDate != null
                                  ? AppTheme.lightTheme.colorScheme.onSurface
                                  : AppTheme.lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  // Dropdowns
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: InputDecoration(
                      labelText: 'Gender *',
                      prefixIcon: CustomIconWidget(
                        iconName: 'wc',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    items: _genders
                        .map((gender) => DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedGender = value),
                    validator: (value) =>
                    value == null ? 'Gender is required' : null,
                  ),
                  SizedBox(height: 2.h),
                  DropdownButtonFormField<String>(
                    value: _selectedRelationship,
                    decoration: InputDecoration(
                      labelText: 'Relationship *',
                      prefixIcon: CustomIconWidget(
                        iconName: 'family_restroom',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    items: _relationships
                        .map((rel) => DropdownMenuItem(
                      value: rel,
                      child: Text(rel),
                    ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedRelationship = value),
                    validator: (value) =>
                    value == null ? 'Relationship is required' : null,
                  ),
                  SizedBox(height: 2.h),
                  DropdownButtonFormField<String>(
                    value: _selectedMaritalStatus,
                    decoration: InputDecoration(
                      labelText: 'Marital Status',
                      prefixIcon: CustomIconWidget(
                        iconName: 'favorite',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    items: _maritalStatuses
                        .map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedMaritalStatus = value),
                  ),
                  SizedBox(height: 2.h),
                  DropdownButtonFormField<String>(
                    value: _selectedBloodGroup,
                    decoration: InputDecoration(
                      labelText: 'Blood Group',
                      prefixIcon: CustomIconWidget(
                        iconName: 'bloodtype',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    items: _bloodGroups
                        .map((bg) => DropdownMenuItem(
                      value: bg,
                      child: Text(bg),
                    ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedBloodGroup = value),
                  ),
                  SizedBox(height: 3.h),

                  // Contact Information Section
                  Text(
                    'Contact Information',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: CustomIconWidget(
                        iconName: 'phone',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 2.h),

                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: CustomIconWidget(
                        iconName: 'email',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 3.h),

                  // Professional Information Section
                  Text(
                    'Professional Information',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  TextFormField(
                    controller: _occupationController,
                    decoration: InputDecoration(
                      labelText: 'Occupation',
                      prefixIcon: CustomIconWidget(
                        iconName: 'work',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),

                  TextFormField(
                    controller: _qualificationController,
                    decoration: InputDecoration(
                      labelText: 'Qualification',
                      prefixIcon: CustomIconWidget(
                        iconName: 'school',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
