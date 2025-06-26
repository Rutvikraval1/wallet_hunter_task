import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MemberDetailsSheetWidget extends StatelessWidget {
  final Map<String, dynamic> member;
  final VoidCallback onEdit;
  final VoidCallback onAddRelative;
  final VoidCallback onRemove;

  const MemberDetailsSheetWidget({
    super.key,
    required this.member,
    required this.onEdit,
    required this.onAddRelative,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          SizedBox(height: 3.h),

          // Profile section
          _buildProfileSection(),

          SizedBox(height: 3.h),

          // Details section
          _buildDetailsSection(),

          SizedBox(height: 3.h),

          // Action buttons
          _buildActionButtons(context),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        // Profile photo
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.lightTheme.primaryColor,
              width: 3,
            ),
          ),
          child: ClipOval(
            child: CustomImageWidget(
              imageUrl: member["profilePhoto"] as String? ?? "",
              width: 20.w,
              height: 20.w,
              fit: BoxFit.cover,
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // Name
        Text(
          "${member["firstName"]} ${member["middleName"] != "" ? member["middleName"] + " " : ""}${member["lastName"]}",
          style: AppTheme.lightTheme.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 0.5.h),

        // Relation
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            member["relation"] as String,
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: AppTheme.lightTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        children: [
          _buildDetailRow('Age', '${member["age"]} years'),
          _buildDetailRow('Gender', member["gender"] as String),
          _buildDetailRow('Marital Status', member["maritalStatus"] as String),
          _buildDetailRow('Occupation', member["occupation"] as String),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        children: [
          // Edit and Add Relative buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    onEdit();
                  },
                  icon: CustomIconWidget(
                    iconName: 'edit',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 18,
                  ),
                  label: Text('Edit'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    onAddRelative();
                  },
                  icon: CustomIconWidget(
                    iconName: 'group_add',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 18,
                  ),
                  label: Text('Add Relative'),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Remove button
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                onRemove();
              },
              icon: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 18,
              ),
              label: Text(
                'Remove from Tree',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
