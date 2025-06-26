import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FamilyTreeNodeWidget extends StatelessWidget {
  final Map<String, dynamic> member;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const FamilyTreeNodeWidget({
    super.key,
    required this.member,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final generation = member["generation"] as int;
    final nodeSize =
        generation == 0 ? 60.0 : 50.0; // Family head gets larger node

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: nodeSize,
        // height: nodeSize + 40, // Extra space for name
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile photo container
            Container(
              width: nodeSize,
              height: nodeSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.dividerColor,
                  width: isSelected ? 3.0 : 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.primaryColor
                        .withValues(alpha: isSelected ? 0.3 : 0.1),
                    blurRadius: isSelected ? 8.0 : 4.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: CustomImageWidget(
                  imageUrl: member["profilePhoto"] as String? ?? "",
                  width: nodeSize,
                  height: nodeSize,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(height: 1.h),

            // Name label
            SizedBox(
              width: nodeSize + 20,
              child: Text(
                "${member["firstName"]} ${member["lastName"]}",
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  fontWeight:
                      generation == 0 ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ),

            // Relation indicator
            if (generation == 0)
              Container(
                margin: EdgeInsets.only(top: 0.5.h),
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.2.h),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Head",
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
