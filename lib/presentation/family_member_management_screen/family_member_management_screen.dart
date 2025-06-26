import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_member_modal_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/family_head_summary_widget.dart';
import './widgets/family_member_card_widget.dart';

class FamilyMemberManagementScreen extends StatelessWidget {
  const FamilyMemberManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FamilyController familyController = Get.find<FamilyController>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Family Management'),
          leading: IconButton(
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
              size: 24,
            ),
            onPressed: () => Get.back(),
          ),
          bottom: TabBar(
            unselectedLabelColor: AppTheme.lightTheme.colorScheme.onSurface,
            unselectedLabelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(fontSize: 10.sp),
            labelColor: AppTheme.lightTheme.colorScheme.onPrimary,
            labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(fontSize: 10.sp),
            tabs: [
              Tab(text: 'Family Members'),
              Tab(text: 'Family Tree'),
              Tab(text: 'Settings'),
            ],
          ),
        ),
        body: SafeArea(
          child: Obx(() => TabBarView(
                children: [
                  // Family Members Tab
                  familyController.familyMembers.isEmpty
                      ? EmptyStateWidget(onAddMember: _showAddMemberModal)
                      : Column(
                          children: [
                            // Family Head Summary
                            if (familyController.familyHead.value != null)
                              FamilyHeadSummaryWidget(
                                familyHead: _convertFamilyHeadToMap(
                                    familyController.familyHead.value!),
                                memberCount:
                                    familyController.familyMembers.length,
                              ),

                            // Family Members List
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 4.w, vertical: 1.h),
                                itemCount:
                                    familyController.familyMembers.length,
                                itemBuilder: (context, index) {
                                  final member =
                                      familyController.familyMembers[index];
                                  return FamilyMemberCardWidget(
                                    member: _convertMemberToMap(member),
                                    onEdit: () => _editMember(member.id),
                                    onDelete: () => _deleteMember(member.id),
                                    onLongPress: () =>
                                        _showMemberOptions(member.id),
                                    onTap: () {
                                      Get.snackbar(
                                        'Profile',
                                        'Navigate to ${member.firstName}\'s profile',
                                        snackPosition: SnackPosition.TOP,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                  // Family Tree Tab
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'account_tree',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 64,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Family Tree View',
                          style: AppTheme.lightTheme.textTheme.headlineSmall,
                        ),
                        SizedBox(height: 1.h),
                        ElevatedButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.interactiveFamilyTreeScreen);
                          },
                          child: Text('View Interactive Tree'),
                        ),
                      ],
                    ),
                  ),

                  // Settings Tab
                  ListView(
                    padding: EdgeInsets.all(4.w),
                    children: [
                      ListTile(
                        leading: CustomIconWidget(
                          iconName: 'edit',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 24,
                        ),
                        title: Text('Edit Family Head Profile'),
                        trailing: CustomIconWidget(
                          iconName: 'arrow_forward_ios',
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          size: 16,
                        ),
                        onTap: () {
                          Get.toNamed(AppRoutes.familyHeadRegistrationScreen);
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: CustomIconWidget(
                          iconName: 'download',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 24,
                        ),
                        title: Text('Export Family Tree (PDF)'),
                        trailing: CustomIconWidget(
                          iconName: 'arrow_forward_ios',
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          size: 16,
                        ),
                        onTap: () async {
                          final treeController =
                              Get.put(FamilyTreeController());
                          await treeController.exportToPDF();
                        },
                      ),
                      ListTile(
                        leading: CustomIconWidget(
                          iconName: 'image',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 24,
                        ),
                        title: Text('Export Family Tree (Image)'),
                        trailing: CustomIconWidget(
                          iconName: 'arrow_forward_ios',
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          size: 16,
                        ),
                        onTap: () async {
                          final treeController =
                              Get.put(FamilyTreeController());
                          await treeController.exportToImage();
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: CustomIconWidget(
                          iconName: 'dashboard',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 24,
                        ),
                        title: Text('Go to Dashboard'),
                        trailing: CustomIconWidget(
                          iconName: 'arrow_forward_ios',
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          size: 16,
                        ),
                        onTap: () {
                          Get.toNamed(AppRoutes.dashboardScreen);
                        },
                      ),
                    ],
                  ),
                ],
              )),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddMemberModal,
          tooltip: 'Add Family Member',
          child: CustomIconWidget(
            iconName: 'add',
            color:
                AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor!,
            size: 24,
          ),
        ),
      ),
    );
  }

  void _showAddMemberModal() {
    Get.bottomSheet(
      AddMemberModalWidget(
        onMemberAdded: (memberData) {
          final familyController = Get.find<FamilyController>();
          familyController.addFamilyMember(memberData);
        },
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  void _editMember(String memberId) {
    final familyController = Get.find<FamilyController>();
    final member =
        familyController.familyMembers.firstWhere((m) => m.id == memberId);

    Get.bottomSheet(
      AddMemberModalWidget(
        memberData: _convertMemberToMap(member),
        isEditing: true,
        onMemberAdded: (updatedData) {
          familyController.updateFamilyMember(memberId, updatedData);
        },
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  void _deleteMember(String memberId) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Delete Family Member',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Text(
          'Are you sure you want to delete this family member? This action cannot be undone.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final familyController = Get.find<FamilyController>();
              familyController.deleteFamilyMember(memberId);
              Get.back();
              Get.snackbar(
                'Success',
                'Family member deleted successfully',
                snackPosition: SnackPosition.TOP,
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showMemberOptions(String memberId) {
    final familyController = Get.find<FamilyController>();
    final member =
        familyController.familyMembers.firstWhere((m) => m.id == memberId);

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'emergency',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Set as Emergency Contact'),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Emergency Contact',
                  'Set as emergency contact',
                  snackPosition: SnackPosition.TOP,
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('View Full Profile'),
              onTap: () {
                Get.back();
                // Navigate to detailed profile
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Share Details'),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Share',
                  'Share functionality',
                  snackPosition: SnackPosition.TOP,
                );
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _convertFamilyHeadToMap(familyHead) {
    return {
      'id': familyHead.id,
      'name': familyHead.fullName,
      'age': familyHead.age,
      'gender': familyHead.gender,
      'maritalStatus': familyHead.maritalStatus,
      'occupation': familyHead.occupation,
      'samaj': familyHead.samaj,
      'qualification': familyHead.qualification,
      'phone': familyHead.phone,
      'email': familyHead.email,
      'address': familyHead.address,
      'profilePhoto': familyHead.profilePhoto,
    };
  }

  Map<String, dynamic> _convertMemberToMap(member) {
    return {
      'id': member.id,
      'firstName': member.firstName,
      'middleName': member.middleName,
      'lastName': member.lastName,
      'age': member.age,
      'gender': member.gender,
      'maritalStatus': member.maritalStatus,
      'relationship': member.relationship,
      'occupation': member.occupation,
      'qualification': member.qualification,
      'phone': member.phone,
      'email': member.email,
      'bloodGroup': member.bloodGroup,
      'profilePhoto': member.profilePhoto,
    };
  }
}
