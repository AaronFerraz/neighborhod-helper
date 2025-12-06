import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AlertFilterWidget extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;
  final Map<String, Color> typeColors; 

  const AlertFilterWidget({
    Key? key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.typeColors, 
  }) : super(key: key);

  String _getLabel(String key) {
    switch (key) {
      case 'all': return 'Todos';
      case 'emergency': return 'Emergência';
      case 'security': return 'Segurança';
      case 'maintenance': return 'Manutenção';
      default: return key;
    }
  }

  String _getIconName(String key) {
    switch (key) {
      case 'all': return 'list';
      case 'emergency': return 'emergency';
      case 'security': return 'lock';
      case 'maintenance': return 'construction';
      default: return 'build';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filters = [
      {'key': 'all'},
      {'key': 'emergency'},
      {'key': 'security'},
      {'key': 'maintenance'},
    ];

    return Container(
      // Altura segura e flexível
      height: 7.h,
      padding: EdgeInsets.symmetric(vertical: 1.h), 
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        // CORREÇÃO: Padding horizontal removido do ListView para dar mais espaço.
        padding: EdgeInsets.zero, 
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final key = filter['key'] as String;
          final isSelected = selectedFilter == key;
          
          final color = typeColors[key] ?? AppTheme.lightTheme.colorScheme.primary; 

          Color chipColor = AppTheme.lightTheme.colorScheme.surface;
          Color textColor = color;
          
          if (isSelected) {
            chipColor = color.withOpacity(0.15); 
            textColor = color;
          } else {
            textColor = color; 
          }

          return Container(
            // CORREÇÃO: A margem é adicionada apenas no lado direito, exceto o último item.
            margin: EdgeInsets.only(
              right: (index < filters.length - 1) ? 3.w : 0, 
              left: (index == 0) ? 4.w : 0, // Adiciona padding da tela apenas no primeiro item
            ),
            child: FilterChip(
              selected: isSelected,
              onSelected: (selected) {
                onFilterChanged(key);
              },
              backgroundColor: chipColor,
              selectedColor: chipColor,
              checkmarkColor: textColor,
              side: BorderSide(
                color: isSelected ? textColor.withOpacity(0.5) : AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
              // Padding Vertical reduzido para zero
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0), 
              
              label: Row( 
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center, 
                children: [
                  CustomIconWidget(
                    iconName: _getIconName(key),
                    color: textColor,
                    size: 4.5.w, 
                  ),
                  SizedBox(width: 2.w),
                  Flexible( 
                    child: Text(
                      _getLabel(key),
                      style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: textColor,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }
}