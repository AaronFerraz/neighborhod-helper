import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../core/mock_images.dart';
// Importa o logotipo
// import '../../../../../../../assets/images/logotipo-EI2.png'; // Presumindo que o logo está acessível neste caminho de mock

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
    // Definindo o tamanho comum para o Ícone de Notificação e o Logo
    final double iconSize = 7.w; 

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xFF305c84), // Azul Profundo
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Profile Avatar e Comunidade (Lado Esquerdo)
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
                          color: Colors.white.withOpacity(0.3),
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
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Ícone de Notificação e Logo (Lado Direito)
            Row(
              children: [
                // 1. Ícone de Notificação (Laranja, Contador Menor)
                GestureDetector(
                  onTap: onUrgentAlertsTap,
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: CustomIconWidget(
                          iconName: 'notifications',
                          // Ícone Laranja Fixo
                          color: Colors.orange.shade500, 
                          size: iconSize * 0.6, // Um pouco menor que o container
                        ),
                      ),
                      if (urgentAlertsCount > 0)
                        Positioned(
                          right: 0,
                          top: 0, // Ajuste para ficar no canto superior direito
                          child: Container(
                            // Diminuindo o tamanho do badge
                            constraints: BoxConstraints(
                              minWidth: 3.w, // Tamanho menor
                              minHeight: 3.w, // Tamanho menor
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade500,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                // Limite para "9+" e tamanho de fonte menor
                                urgentAlertsCount > 9
                                    ? '9+'
                                    : urgentAlertsCount.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 6.sp, // Fonte menor
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

                SizedBox(width: 3.w),
                
                // 2. Logo do Projeto (Mesmo Tamanho da Notificação)
                Container(
                  width: iconSize * 1.4,
                  height: iconSize * 1.4,
                  child: Image.asset(
                    'assets/images/logotipo-EI3.png', // << Usando Image.asset (se for local)
                    fit: BoxFit.contain,
                    semanticLabel: 'Logotipo Amigo da Vizinhança',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
