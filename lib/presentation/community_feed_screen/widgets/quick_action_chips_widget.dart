import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionChipsWidget extends StatelessWidget {
  final VoidCallback onPedirAjuda;
  final VoidCallback onOferecerServico;
  final VoidCallback onDoacao;
  final VoidCallback onTroca;

  const QuickActionChipsWidget({
    Key? key,
    required this.onPedirAjuda,
    required this.onOferecerServico,
    required this.onDoacao,
    required this.onTroca,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.h,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        children: [
          _buildActionChip(
            label: 'Pedir Ajuda',
            icon: 'help_outline',
            color: AppTheme.lightTheme.colorScheme.error,
            onTap: onPedirAjuda,
          ),
          SizedBox(width: 3.w),
          _buildActionChip(
            label: 'Oferecer Serviço',
            icon: 'handyman',
            color: AppTheme.lightTheme.colorScheme.primary,
            onTap: onOferecerServico,
          ),
          SizedBox(width: 3.w),
          _buildActionChip(
            label: 'Doação',
            icon: 'favorite',
            color: AppTheme.lightTheme.colorScheme.tertiary,
            onTap: onDoacao,
          ),
          SizedBox(width: 3.w),
          _buildActionChip(
            label: 'Troca',
            icon: 'swap_horiz',
            color: AppTheme.lightTheme.colorScheme.secondary,
            onTap: onTroca,
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip({
    required String label,
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: color,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}