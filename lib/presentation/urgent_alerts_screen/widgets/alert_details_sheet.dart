import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AlertDetailsSheet extends StatefulWidget {
  final Map<String, dynamic> alert;
  final Color typeColor; // << NOVO: Parâmetro obrigatório adicionado
  final List<String> mockComments; // << NOVO: Parâmetro obrigatório adicionado

  const AlertDetailsSheet({
    Key? key,
    required this.alert,
    required this.typeColor, // << CORRIGIDO
    required this.mockComments, // << CORRIGIDO
  }) : super(key: key);

  @override
  State<AlertDetailsSheet> createState() => _AlertDetailsSheetState();
}

class _AlertDetailsSheetState extends State<AlertDetailsSheet> {
  final TextEditingController _commentController = TextEditingController();
  
  // Mocks de comentários internos (apenas para a entrada local, usaremos os mockComments passados para a exibição)
  final List<Map<String, dynamic>> _internalComments = [
    {
      'id': 1,
      'author': 'Maria Silva',
      'comment':
          'Também notei o problema. Já entrei em contato com a administração.',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
      'avatar':
          'https://images.unsplash.com/photo-1632421305114-cf8a167d7f45',
      'semanticLabel': 'Profile photo of a middle-aged woman with short brown hair wearing a blue blouse',
    },
    {
      'id': 2,
      'author': 'João Santos',
      'comment': 'Obrigado pelo alerta. Vou ficar atento.',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 8)),
      'avatar':
          'https://images.unsplash.com/photo-1718434216429-be81ffc07e6e',
      'semanticLabel': 'Profile photo of a man with gray hair and beard wearing a white shirt',
    },
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // Novo método para adicionar comentários mockados ao histórico
  void _addComment(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _internalComments.insert(0, {
        'id': _internalComments.length + 1,
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

  // Funções auxiliares movidas para o State
  String _getAlertIcon(String type) {
    switch (type) {
      case 'emergency': return 'emergency';
      case 'security': return 'security';
      case 'maintenance': return 'build';
      default: return 'notification_important';
    }
  }

  String _getAlertTypeLabel(String type) {
    switch (type) {
      case 'emergency': return 'EMERGÊNCIA';
      case 'security': return 'SEGURANÇA';
      case 'maintenance': return 'MANUTENÇÃO';
      default: return 'ALERTA';
    }
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '';
    try {
      DateTime dateTime = timestamp is DateTime ? timestamp : DateTime.parse(timestamp.toString());
      final difference = DateTime.now().difference(dateTime);
      if (difference.inMinutes < 60) return '${difference.inMinutes}min atrás';
      if (difference.inHours < 24) return '${difference.inHours}h atrás';
      return '${difference.inDays} dias atrás';
    } catch (e) {
      return '';
    }
  }

  String _formatFullTimestamp(dynamic timestamp) {
    if (timestamp == null) return '';
    try {
      DateTime dateTime = timestamp is DateTime ? timestamp : DateTime.parse(timestamp.toString());
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} às ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }
// -------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final alertType = widget.alert['type'] as String? ?? 'maintenance';
    final typeColor = widget.typeColor; // << USANDO O PARAMETRO CORRIGIDO

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
                    color: typeColor.withOpacity(0.1), // Usando typeColor
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: _getAlertIcon(alertType),
                    color: typeColor, // Usando typeColor
                    size: 6.w,
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
                          color: typeColor, // Usando typeColor
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
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),

          Divider(
            color:
                AppTheme.lightTheme.colorScheme.outline.withOpacity(0.2),
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
                      color: typeColor.withOpacity(0.05), // Usando typeColor
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: typeColor.withOpacity(0.2)), // Usando typeColor
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ... (Detalhes da hora, remetente, etc. - código mantido)
                        
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'schedule',
                              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                              size: 4.w,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              _formatFullTimestamp(widget.alert['timestamp']),
                              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
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
                                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                                size: 4.w,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Enviado por: ${widget.alert['sender']}',
                                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                        SizedBox(height: 2.h),
                        Text(
                          widget.alert['description'] as String? ?? '',
                          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
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
                                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                                size: 4.w,
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: Text(
                                  'Áreas afetadas: ${widget.alert['affectedAreas']}',
                                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
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
                                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                                size: 4.w,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Previsão de resolução: ${widget.alert['estimatedResolution']}',
                                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
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
                    'Comentários da Comunidade (${widget.mockComments.length + _internalComments.length})',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // Comments list (Combinando mocks externos e internos)
                  ..._internalComments.map((comment) => _buildCommentTile(comment, typeColor)), // Comentários internos
                  ...widget.mockComments.map((commentText) => _buildMockCommentTile(commentText)), // Mocks externos passados
                  
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
                      .withOpacity(0.2),
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
                        size: 6.w,
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

  // --- Widgets Auxiliares ---
  
  // Para comentários internos (com avatar, nome e timestamp)
  Widget _buildCommentTile(Map<String, dynamic> comment, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
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
                  semanticLabel: comment['semanticLabel'] as String,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment['author'] as String,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: comment['author'] == 'Você' ? color : AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      _formatTimestamp(comment['timestamp']),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
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
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // Para mocks externos (apenas texto)
  Widget _buildMockCommentTile(String commentText) {
      return Padding(
        padding: EdgeInsets.only(bottom: 1.5.h),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Container(
                    width: 1.5.w,
                    height: 1.5.w,
                    margin: EdgeInsets.only(top: 1.h, right: 3.w),
                    decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        shape: BoxShape.circle,
                    ),
                ),
                Expanded(
                    child: Text(
                        commentText,
                        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                            height: 1.4,
                        ),
                    ),
                ),
            ],
        ),
    );
  }
}