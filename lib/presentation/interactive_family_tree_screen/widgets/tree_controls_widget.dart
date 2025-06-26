import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TreeControlsWidget extends StatelessWidget {
  final double currentZoom;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onReset;

  const TreeControlsWidget({
    super.key,
    required this.currentZoom,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(blurRadius: 8, offset: Offset(0, 2)),
            ]),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Zoom In
          _buildControlButton(
              icon: 'zoom_in', onPressed: currentZoom < 3.0 ? onZoomIn : null),

          Divider(height: 1, color: AppTheme.lightTheme.dividerColor),

          // Zoom Out
          _buildControlButton(
              icon: 'zoom_out',
              onPressed: currentZoom > 0.5 ? onZoomOut : null),

          Divider(height: 1, color: AppTheme.lightTheme.dividerColor),

          // Reset Zoom
          _buildControlButton(icon: 'center_focus_strong', onPressed: onReset),
        ]));
  }

  Widget _buildControlButton({
    required String icon,
    required VoidCallback? onPressed,
  }) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
                width: 12.w,
                height: 6.h,
                child: Center(
                    child: CustomIconWidget(
                        iconName: icon,
                        color: onPressed != null
                            ? AppTheme.lightTheme.colorScheme.onSurface
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.3),
                        size: 24)))));
  }
}
