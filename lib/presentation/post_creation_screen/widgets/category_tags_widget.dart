import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CategoryTagsWidget extends StatelessWidget {
  final String postType;
  final List<String> selectedCategories;
  final Function(List<String>) onCategoriesChanged;

  const CategoryTagsWidget({
    Key? key,
    required this.postType,
    required this.selectedCategories,
    required this.onCategoriesChanged,
  }) : super(key: key);

  List<String> _getCategoriesForType(String type) {
    switch (type) {
      case 'Ajuda':
        return [
          'Limpeza',
          'Técnico',
          'Cuidados',
          'Emergência',
          'Transporte',
          'Compras'
        ];
      case 'Serviço':
        return [
          'Limpeza',
          'Técnico',
          'Jardinagem',
          'Pet Care',
          'Educação',
          'Beleza'
        ];
      case 'Doação':
        return [
          'Roupas',
          'Móveis',
          'Eletrônicos',
          'Livros',
          'Brinquedos',
          'Alimentos'
        ];
      case 'Troca':
        return [
          'Roupas',
          'Livros',
          'Eletrônicos',
          'Móveis',
          'Plantas',
          'Utensílios'
        ];
      case 'Anúncio':
        return ['Evento', 'Venda', 'Aluguel', 'Aviso', 'Reunião', 'Celebração'];
      default:
        return ['Geral'];
    }
  }

  void _toggleCategory(String category) {
    List<String> updatedCategories = [...selectedCategories];
    if (updatedCategories.contains(category)) {
      updatedCategories.remove(category);
    } else {
      if (updatedCategories.length < 3) {
        updatedCategories.add(category);
      }
    }
    onCategoriesChanged(updatedCategories);
  }

  @override
  Widget build(BuildContext context) {
    final categories = _getCategoriesForType(postType);

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Categorias',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(width: 2.w),
              Text(
                '(${selectedCategories.length}/3)',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: categories.map((category) {
              final isSelected = selectedCategories.contains(category);
              final canSelect = selectedCategories.length < 3 || isSelected;

              return GestureDetector(
                onTap: canSelect ? () => _toggleCategory(category) : null,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.2)
                        : canSelect
                            ? AppTheme
                                .lightTheme.colorScheme.surfaceContainerHighest
                            : AppTheme
                                .lightTheme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: canSelect ? 1.0 : 0.5),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    category,
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : canSelect
                              ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                              : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5),
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}