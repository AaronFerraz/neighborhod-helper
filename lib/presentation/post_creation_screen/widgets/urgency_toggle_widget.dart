import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UrgencyToggleWidget extends StatelessWidget {
  final bool isUrgent;
  final Function(bool) onUrgencyChanged;
  final String postType;

  const UrgencyToggleWidget({
    Key? key,
    required this.isUrgent,
    required this.onUrgencyChanged,
    required this.postType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (postType != 'Ajuda') {
      return SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isUrgent
              ? AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUrgent
                ? AppTheme.lightTheme.colorScheme.error
                : AppTheme.lightTheme.colorScheme.outline,
            width: isUrgent ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'priority_high',
              color: isUrgent
                  ? AppTheme.lightTheme.colorScheme.error
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pedido Urgente',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: isUrgent
                          ? AppTheme.lightTheme.colorScheme.error
                          : AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    isUrgent
                        ? 'Vizinhos receberão notificação push imediata'
                        : 'Marque se precisar de ajuda com urgência',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: isUrgent
                          ? AppTheme.lightTheme.colorScheme.error
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: isUrgent,
              onChanged: onUrgencyChanged,
              activeColor: AppTheme.lightTheme.colorScheme.error,
              activeTrackColor:
                  AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}