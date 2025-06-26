import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CommunityStatsCardWidget extends StatelessWidget {
  final int totalFamilies;
  final int recentJoiners;
  final int upcomingEvents;

  const CommunityStatsCardWidget({
    super.key,
    required this.totalFamilies,
    required this.recentJoiners,
    required this.upcomingEvents,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'groups',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 28,
              ),
              SizedBox(width: 3.w),
              Text(
                "Community Overview",
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  title: "Total Families",
                  value: totalFamilies.toString(),
                  icon: "home",
                ),
              ),
              Container(
                width: 1,
                height: 8.h,
                color: AppTheme.lightTheme.colorScheme.onPrimary
                    .withValues(alpha: 0.3),
              ),
              Expanded(
                child: _buildStatItem(
                  title: "New Joiners",
                  value: recentJoiners.toString(),
                  icon: "person_add",
                ),
              ),
              Container(
                width: 1,
                height: 8.h,
                color: AppTheme.lightTheme.colorScheme.onPrimary
                    .withValues(alpha: 0.3),
              ),
              Expanded(
                child: _buildStatItem(
                  title: "Upcoming Events",
                  value: upcomingEvents.toString(),
                  icon: "event",
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 1.5.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onPrimary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'trending_up',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  "Community growing by 15% this month",
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String title,
    required String value,
    required String icon,
  }) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: icon,
          color:
              AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.8),
          size: 24,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary
                .withValues(alpha: 0.8),
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
