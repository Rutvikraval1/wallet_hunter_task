import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/export_options_widget.dart';
import './widgets/family_tree_node_widget.dart';
import './widgets/member_details_sheet_widget.dart';
import './widgets/tree_controls_widget.dart';

class InteractiveFamilyTreeScreen extends StatelessWidget {
  const InteractiveFamilyTreeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FamilyTreeController controller = Get.put(FamilyTreeController());
    final TransformationController transformationController =
        TransformationController();

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Family Tree'),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
            size: 24,
          ),
        ),
        actions: [
          Obx(() => IconButton(
                onPressed: controller.isExporting.value
                    ? null
                    : controller.toggleExportOptions,
                icon: controller.isExporting.value
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : CustomIconWidget(
                        iconName: 'share',
                        color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
                        size: 24,
                      ),
              )),
          IconButton(
            onPressed: () =>
                Get.toNamed(AppRoutes.familyMemberManagementScreen),
            icon: CustomIconWidget(
              iconName: 'group_add',
              color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
              size: 24,
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingSkeleton();
        }

        if (controller.treeData.isEmpty) {
          return _buildEmptyState();
        }

        return Stack(
          children: [
            RepaintBoundary(
              key: controller.familyTreeKey,
              child: InteractiveViewer(
                transformationController: transformationController,
                minScale: 0.5,
                maxScale: 3.0,
                constrained: false,
                onInteractionUpdate: (details) {
                  controller.updateZoom(
                      transformationController.value.getMaxScaleOnAxis());
                },
                child: SizedBox(
                  width: 100.w,
                  height: 100.h,
                  child: CustomPaint(
                    painter: FamilyTreePainter(
                      members: controller.treeData,
                      selectedMemberId: controller.selectedMemberId.value,
                    ),
                    child: Stack(
                      children: controller.treeData.map((member) {
                        final position =
                            member['position'] as Map<String, dynamic>;
                        return Positioned(
                          left: (010.w + (position['x'] as double)),
                          top: (05.h + (position['y'] as double)),
                          child: FamilyTreeNodeWidget(
                            member: member,
                            isSelected: controller.selectedMemberId.value ==
                                (member['id'] as String),
                            onTap: () {
                              HapticFeedback.lightImpact();
                              controller.selectMember(member['id'] as String);
                              _showMemberDetails(context, member);
                            },
                            onLongPress: () {
                              HapticFeedback.mediumImpact();
                              _showContextMenu(context, member);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),

            // Tree Controls
            Positioned(
              right: 4.w,
              bottom: 20.h,
              child: TreeControlsWidget(
                currentZoom: controller.currentZoom.value,
                onZoomIn: () {
                  final currentMatrix = transformationController.value;
                  final newMatrix =
                      currentMatrix * Matrix4.diagonal3Values(1.2, 1.2, 1.0);
                  transformationController.value = newMatrix;
                  controller.updateZoom(
                      transformationController.value.getMaxScaleOnAxis());
                },
                onZoomOut: () {
                  final currentMatrix = transformationController.value;
                  final newMatrix =
                      currentMatrix * Matrix4.diagonal3Values(0.8, 0.8, 1.0);
                  transformationController.value = newMatrix;
                  controller.updateZoom(
                      transformationController.value.getMaxScaleOnAxis());
                },
                onReset: () {
                  transformationController.value = Matrix4.identity();
                  controller.updateZoom(1.0);
                },
              ),
            ),

            // Export Options
            if (controller.showExportOptions.value)
              Positioned(
                top: kToolbarHeight + MediaQuery.of(context).padding.top,
                right: 0,
                child: ExportOptionsWidget(
                  onExportPDF: controller.exportToPDF,
                  onExportImage: controller.exportToImage,
                  onClose: controller.toggleExportOptions,
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.lightTheme.scaffoldBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'account_tree',
            color: AppTheme.lightTheme.primaryColor,
            size: 48,
          ),
          SizedBox(height: 3.h),
          Text(
            'Building Family Tree...',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),
          LinearProgressIndicator(
            backgroundColor:
                AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
            valueColor:
                AlwaysStoppedAnimation<Color>(AppTheme.lightTheme.primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'family_restroom',
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.5),
            size: 80,
          ),
          SizedBox(height: 3.h),
          Text(
            'No Family Members Yet',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Start building your family tree by adding family members',
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 4.h),
          ElevatedButton.icon(
            onPressed: () =>
                Get.toNamed(AppRoutes.familyMemberManagementScreen),
            icon: CustomIconWidget(
              iconName: 'group_add',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 20,
            ),
            label: Text('Add Family Members'),
          ),
        ],
      ),
    );
  }

  void _showMemberDetails(BuildContext context, Map<String, dynamic> member) {
    Get.bottomSheet(
      MemberDetailsSheetWidget(
        member: member,
        onEdit: () => _editMember(member['id'] as String),
        onAddRelative: () => _addRelative(member['id'] as String),
        onRemove: () => _removeMember(member['id'] as String),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  void _showContextMenu(BuildContext context, Map<String, dynamic> member) {
    Get.bottomSheet(
      Container(
        margin: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  Text(
                    "${member['firstName']} ${member['lastName']}",
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 2.h),
                  _buildContextMenuItem(
                    icon: 'person',
                    title: 'View Profile',
                    onTap: () {
                      Get.back();
                      _showMemberDetails(context, member);
                    },
                  ),
                  _buildContextMenuItem(
                    icon: 'edit',
                    title: 'Edit Member',
                    onTap: () {
                      Get.back();
                      _editMember(member['id'] as String);
                    },
                  ),
                  _buildContextMenuItem(
                    icon: 'group_add',
                    title: 'Add Relative',
                    onTap: () {
                      Get.back();
                      _addRelative(member['id'] as String);
                    },
                  ),
                  _buildContextMenuItem(
                    icon: 'delete',
                    title: 'Remove from Tree',
                    isDestructive: true,
                    onTap: () {
                      Get.back();
                      _removeMember(member['id'] as String);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isDestructive
                  ? AppTheme.lightTheme.colorScheme.error
                  : AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            SizedBox(width: 4.w),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: isDestructive
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editMember(String memberId) {
    Get.toNamed(AppRoutes.familyMemberManagementScreen);
  }

  void _addRelative(String memberId) {
    Get.toNamed(AppRoutes.familyMemberManagementScreen);
  }

  void _removeMember(String memberId) {
    Get.dialog(
      AlertDialog(
        title: Text('Remove Member'),
        content: Text(
            'Are you sure you want to remove this member from the family tree?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              final FamilyTreeController controller =
                  Get.find<FamilyTreeController>();
              final familyController = Get.find<FamilyController>();
              familyController.deleteFamilyMember(memberId);
              Get.snackbar(
                'Success',
                'Member removed from family tree',
                snackPosition: SnackPosition.TOP,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Remove'),
          ),
        ],
      ),
    );
  }
}

class FamilyTreePainter extends CustomPainter {
  final List<Map<String, dynamic>> members;
  final String selectedMemberId;

  FamilyTreePainter({
    required this.members,
    required this.selectedMemberId,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.lightTheme.dividerColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final highlightPaint = Paint()
      ..color = AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3)
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    // Draw connection lines between family members
    for (final member in members) {
      final parentId = member['parentId'] as String?;
      if (parentId != null) {
        final parent = members.firstWhere(
          (m) => (m['id'] as String) == parentId,
          orElse: () => <String, dynamic>{},
        );

        if (parent.isNotEmpty) {
          final memberPos = member['position'] as Map<String, dynamic>;
          final parentPos = parent['position'] as Map<String, dynamic>;

          final startX = size.width / 2 + (parentPos['x'] as double) + 30;
          final startY = size.height * 0.4 + (parentPos['y'] as double) + 30;
          final endX = size.width / 2 + (memberPos['x'] as double) + 30;
          final endY = size.height * 0.4 + (memberPos['y'] as double) + 30;

          final isHighlighted = selectedMemberId == (member['id'] as String) ||
              selectedMemberId == parentId;

          canvas.drawLine(
            Offset(startX, startY),
            Offset(endX, endY),
            isHighlighted ? highlightPaint : paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
