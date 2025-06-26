import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AddressInfoSectionWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> formData;
  final Function(Map<String, dynamic>) onDataChanged;

  const AddressInfoSectionWidget({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onDataChanged,
  });

  @override
  State<AddressInfoSectionWidget> createState() =>
      _AddressInfoSectionWidgetState();
}

class _AddressInfoSectionWidgetState extends State<AddressInfoSectionWidget> {
  // Current Address Controllers
  final TextEditingController _flatNumberController = TextEditingController();
  final TextEditingController _buildingNameController = TextEditingController();
  final TextEditingController _streetNameController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  // Native Place Controllers
  final TextEditingController _nativeCityController = TextEditingController();
  final TextEditingController _nativeStateController = TextEditingController();

  bool _showNativePlace = false;

  // Mock data for dropdowns
  final List<String> _indianStates = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal'
  ];

  final List<String> _countries = [
    'India',
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
    'Germany',
    'France',
    'Japan',
    'Singapore',
    'UAE'
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _flatNumberController.text = widget.formData['flatNumber'] ?? '';
    _buildingNameController.text = widget.formData['buildingName'] ?? '';
    _streetNameController.text = widget.formData['streetName'] ?? '';
    _landmarkController.text = widget.formData['landmark'] ?? '';
    _cityController.text = widget.formData['city'] ?? '';
    _districtController.text = widget.formData['district'] ?? '';
    _stateController.text = widget.formData['state'] ?? '';
    _countryController.text = widget.formData['country'] ?? 'India';
    _pincodeController.text = widget.formData['pincode'] ?? '';
    _nativeCityController.text = widget.formData['nativeCity'] ?? '';
    _nativeStateController.text = widget.formData['nativeState'] ?? '';
    _showNativePlace = widget.formData['showNativePlace'] ?? false;
  }

  @override
  void dispose() {
    _flatNumberController.dispose();
    _buildingNameController.dispose();
    _streetNameController.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _pincodeController.dispose();
    _nativeCityController.dispose();
    _nativeStateController.dispose();
    super.dispose();
  }

  void _updateFormData() {
    final data = {
      'flatNumber': _flatNumberController.text,
      'buildingName': _buildingNameController.text,
      'streetName': _streetNameController.text,
      'landmark': _landmarkController.text,
      'city': _cityController.text,
      'district': _districtController.text,
      'state': _stateController.text,
      'country': _countryController.text,
      'pincode': _pincodeController.text,
      'nativeCity': _nativeCityController.text,
      'nativeState': _nativeStateController.text,
      'showNativePlace': _showNativePlace,
    };
    widget.onDataChanged(data);
  }

  String? _validatePincode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Pincode is required';
    }
    final pincodeRegex = RegExp(r'^\d{6}$');
    if (!pincodeRegex.hasMatch(value)) {
      return 'Please enter a valid 6-digit pincode';
    }
    return null;
  }

  void _showStateBottomSheet({required bool isNative}) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: 60.h,
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Text(
                isNative ? 'Select Native State' : 'Select State',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: ListView.builder(
                  itemCount: _indianStates.length,
                  itemBuilder: (context, index) {
                    final state = _indianStates[index];
                    return ListTile(
                      title: Text(state),
                      onTap: () {
                        setState(() {
                          if (isNative) {
                            _nativeStateController.text = state;
                          } else {
                            _stateController.text = state;
                          }
                        });
                        _updateFormData();
                        Navigator.pop(context);
                      },
                      trailing: (isNative
                                  ? _nativeStateController.text
                                  : _stateController.text) ==
                              state
                          ? CustomIconWidget(
                              iconName: 'check',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 20,
                            )
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCountryBottomSheet() {
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
                'Select Country',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 2.h),
              ..._countries.map((country) {
                return ListTile(
                  title: Text(country),
                  onTap: () {
                    setState(() {
                      _countryController.text = country;
                    });
                    _updateFormData();
                    Navigator.pop(context);
                  },
                  trailing: _countryController.text == country
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
              'Address Information',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 2.h),

            // Current Address Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Address',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _flatNumberController,
                            decoration: InputDecoration(
                              labelText: 'Flat/Door Number',
                              hintText: 'Enter flat number',
                            ),
                            textCapitalization: TextCapitalization.words,
                            onChanged: (_) => _updateFormData(),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: TextFormField(
                            controller: _buildingNameController,
                            decoration: InputDecoration(
                              labelText: 'Building Name',
                              hintText: 'Enter building name',
                            ),
                            textCapitalization: TextCapitalization.words,
                            onChanged: (_) => _updateFormData(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _streetNameController,
                      decoration: InputDecoration(
                        labelText: 'Street Name *',
                        hintText: 'Enter street name',
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Street name is required';
                        }
                        return null;
                      },
                      onChanged: (_) => _updateFormData(),
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _landmarkController,
                      decoration: InputDecoration(
                        labelText: 'Landmark',
                        hintText: 'Enter nearby landmark',
                      ),
                      textCapitalization: TextCapitalization.words,
                      onChanged: (_) => _updateFormData(),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _cityController,
                            decoration: InputDecoration(
                              labelText: 'City *',
                              hintText: 'Enter city',
                            ),
                            textCapitalization: TextCapitalization.words,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'City is required';
                              }
                              return null;
                            },
                            onChanged: (_) => _updateFormData(),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: TextFormField(
                            controller: _districtController,
                            decoration: InputDecoration(
                              labelText: 'District *',
                              hintText: 'Enter district',
                            ),
                            textCapitalization: TextCapitalization.words,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'District is required';
                              }
                              return null;
                            },
                            onChanged: (_) => _updateFormData(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    GestureDetector(
                      onTap: () => _showStateBottomSheet(isNative: false),
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
                                _stateController.text.isNotEmpty
                                    ? _stateController.text
                                    : 'Select State *',
                                style: AppTheme.lightTheme.textTheme.bodyLarge
                                    ?.copyWith(
                                  color: _stateController.text.isNotEmpty
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
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: _showCountryBottomSheet,
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      AppTheme.lightTheme.colorScheme.outline,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _countryController.text.isNotEmpty
                                          ? _countryController.text
                                          : 'Select Country *',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyLarge
                                          ?.copyWith(
                                        color:
                                            _countryController.text.isNotEmpty
                                                ? AppTheme.lightTheme
                                                    .colorScheme.onSurface
                                                : AppTheme
                                                    .lightTheme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                  CustomIconWidget(
                                    iconName: 'arrow_drop_down',
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: TextFormField(
                            controller: _pincodeController,
                            decoration: InputDecoration(
                              labelText: 'Pincode *',
                              hintText: 'Enter pincode',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                            ],
                            validator: _validatePincode,
                            onChanged: (_) => _updateFormData(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Native Place Section
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
                            'Native Place',
                            style: AppTheme.lightTheme.textTheme.titleMedium,
                          ),
                        ),
                        Switch(
                          value: _showNativePlace,
                          onChanged: (value) {
                            setState(() {
                              _showNativePlace = value;
                              if (!value) {
                                _nativeCityController.clear();
                                _nativeStateController.clear();
                              }
                            });
                            _updateFormData();
                          },
                        ),
                      ],
                    ),
                    if (_showNativePlace) ...[
                      SizedBox(height: 1.h),
                      TextFormField(
                        controller: _nativeCityController,
                        decoration: InputDecoration(
                          labelText: 'Native City',
                          hintText: 'Enter native city',
                        ),
                        textCapitalization: TextCapitalization.words,
                        onChanged: (_) => _updateFormData(),
                      ),
                      SizedBox(height: 1.h),
                      GestureDetector(
                        onTap: () => _showStateBottomSheet(isNative: true),
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
                                  _nativeStateController.text.isNotEmpty
                                      ? _nativeStateController.text
                                      : 'Select Native State',
                                  style: AppTheme.lightTheme.textTheme.bodyLarge
                                      ?.copyWith(
                                    color:
                                        _nativeStateController.text.isNotEmpty
                                            ? AppTheme.lightTheme.colorScheme
                                                .onSurface
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
                  ],
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Address Guidelines Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Address Guidelines',
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'info',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 16,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Please ensure accuracy:',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            '• This address will be used for community correspondence\n• Native place helps in temple auto-association\n• Ensure pincode is correct for location verification',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
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
      ),
    );
  }
}
