import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../core/app_export.dart';

class MarketplaceTeaserWidget extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const MarketplaceTeaserWidget({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Título
              Row(
                children: [
                   CustomIconWidget(
                    iconName: 'store',
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    size: 6.w,
                  ),
                  SizedBox(width: 2.w),
                  Text('Anúncios do Marketplace',
                      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      )),
                ],
              ),
              // Botão Ver todos
              TextButton(
                onPressed: () {
                  Fluttertoast.showToast(msg: 'Abrir Marketplace (mock)');
                },
                child: Text(
                  'Ver todos',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary, 
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
        
        // CORREÇÃO: Usando GlobalKey para garantir que o layout da lista seja recalculado corretamente.
        SizedBox( 
          key: const ValueKey('marketplace_carousel_key'),
          height: 38.h, // Altura contida
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: items.length,
            separatorBuilder: (_, __) => SizedBox(width: 3.w),
            itemBuilder: (context, index) {
              final it = items[index];
              return SizedBox(
                width: 55.w,
                child: Card(
                  margin: EdgeInsets.zero,
                  // Envolve o Card em uma restrição extra para segurança máxima de altura (38.h)
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 38.h), 
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Área da Imagem (Envolvida em Container para garantir dimensão)
                        Container(
                          width: 50.w,
                          height: 15.h,
                          decoration: BoxDecoration(
                             borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                             color: AppTheme.lightTheme.colorScheme.onSurface.withOpacity(0.1), // Placeholder visual
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                            child: CustomImageWidget(
                              imageUrl: (it['image'] as String?) ?? 'assets/placeholder.png', 
                              width: 50.w,
                              height: 15.h,
                              fit: BoxFit.cover,
                              semanticLabel: (it['imageSemantic'] as String?) ?? 'Item no Marketplace',
                            ),
                          ),
                        ),
                        
                        // Detalhes do produto
                        Padding(
                          padding: EdgeInsets.all(3.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Título
                              Text(
                                (it['title'] as String?) ?? 'Item Indefinido',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              // Preço
                              Text(
                                (it['price'] as String?) ?? 'R\$ 0,00',
                                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                                  color: AppTheme.lightTheme.colorScheme.primary, 
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              
                              // Vendedor
                              Row(
                                children: [
                                  Icon(Icons.person_outline, size: 4.w, color: AppTheme.lightTheme.colorScheme.onSurfaceVariant),
                                  SizedBox(width: 1.w),
                                  Text(
                                    '${(it['sellerName'] as String?) ?? 'Vendedor'} (${(it['sellerUnit'] as String?) ?? 'N/A'})',
                                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 0.5.h),
                              
                              // Condição
                              Row(
                                children: [
                                  Icon(Icons.check_circle_outline, size: 4.w, color: AppTheme.lightTheme.colorScheme.secondary),
                                  SizedBox(width: 1.w),
                                  Expanded(
                                    child: Text(
                                      (it['condition'] as String?) ?? 'Sem informação de condição',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}