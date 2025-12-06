import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AlertCardWidget extends StatelessWidget {
  final Map<String, dynamic> alert;
  final VoidCallback onActionPressed;
  final VoidCallback onSecondaryActionPressed;
  final VoidCallback onMarkAsRead;
  final Map<String, Color> typeColors; // Recebido do pai

  const AlertCardWidget({
    Key? key,
    required this.alert,
    required this.onActionPressed,
    required this.onSecondaryActionPressed,
    required this.onMarkAsRead,
    required this.typeColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alertType = alert['type'] as String;
    final isRead = alert['isRead'] as bool;
    final color = typeColors[alertType] ?? AppTheme.lightTheme.colorScheme.onSurfaceVariant; 
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isRead ? 0.05 : 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isRead ? AppTheme.lightTheme.colorScheme.outline : color.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: onMarkAsRead, 
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge de Tipo
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: color.withOpacity(0.5), width: 0.8),
                    ),
                    child: Text(
                      // CORREÇÃO: Usa a função de tradução
                      _getAlertTypeLabel(alertType), 
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Ícone de Ação Principal
                  IconButton(
                    onPressed: onActionPressed,
                    icon: CustomIconWidget(
                      iconName: _getPrimaryActionIcon(alertType),
                      color: color,
                      size: 5.w,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                  // Ícone Secundário
                  if (_getSecondaryActionIcon(alertType).isNotEmpty)
                    IconButton(
                      onPressed: onSecondaryActionPressed,
                      icon: CustomIconWidget(
                        iconName: _getSecondaryActionIcon(alertType),
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 5.w,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  SizedBox(width: 1.w),
                  // Indicador de NÃO LIDO
                  if (!isRead)
                    CustomIconWidget(
                      iconName: 'circle',
                      color: color,
                      size: 2.w,
                    ),
                ],
              ),
              SizedBox(height: 1.5.h),
              
              // Título
              Text(
                alert['title'] as String,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isRead ? AppTheme.lightTheme.colorScheme.onSurface : color,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 1.h),
              
              // Descrição
              Text(
                alert['description'] as String,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
              SizedBox(height: 1.5.h),
              
              // Rodapé
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'person',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 4.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    alert['sender'] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatTimestamp(alert['timestamp'] as DateTime),
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // FUNÇÕES AUXILIARES (TRADUÇÃO E ÍCONES)
  
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
  
  String _getPrimaryActionIcon(String type) {
    if (type == 'emergency') return 'phone';
    if (type == 'maintenance') return 'info_outline';
    return 'check';
  }

  String _getSecondaryActionIcon(String type) {
    if (type == 'security') return 'info_outline';
    return '';
  }

  String _formatTimestamp(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inMinutes < 1) return 'agora';
    if (difference.inHours < 1) return '${difference.inMinutes}min';
    if (difference.inDays < 1) return '${difference.inHours}h';
    return '${difference.inDays}d';
  }
}