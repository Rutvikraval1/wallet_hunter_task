import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExportOptionsWidget extends StatelessWidget {
  final VoidCallback onExportPDF;
  final VoidCallback onExportImage;
  final VoidCallback onClose;

  const ExportOptionsWidget({
    super.key,
    required this.onExportPDF,
    required this.onExportImage,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(blurRadius: 12, offset: Offset(0, 4)),
            ]),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Header
          Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: AppTheme.lightTheme.dividerColor, width: 1))),
              child: Row(children: [
                CustomIconWidget(
                    iconName: 'share',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 20),
                SizedBox(width: 2.w),
                Text('Export Options',
                    style: AppTheme.lightTheme.textTheme.titleMedium),
                Spacer(),
                IconButton(
                    onPressed: onClose,
                    icon: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 20),
                    constraints: BoxConstraints(minWidth: 8.w, minHeight: 4.h)),
              ])),

          // Export options
          Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(children: [
                _buildExportOption(
                    icon: 'picture_as_pdf',
                    title: 'Export as PDF',
                    subtitle: 'Share via WhatsApp or email',
                    onTap: onExportPDF),
                SizedBox(height: 2.h),
                _buildExportOption(
                    icon: 'image',
                    title: 'Export as Image',
                    subtitle: 'Save to gallery or share on social media',
                    onTap: onExportImage),
              ])),
        ]));
  }

  Widget _buildExportOption({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
                border: Border.all(
                    color: AppTheme.lightTheme.dividerColor, width: 1),
                borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Container(
                  width: 12.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                      child: CustomIconWidget(
                          iconName: icon,
                          color: AppTheme.lightTheme.primaryColor,
                          size: 24))),
              SizedBox(width: 4.w),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(title,
                        style: AppTheme.lightTheme.textTheme.titleSmall),
                    SizedBox(height: 0.5.h),
                    Text(subtitle,
                        style: AppTheme.lightTheme.textTheme.bodySmall
                            ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.7))),
                  ])),
              CustomIconWidget(
                  iconName: 'arrow_forward_ios',
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.5),
                  size: 16),
            ])));
  }
}
