import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/community_stats_card_widget.dart';
import './widgets/family_overview_card_widget.dart';
import './widgets/quick_action_button_widget.dart';
import './widgets/recent_activity_item_widget.dart';
import './widgets/temple_association_card_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final AuthController authController = Get.find<AuthController>();
  bool _isRefreshing = false;

  // Mock data for dashboard
  final Map<String, dynamic> familyHeadData = {
    "name": "Rajesh Kumar Sharma",
    "samaj": "Brahmin Samaj",
    "totalMembers": 6,
    "completionPercentage": 85,
    "associatedTemple": "Shri Ram Mandir",
    "templeLocation": "Sector 15, Noida",
    "profileImage":
        "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
  };

  final List<Map<String, dynamic>> recentActivities = [
    {
      "title": "New member added",
      "description": "Priya Sharma joined the family",
      "timestamp": "2 hours ago",
      "type": "member_added",
      "icon": "person_add"
    },
    {
      "title": "Profile updated",
      "description": "Contact information updated",
      "timestamp": "1 day ago",
      "type": "profile_update",
      "icon": "edit"
    },
    {
      "title": "Temple event",
      "description": "Upcoming Diwali celebration at temple",
      "timestamp": "3 days ago",
      "type": "temple_event",
      "icon": "event"
    },
    {
      "title": "Family tree exported",
      "description": "PDF generated successfully",
      "timestamp": "1 week ago",
      "type": "export",
      "icon": "download"
    }
  ];

  final Map<String, dynamic> communityStats = {
    "totalFamilies": 1247,
    "recentJoiners": 23,
    "upcomingEvents": 5
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildAppBar(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildHomeTab(),
                _buildFamilyTab(),
                _buildTempleTab(),
                _buildProfileTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 20,),
          Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl: familyHeadData["profileImage"] as String,
                    width: 12.w,
                    height: 12.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back,",
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary
                            .withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      familyHeadData["name"] as String,
                      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      familyHeadData["samaj"] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary
                            .withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              CustomIconWidget(
                iconName: 'notifications',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: false, // ensures tabs divide space equally
        indicator: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorPadding: EdgeInsets.symmetric(horizontal: -8,vertical: 6),
        labelColor: AppTheme.lightTheme.colorScheme.onPrimary,
        unselectedLabelColor: AppTheme.lightTheme.colorScheme.onSurface,
        labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(fontSize: 11.sp),
        unselectedLabelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(fontSize: 11.sp),
        tabs: [
          _buildResponsiveTab('home', "Home", 0),
          _buildResponsiveTab('people', "Family", 1),
          _buildResponsiveTab('temple_hindu', "Temple", 2),
          _buildResponsiveTab('person', "Profile", 3),
        ],
      ),
    );
  }

  Widget _buildResponsiveTab(String icon, String label, int index) {
    final isSelected = _tabController.index == index;

    return Tab(
      child: FittedBox( // Prevents overflow by scaling content
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.onPrimary
                  : AppTheme.lightTheme.colorScheme.onSurface,
              size: 16.sp,
            ),
            SizedBox(width: 1.w),
            Text(
              label,
              style: TextStyle(fontSize: 11.sp),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildHomeTab() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFamilyOverviewSection(),
            SizedBox(height: 3.h),
            _buildQuickActionsSection(),
            SizedBox(height: 3.h),
            _buildRecentActivitySection(),
            SizedBox(height: 3.h),
            _buildCommunityStatsSection(),
            SizedBox(height: 10.h), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'people',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            "Family Management",
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            "Manage your family members here",
            style: AppTheme.lightTheme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/family-member-management-screen');
            },
            child: Text("Manage Family"),
          ),
        ],
      ),
    );
  }

  Widget _buildTempleTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Temple Association",
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 2.h),
          TempleAssociationCardWidget(
            templeName: familyHeadData["associatedTemple"] as String,
            location: familyHeadData["templeLocation"] as String,
            samaj: familyHeadData["samaj"] as String,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary,
                width: 3,
              ),
            ),
            child: ClipOval(
              child: CustomImageWidget(
                imageUrl: familyHeadData["profileImage"] as String,
                width: 24.w,
                height: 24.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            familyHeadData["name"] as String,
            style: AppTheme.lightTheme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            familyHeadData["samaj"] as String,
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () {
              authController.logout();
            },
            child: Text("Logout"),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyOverviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Family Overview",
          style: AppTheme.lightTheme.textTheme.headlineSmall,
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: FamilyOverviewCardWidget(
                title: "Total Members",
                value: familyHeadData["totalMembers"].toString(),
                icon: "people",
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: FamilyOverviewCardWidget(
                title: "Completion",
                value: "${familyHeadData["completionPercentage"]}%",
                icon: "check_circle",
                color: AppTheme.successLight,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: AppTheme.lightTheme.textTheme.headlineSmall,
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: QuickActionButtonWidget(
                title: "Add Member",
                icon: "person_add",
                onTap: () {
                  Navigator.pushNamed(
                      context, '/family-member-management-screen');
                },
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: QuickActionButtonWidget(
                title: "Family Tree",
                icon: "account_tree",
                onTap: () {
                  Navigator.pushNamed(
                      context, '/interactive-family-tree-screen');
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: QuickActionButtonWidget(
                title: "Edit Profile",
                icon: "edit",
                onTap: () {
                  Navigator.pushNamed(
                      context, '/family-head-registration-screen');
                },
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: QuickActionButtonWidget(
                title: "Export Data",
                icon: "download",
                onTap: () {
                  _showExportDialog();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Activity",
              style: AppTheme.lightTheme.textTheme.headlineSmall,
            ),
            TextButton(
              onPressed: () {
                // Navigate to full activity log
              },
              child: Text("View All"),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentActivities.length > 3 ? 3 : recentActivities.length,
          separatorBuilder: (context, index) => SizedBox(height: 1.h),
          itemBuilder: (context, index) {
            final activity = recentActivities[index];
            return RecentActivityItemWidget(
              title: activity["title"] as String,
              description: activity["description"] as String,
              timestamp: activity["timestamp"] as String,
              icon: activity["icon"] as String,
            );
          },
        ),
      ],
    );
  }

  Widget _buildCommunityStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Community Statistics",
          style: AppTheme.lightTheme.textTheme.headlineSmall,
        ),
        SizedBox(height: 2.h),
        CommunityStatsCardWidget(
          totalFamilies: communityStats["totalFamilies"] as int,
          recentJoiners: communityStats["recentJoiners"] as int,
          upcomingEvents: communityStats["upcomingEvents"] as int,
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.pushNamed(context, '/family-member-management-screen');
      },
      backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      foregroundColor: AppTheme.lightTheme.colorScheme.onTertiary,
      icon: CustomIconWidget(
        iconName: 'person_add',
        color: AppTheme.lightTheme.colorScheme.onTertiary,
        size: 24,
      ),
      label: Text(
        "Add Member",
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onTertiary,
        ),
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Export Family Data"),
          content: Text("Choose export format:"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _exportAsPDF();
              },
              child: Text("PDF"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _exportAsImage();
              },
              child: Text("Image"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _exportAsPDF() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Exporting family data as PDF..."),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _exportAsImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Exporting family tree as image..."),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }
}
