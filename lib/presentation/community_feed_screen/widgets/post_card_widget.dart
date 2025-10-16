import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PostCardWidget extends StatelessWidget {
  final Map<String, dynamic> post;
  final VoidCallback onOfferHelp;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onReport;
  final VoidCallback onHide;
  final VoidCallback onTap;

  const PostCardWidget({
    Key? key,
    required this.post,
    required this.onOfferHelp,
    required this.onSave,
    required this.onShare,
    required this.onReport,
    required this.onHide,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(post['id']),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onOfferHelp(),
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
            icon: Icons.volunteer_activism,
            label: 'Ajudar',
          ),
          SlidableAction(
            onPressed: (_) => onSave(),
            backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
            foregroundColor: AppTheme.lightTheme.colorScheme.onSecondary,
            icon: Icons.bookmark,
            label: 'Salvar',
          ),
          SlidableAction(
            onPressed: (_) => onShare(),
            backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
            foregroundColor: AppTheme.lightTheme.colorScheme.onTertiary,
            icon: Icons.share,
            label: 'Compartilhar',
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: () => _showContextMenu(context),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserInfo(),
                SizedBox(height: 2.h),
                _buildPostContent(),
                SizedBox(height: 2.h),
                _buildEngagementMetrics(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1,
            ),
          ),
          child: ClipOval(
            child: CustomImageWidget(
              imageUrl: post['userAvatar'] as String,
              width: 12.w,
              height: 12.w,
              fit: BoxFit.cover,
              semanticLabel: post['userAvatarSemanticLabel'] as String,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      post['userName'] as String,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  _buildPostTypeBadge(),
                ],
              ),
              SizedBox(height: 0.5.h),
              Row(
                children: [
                  Text(
                    'Apto ${post['userUnit']}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    '•',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    _formatTimestamp(post['timestamp'] as DateTime),
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPostTypeBadge() {
    final postType = post['type'] as String;
    Color badgeColor;
    String badgeText;

    switch (postType) {
      case 'help':
        badgeColor = AppTheme.lightTheme.colorScheme.error;
        badgeText = 'Ajuda';
        break;
      case 'service':
        badgeColor = AppTheme.lightTheme.colorScheme.primary;
        badgeText = 'Serviço';
        break;
      case 'donation':
        badgeColor = AppTheme.lightTheme.colorScheme.tertiary;
        badgeText = 'Doação';
        break;
      case 'exchange':
        badgeColor = AppTheme.lightTheme.colorScheme.secondary;
        badgeText = 'Troca';
        break;
      default:
        badgeColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
        badgeText = 'Geral';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        badgeText,
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: badgeColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPostContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (post['title'] != null) ...[
          Text(
            post['title'] as String,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 1.h),
        ],
        Text(
          post['content'] as String,
          style: AppTheme.lightTheme.textTheme.bodyMedium,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        if (post['imageUrl'] != null) ...[
          SizedBox(height: 2.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CustomImageWidget(
              imageUrl: post['imageUrl'] as String,
              width: double.infinity,
              height: 25.h,
              fit: BoxFit.cover,
              semanticLabel:
                  post['imageSemanticLabel'] as String? ?? "Imagem do post",
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEngagementMetrics() {
    return Row(
      children: [
        _buildMetric(
          icon: 'volunteer_activism',
          count: post['helpsOffered'] as int,
          label: 'ajudas',
          color: AppTheme.lightTheme.colorScheme.primary,
        ),
        SizedBox(width: 4.w),
        _buildMetric(
          icon: 'comment',
          count: post['commentsCount'] as int,
          label: 'comentários',
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        ),
        const Spacer(),
        if (post['isUrgent'] == true)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color:
                  AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'priority_high',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 4.w,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Urgente',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMetric({
    required String icon,
    required int count,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: icon,
          color: color,
          size: 4.w,
        ),
        SizedBox(width: 1.w),
        Text(
          '$count $label',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'agora';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}min';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'report',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 6.w,
              ),
              title: Text(
                'Denunciar post',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                onReport();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'visibility_off',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 6.w,
              ),
              title: Text(
                'Ocultar post',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                onHide();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}