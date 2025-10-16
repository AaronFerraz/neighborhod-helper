import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PostTypeSelectorWidget extends StatelessWidget {
  final String selectedType;
  final Function(String) onTypeSelected;

  const PostTypeSelectorWidget({
    Key? key,
    required this.selectedType,
    required this.onTypeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final postTypes = [
      {
        'type': 'Ajuda',
        'icon': 'help_outline',
        'color': AppTheme.lightTheme.colorScheme.error
      },
      {
        'type': 'Serviço',
        'icon': 'work_outline',
        'color': AppTheme.lightTheme.colorScheme.primary
      },
      {
        'type': 'Doação',
        'icon': 'favorite_outline',
        'color': AppTheme.lightTheme.colorScheme.tertiary
      },
      {
        'type': 'Troca',
        'icon': 'swap_horiz',
        'color': AppTheme.lightTheme.colorScheme.secondary
      },
      {
        'type': 'Anúncio',
        'icon': 'campaign',
        'color': AppTheme.lightTheme.colorScheme.onSurfaceVariant
      },
    ];

    return Container(
      height: 12.h,
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: postTypes.length,
        separatorBuilder: (context, index) => SizedBox(width: 3.w),
        itemBuilder: (context, index) {
          final postType = postTypes[index];
          final isSelected = selectedType == postType['type'];

          return GestureDetector(
            onTap: () => onTypeSelected(postType['type'] as String),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? (postType['color'] as Color).withValues(alpha: 0.2)
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? (postType['color'] as Color)
                      : AppTheme.lightTheme.colorScheme.outline,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: postType['icon'] as String,
                    color: isSelected
                        ? (postType['color'] as Color)
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    postType['type'] as String,
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: isSelected
                          ? (postType['color'] as Color)
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}