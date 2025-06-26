import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NumberPadWidget extends StatelessWidget {
  final Function(String) onNumberTap;
  final bool isEnabled;

  const NumberPadWidget({
    super.key,
    required this.onNumberTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Title
          Padding(
            padding: EdgeInsets.only(bottom: 3.h),
            child: Text(
              'Enter Number',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Number Grid
          ...List.generate(4, (rowIndex) {
            return Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _buildRowButtons(rowIndex),
              ),
            );
          }),
        ],
      ),
    );
  }

  List<Widget> _buildRowButtons(int rowIndex) {
    switch (rowIndex) {
      case 0:
        return ['1', '2', '3']
            .map((number) => _buildNumberButton(number))
            .toList();
      case 1:
        return ['4', '5', '6']
            .map((number) => _buildNumberButton(number))
            .toList();
      case 2:
        return ['7', '8', '9']
            .map((number) => _buildNumberButton(number))
            .toList();
      case 3:
        return [
          _buildEmptyButton(),
          _buildNumberButton('0'),
          _buildBackspaceButton(),
        ];
      default:
        return [];
    }
  }

  Widget _buildNumberButton(String number) {
    return GestureDetector(
      onTap: isEnabled
          ? () {
              HapticFeedback.lightImpact();
              onNumberTap(number);
            }
          : null,
      child: Container(
        width: 20.w,
        height: 20.w,
        decoration: BoxDecoration(
          color: isEnabled
              ? AppTheme.lightTheme.colorScheme.surface
              : AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow
                        .withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            number,
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              color: isEnabled
                  ? AppTheme.lightTheme.colorScheme.onSurface
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.3),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return GestureDetector(
      onTap: isEnabled
          ? () {
              HapticFeedback.lightImpact();
              onNumberTap('backspace');
            }
          : null,
      child: Container(
        width: 20.w,
        height: 20.w,
        decoration: BoxDecoration(
          color: isEnabled
              ? AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isEnabled
                ? AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3)
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow
                        .withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: 'backspace',
            color: isEnabled
                ? AppTheme.lightTheme.colorScheme.error
                : AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.3),
            size: 6.w,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyButton() {
    return SizedBox(
      width: 20.w,
      height: 20.w,
    );
  }
}
