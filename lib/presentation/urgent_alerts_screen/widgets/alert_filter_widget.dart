import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AlertFilterWidget extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const AlertFilterWidget({
    Key? key,
    required this.selectedFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filters = [
      {'key': 'all', 'label': 'Todos', 'icon': 'list'},
      {'key': 'emergency', 'label': 'Emergência', 'icon': 'emergency'},
      {'key': 'security', 'label': 'Segurança', 'icon': 'security'},
      {'key': 'maintenance', 'label': 'Manutenção', 'icon': 'build'},
    ];

    return Container(
      height: 12.h,
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter['key'];

          Color chipColor = AppTheme.lightTheme.colorScheme.surface;
          Color textColor = AppTheme.lightTheme.colorScheme.onSurface;
          Color iconColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant;

          if (isSelected) {
            switch (filter['key']) {
              case 'emergency':
                chipColor = AppTheme.lightTheme.colorScheme.error
                    .withValues(alpha: 0.1);
                textColor = AppTheme.lightTheme.colorScheme.error;
                iconColor = AppTheme.lightTheme.colorScheme.error;
                break;
              case 'security':
                chipColor = const Color(0xFFFF9800).withValues(alpha: 0.1);
                textColor = const Color(0xFFFF9800);
                iconColor = const Color(0xFFFF9800);
                break;
              case 'maintenance':
                chipColor = const Color(0xFFFFC107).withValues(alpha: 0.1);
                textColor = const Color(0xFFFFC107);
                iconColor = const Color(0xFFFFC107);
                break;
              default:
                chipColor = AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1);
                textColor = AppTheme.lightTheme.colorScheme.primary;
                iconColor = AppTheme.lightTheme.colorScheme.primary;
            }
          }

          return Container(
            margin: EdgeInsets.only(right: 3.w),
            child: FilterChip(
              selected: isSelected,
              onSelected: (selected) {
                onFilterChanged(filter['key'] as String);
              },
              backgroundColor: chipColor,
              selectedColor: chipColor,
              checkmarkColor: iconColor,
              side: BorderSide(
                color: isSelected
                    ? iconColor
                    : AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              avatar: CustomIconWidget(
                iconName: filter['icon'] as String,
                color: iconColor,
                size: 18,
              ),
              label: Text(
                filter['label'] as String,
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: textColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }
}