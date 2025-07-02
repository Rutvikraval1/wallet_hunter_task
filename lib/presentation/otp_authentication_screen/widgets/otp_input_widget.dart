import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OtpInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  const OtpInputWidget({
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
          'Verification Code',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),

        // OTP Input Boxes
        OTPFields(onCompleted: (value){onChanged!(value);}),
        SizedBox(height: 3.h),

        // Helper Text
        Row(
          children: [
            CustomIconWidget(
              iconName: 'sms',
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.7),
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                'Enter the 6-digit code sent to your mobile number',
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

class OTPFields extends StatefulWidget {
  final void Function(String otp) onCompleted;

  const OTPFields({super.key, required this.onCompleted});

  @override
  State<OTPFields> createState() => _OTPFieldsState();
}

class _OTPFieldsState extends State<OTPFields> {
  final List<FocusNode> _focusNodes =
  List.generate(6, (_) => FocusNode(), growable: false);
  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController(), growable: false);

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    final otp = _controllers.map((c) => c.text).join();
    if (otp.length == 6) {
      widget.onCompleted(otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 45,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            decoration: const InputDecoration(
              counterText: '',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => _onChanged(value, index),
          ),
        );
      }),
    );
  }
}

