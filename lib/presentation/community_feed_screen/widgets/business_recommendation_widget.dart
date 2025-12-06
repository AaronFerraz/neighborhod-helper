// business_recommendation_widget.dart

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BusinessRecommendationWidget extends StatelessWidget {
  final Map<String, dynamic> business;
  final VoidCallback onViewCoupon;

  const BusinessRecommendationWidget({
    Key? key,
    required this.business,
    required this.onViewCoupon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // A altura alocada pelo carousel pai é 35.h
    // Definimos uma altura máxima para o Container/Card
    const double maxCardHeight = 35; // Usamos 35.h, mas aqui usamos o número para referência Sizer
    
    return Container(
      width: 80.w,
      margin: EdgeInsets.only(right: 4.w),
      // Adicionando uma restrição forte de altura ao Container
      constraints: BoxConstraints(maxHeight: maxCardHeight.h), // Conter a altura
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.w), // 3.w é menor que 4.w
          // padding: EdgeInsets.all(4.w),
          // CORREÇÃO: Linha 25 (A Column causadora do erro) deve ser contida.
          // Usamos uma Column aqui, mas precisamos garantir que seus filhos não se somem
          // a mais de 35.h. Como o problema é a soma, faremos uma otimização:
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Linhas 1 a 20: Logo, Nome, Categoria, Desconto (Altura ~18.h)
              Row(
                children: [
                  Container(
                    width: 15.w,
                    height: 15.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: CustomImageWidget(
                        imageUrl: business['logo'] as String,
                        width: 15.w,
                        height: 15.w,
                        fit: BoxFit.cover,
                        semanticLabel: business['logoSemanticLabel'] as String,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          business['name'] as String,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          business['category'] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.secondary
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${business['discount']}% OFF',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              
              // Descrição: Reduzindo o Text para caber no espaço restante
              Expanded( 
                  child: Text(
                    business['description'] as String,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                    maxLines: 3, // Garantindo um limite estrito para o texto
                    overflow: TextOverflow.ellipsis,
                  ),
              ),
              SizedBox(height: 0.5.h), // Reduzido de 2.h para 1.h para economizar espaço
              
              // Rodapé: Localização e Botão
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'location_on',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 4.w,
                        ),
                        SizedBox(width: 1.w),
                        Expanded(
                          child: Text(
                            business['distance'] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 2.w),
                  ElevatedButton(
                    onPressed: onViewCoupon,
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      minimumSize: Size(0, 5.h),
                    ),
                    child: Text(
                      'Ver Cupom',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
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
}