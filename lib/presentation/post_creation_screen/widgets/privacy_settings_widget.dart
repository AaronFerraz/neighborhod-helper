import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PrivacySettingsWidget extends StatelessWidget {
  final String selectedPrivacy;
  final Function(String) onPrivacyChanged;

  const PrivacySettingsWidget({
    Key? key,
    required this.selectedPrivacy,
    required this.onPrivacyChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final privacyOptions = [
      {
        'value': 'community',
        'title': 'Toda a Comunidade',
        'subtitle': 'Visível para todos os vizinhos verificados',
        'icon': 'groups',
      },
      {
        'value': 'building',
        'title': 'Apenas Meu Prédio',
        'subtitle': 'Visível apenas para moradores do mesmo prédio',
        'icon': 'apartment',
      },
      {
        'value': 'floor',
        'title': 'Apenas Meu Andar',
        'subtitle': 'Visível apenas para vizinhos do mesmo andar',
        'icon': 'layers',
      },
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Privacidade',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.h),
          ...privacyOptions.map((option) {
            final isSelected = selectedPrivacy == option['value'];

            return GestureDetector(
              onTap: () => onPrivacyChanged(option['value'] as String),
              child: Container(
                margin: EdgeInsets.only(bottom: 2.h),
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: option['icon'] as String,
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            option['title'] as String,
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            option['subtitle'] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Radio<String>(
                      value: option['value'] as String,
                      groupValue: selectedPrivacy,
                      onChanged: (value) => onPrivacyChanged(value!),
                      activeColor: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}