import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AlertDetailsSheet extends StatefulWidget {
  final Map<String, dynamic> alert;

  const AlertDetailsSheet({
    Key? key,
    required this.alert,
  }) : super(key: key);

  @override
  State<AlertDetailsSheet> createState() => _AlertDetailsSheetState();
}

class _AlertDetailsSheetState extends State<AlertDetailsSheet> {
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, dynamic>> _comments = [
    {
      'id': 1,
      'author': 'Maria Silva',
      'comment':
          'Também notei o problema. Já entrei em contato com a administração.',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
      'avatar':
          'https://images.unsplash.com/photo-1632421305114-cf8a167d7f45',
      'semanticLabel':
          'Profile photo of a middle-aged woman with short brown hair wearing a blue blouse',
    },
    {
      'id': 2,
      'author': 'João Santos',
      'comment': 'Obrigado pelo alerta. Vou ficar atento.',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 8)),
      'avatar':
          'https://images.unsplash.com/photo-1718434216429-be81ffc07e6e',
      'semanticLabel':
          'Profile photo of a man with gray hair and beard wearing a white shirt',
    },
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alertType = widget.alert['type'] as String? ?? 'maintenance';

    Color borderColor = AppTheme.lightTheme.colorScheme.outline;
    if (alertType == 'emergency') {
      borderColor = AppTheme.lightTheme.colorScheme.error;
    } else if (alertType == 'security') {
      borderColor = const Color(0xFFFF9800);
    } else if (alertType == 'maintenance') {
      borderColor = const Color(0xFFFFC107);
    }

    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
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
                    size: 24,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detalhes do Alerta',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _getAlertTypeLabel(alertType),
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: borderColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          Divider(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            height: 1,
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Alert details
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: borderColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: borderColor.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'schedule',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 16,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              _formatFullTimestamp(widget.alert['timestamp']),
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        if (widget.alert['sender'] != null) ...[
                          SizedBox(height: 1.h),
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'person',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 16,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Enviado por: ${widget.alert['sender']}',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                        SizedBox(height: 2.h),
                        Text(
                          widget.alert['description'] as String? ?? '',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            height: 1.5,
                          ),
                        ),
                        if (widget.alert['affectedAreas'] != null) ...[
                          SizedBox(height: 2.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomIconWidget(
                                iconName: 'location_on',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 16,
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: Text(
                                  'Áreas afetadas: ${widget.alert['affectedAreas']}',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (widget.alert['estimatedResolution'] != null) ...[
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'schedule',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 16,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Previsão de resolução: ${widget.alert['estimatedResolution']}',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Comments section
                  Text(
                    'Comentários dos Moradores',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // Comments list
                  ..._comments.map((comment) => Container(
                        margin: EdgeInsets.only(bottom: 2.h),
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppTheme
                              .lightTheme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 4.w,
                                  child: CustomImageWidget(
                                    imageUrl: comment['avatar'] as String,
                                    width: 8.w,
                                    height: 8.w,
                                    fit: BoxFit.cover,
                                    semanticLabel:
                                        comment['semanticLabel'] as String,
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comment['author'] as String,
                                        style: AppTheme
                                            .lightTheme.textTheme.titleSmall
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        _formatTimestamp(comment['timestamp']),
                                        style: AppTheme
                                            .lightTheme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: AppTheme.lightTheme.colorScheme
                                              .onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              comment['comment'] as String,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      )),

                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),

          // Comment input
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Adicionar comentário...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: AppTheme.lightTheme.colorScheme.outline,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: AppTheme.lightTheme.colorScheme.outline,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 1.5.h,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _addComment,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => _addComment(_commentController.text),
                      icon: CustomIconWidget(
                        iconName: 'send',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addComment(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _comments.insert(0, {
        'id': _comments.length + 1,
        'author': 'Você',
        'comment': text.trim(),
        'timestamp': DateTime.now(),
        'avatar':
            'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
        'semanticLabel': 'Your profile photo',
      });
    });

    _commentController.clear();
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
        return '${difference.inDays} dias atrás';
      }
    } catch (e) {
      return '';
    }
  }

  String _formatFullTimestamp(dynamic timestamp) {
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

      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} às ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }
}