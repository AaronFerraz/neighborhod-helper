import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EngagementMetricsWidget extends StatelessWidget {
  final int helpOffered;
  final int helpReceived;
  final int recommendationsMade;
  final VoidCallback onHelpOfferedTap;
  final VoidCallback onHelpReceivedTap;
  final VoidCallback onRecommendationsTap;

  const EngagementMetricsWidget({
    Key? key,
    required this.helpOffered,
    required this.helpReceived,
    required this.recommendationsMade,
    required this.onHelpOfferedTap,
    required this.onHelpReceivedTap,
    required this.onRecommendationsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Minha Atividade',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'Ajudas\nOferecidas',
                  value: helpOffered.toString(),
                  icon: 'volunteer_activism',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  onTap: onHelpOfferedTap,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildMetricCard(
                  title: 'Ajudas\nRecebidas',
                  value: helpReceived.toString(),
                  icon: 'favorite',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  onTap: onHelpReceivedTap,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.w),
          _buildMetricCard(
            title: 'Recomendações Feitas',
            value: recommendationsMade.toString(),
            icon: 'thumb_up',
            color: AppTheme.lightTheme.colorScheme.tertiary,
            onTap: onRecommendationsTap,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String icon,
    required Color color,
    required VoidCallback onTap,
    bool isFullWidth = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isFullWidth ? double.infinity : null,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: isFullWidth
            ? Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                    child: CustomIconWidget(
                      iconName: icon,
                      color: color,
                      size: 6.w,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          value,
                          style: AppTheme.lightTheme.textTheme.headlineMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                        Text(
                          title,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 4.w,
                  ),
                ],
              )
            : Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                    child: CustomIconWidget(
                      iconName: icon,
                      color: color,
                      size: 6.w,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    value,
                    style:
                        AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }
}