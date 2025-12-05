import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../core/mock_images.dart';

class CommunityHeaderWidget extends StatelessWidget {
  final String communityName;
  final int urgentAlertsCount;
  final String userAvatarUrl;
  final VoidCallback onAvatarTap;
  final VoidCallback onUrgentAlertsTap;

  const CommunityHeaderWidget({
    Key? key,
    required this.communityName,
    required this.urgentAlertsCount,
    required this.userAvatarUrl,
    required this.onAvatarTap,
    required this.onUrgentAlertsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xFF305c84), // Azul Profundo
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Profile Avatar e Comunidade
            Expanded(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onAvatarTap,
                    child: Container(
                      width: 11.w,
                      height: 11.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: MockImages.buildProfileImage(
                        size: 11.w,
                        imageUrl: userAvatarUrl,
                        semanticLabel: "Foto do perfil do usuário",
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          communityName,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.3.h),
                        Text(
                          'Conectando vizinhos',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Notification Icon
            GestureDetector(
              onTap: onUrgentAlertsTap,
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.5.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'notifications',
                      color: urgentAlertsCount > 0
                          ? Colors.red.shade400
                          : Colors.white.withValues(alpha: 0.6),
                      size: 5.w,
                    ),
                  ),
                  if (urgentAlertsCount > 0)
                    Positioned(
                      // align the badge slightly lower so it appears under the header block
                      right: 0,
                      top: 1.h,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 1.w,
                          vertical: 0.35.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 4.w,
                          minHeight: 2.h,
                        ),
                        child: Center(
                          child: Text(
                            urgentAlertsCount > 99
                                ? '99+'
                                : urgentAlertsCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
