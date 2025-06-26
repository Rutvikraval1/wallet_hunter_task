import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_phone_input.dart';

class PhoneInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  const PhoneInputWidget({
    super.key,
    required this.controller,
     this.focusNode,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mobile Number',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow
                    .withValues(alpha: 0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: CustomPhoneInput(
            onChanged:(value) {
              onChanged!(value);
            },
          )
          // Row(
          //   children: [
          //     // Country Code Section
          //     Container(
          //       padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          //       decoration: BoxDecoration(
          //         color:
          //             AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
          //         borderRadius: BorderRadius.only(
          //           topLeft: Radius.circular(16),
          //           bottomLeft: Radius.circular(16),
          //         ),
          //       ),
          //       child: Row(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           Text(
          //             '🇮🇳',
          //             style: TextStyle(fontSize: 6.w),
          //           ),
          //           SizedBox(width: 2.w),
          //           Text(
          //             '+91',
          //             style:
          //                 AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
          //               color: AppTheme.lightTheme.primaryColor,
          //               fontWeight: FontWeight.w600,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //
          //     // Phone Number Input
          //     Expanded(
          //       child: TextFormField(
          //         controller: controller,
          //         focusNode: focusNode,
          //         keyboardType: TextInputType.phone,
          //         inputFormatters: [
          //           FilteringTextInputFormatter.digitsOnly,
          //           LengthLimitingTextInputFormatter(14), // +91 + 10 digits
          //         ],
          //         style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          //           color: AppTheme.lightTheme.colorScheme.onSurface,
          //           fontWeight: FontWeight.w500,
          //           letterSpacing: 1.5,
          //         ),
          //         decoration: InputDecoration(
          //           hintText: ' 98765 43210',
          //           hintStyle:
          //               AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          //             color: AppTheme.lightTheme.colorScheme.onSurface
          //                 .withValues(alpha: 0.4),
          //             fontWeight: FontWeight.w400,
          //             letterSpacing: 1.5,
          //           ),
          //           border: InputBorder.none,
          //           contentPadding:
          //               EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          //         ),
          //         onChanged: onChanged,
          //         readOnly: true, // Make read-only since we're using number pad
          //       ),
          //     ),
          //
          //     // Clear Button
          //     if (controller.text.length > 4)
          //       Padding(
          //         padding: EdgeInsets.only(right: 3.w),
          //         child: GestureDetector(
          //           onTap: () {
          //             controller.text = '+91 ';
          //             onChanged?.call(controller.text);
          //           },
          //           child: Container(
          //             padding: EdgeInsets.all(2.w),
          //             decoration: BoxDecoration(
          //               color: AppTheme.lightTheme.colorScheme.error
          //                   .withValues(alpha: 0.1),
          //               shape: BoxShape.circle,
          //             ),
          //             child: CustomIconWidget(
          //               iconName: 'clear',
          //               color: AppTheme.lightTheme.colorScheme.error,
          //               size: 4.w,
          //             ),
          //           ),
          //         ),
          //       ),
          //   ],
          // ),
        ),

        SizedBox(height: 2.h),

        // Helper Text
        Row(
          children: [
            CustomIconWidget(
              iconName: 'info_outline',
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.7),
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                'We\'ll send a 6-digit verification code to this number',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
      ],
    );
  }
}
