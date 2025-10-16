import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AlertCardWidget extends StatelessWidget {
  final Map<String, dynamic> alert;
  final VoidCallback? onActionPressed;
  final VoidCallback? onSecondaryActionPressed;
  final VoidCallback? onMarkAsRead;

  const AlertCardWidget({
    Key? key,
    required this.alert,
    this.onActionPressed,
    this.onSecondaryActionPressed,
    this.onMarkAsRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alertType = alert['type'] as String? ?? 'maintenance';
    final isEmergency = alertType == 'emergency';
    final isSecurity = alertType == 'security';
    final isMaintenance = alertType == 'maintenance';

    Color borderColor = AppTheme.lightTheme.colorScheme.outline;
    Color backgroundColor = AppTheme.lightTheme.colorScheme.surface;

    if (isEmergency) {
      borderColor = AppTheme.lightTheme.colorScheme.error;
      backgroundColor =
          AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.05);
    } else if (isSecurity) {
      borderColor = const Color(0xFFFF9800);
      backgroundColor = const Color(0xFFFF9800).withValues(alpha: 0.05);
    } else if (isMaintenance) {
      borderColor = const Color(0xFFFFC107);
      backgroundColor = const Color(0xFFFFC107).withValues(alpha: 0.05);
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: borderColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: _getAlertIcon(alertType),
                    color: borderColor,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getAlertTypeLabel(alertType),
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: borderColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        _formatTimestamp(alert['timestamp']),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onMarkAsRead != null)
                  GestureDetector(
                    onTap: onMarkAsRead,
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      child: CustomIconWidget(
                        iconName: 'more_vert',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 2.h),
            if (alert['sender'] != null) ...[
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'person',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Enviado por: ${alert['sender']}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
            ],
            Text(
              alert['description'] as String? ?? '',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (alert['affectedAreas'] != null) ...[
              SizedBox(height: 1.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'location_on',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Áreas afetadas: ${alert['affectedAreas']}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            if (alert['estimatedResolution'] != null && isMaintenance) ...[
              SizedBox(height: 1.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'schedule',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Previsão: ${alert['estimatedResolution']}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: 2.h),
            Row(
              children: [
                if (isEmergency) ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onActionPressed,
                      icon: CustomIconWidget(
                        iconName: 'phone',
                        color: AppTheme.lightTheme.colorScheme.onError,
                        size: 18,
                      ),
                      label: Text(
                        'Ligar Emergência',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.lightTheme.colorScheme.error,
                        foregroundColor:
                            AppTheme.lightTheme.colorScheme.onError,
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      ),
                    ),
                  ),
                ] else if (isSecurity) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onActionPressed,
                      icon: CustomIconWidget(
                        iconName: 'visibility',
                        color: const Color(0xFFFF9800),
                        size: 16,
                      ),
                      label: Text(
                        'Marcar como Visto',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFFF9800),
                        side: const BorderSide(color: Color(0xFFFF9800)),
                        padding: EdgeInsets.symmetric(vertical: 1.2.h),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onSecondaryActionPressed,
                      icon: CustomIconWidget(
                        iconName: 'add_comment',
                        color: const Color(0xFFFF9800),
                        size: 16,
                      ),
                      label: Text(
                        'Adicionar Info',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFFF9800),
                        side: const BorderSide(color: Color(0xFFFF9800)),
                        padding: EdgeInsets.symmetric(vertical: 1.2.h),
                      ),
                    ),
                  ),
                ] else if (isMaintenance) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onActionPressed,
                      icon: CustomIconWidget(
                        iconName: 'info_outline',
                        color: const Color(0xFFFFC107),
                        size: 16,
                      ),
                      label: Text(
                        'Ver Detalhes',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFFFC107),
                        side: const BorderSide(color: Color(0xFFFFC107)),
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getAlertIcon(String type) {
    switch (type) {
      case 'emergency':
        return 'emergency';
      case 'security':
        return 'security';
      case 'maintenance':
        return 'build';
      default:
        return 'notification_important';
    }
  }

  String _getAlertTypeLabel(String type) {
    switch (type) {
      case 'emergency':
        return 'EMERGÊNCIA';
      case 'security':
        return 'SEGURANÇA';
      case 'maintenance':
        return 'MANUTENÇÃO';
      default:
        return 'ALERTA';
    }
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '';

    try {
      DateTime dateTime;
      if (timestamp is DateTime) {
        dateTime = timestamp;
      } else if (timestamp is String) {
        dateTime = DateTime.parse(timestamp);
      } else {
        return '';
      }

      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Agora mesmo';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}min atrás';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h atrás';
      } else {
        return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} às ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      }
    } catch (e) {
      return '';
    }
  }
}