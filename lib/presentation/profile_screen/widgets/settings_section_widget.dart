import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsSectionWidget extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onNotifications;
  final VoidCallback onPrivacy;
  final VoidCallback onCommunity;
  final VoidCallback onSupport;

  const SettingsSectionWidget({
    Key? key,
    required this.onEditProfile,
    required this.onNotifications,
    required this.onPrivacy,
    required this.onCommunity,
    required this.onSupport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configurações',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(3.w),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                _buildSettingsItem(
                  icon: 'edit',
                  title: 'Editar Perfil',
                  subtitle: 'Altere suas informações pessoais',
                  onTap: onEditProfile,
                  isFirst: true,
                ),
                _buildDivider(),
                _buildSettingsItem(
                  icon: 'notifications',
                  title: 'Notificações',
                  subtitle: 'Configure suas preferências de notificação',
                  onTap: onNotifications,
                ),
                _buildDivider(),
                _buildSettingsItem(
                  icon: 'privacy_tip',
                  title: 'Privacidade',
                  subtitle: 'Controle quem pode ver suas informações',
                  onTap: onPrivacy,
                ),
                _buildDivider(),
                _buildSettingsItem(
                  icon: 'home',
                  title: 'Comunidade',
                  subtitle: 'Informações sobre sua comunidade',
                  onTap: onCommunity,
                ),
                _buildDivider(),
                _buildSettingsItem(
                  icon: 'help',
                  title: 'Suporte',
                  subtitle: 'Central de ajuda e contato',
                  onTap: onSupport,
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: isFirst ? Radius.circular(3.w) : Radius.zero,
        bottom: isLast ? Radius.circular(3.w) : Radius.zero,
      ),
      child: Container(
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
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
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      height: 1,
      color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
    );
  }
}