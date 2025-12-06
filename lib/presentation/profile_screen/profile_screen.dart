import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/coupons_wallet_widget.dart';
import './widgets/edit_profile_modal_widget.dart';
import './widgets/engagement_metrics_widget.dart';
import './widgets/logout_section_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/user_posts_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 2; // Profile tab active

  // User data
  String _userName = 'Maria Silva Santos';
  String _userBio =
      'Moradora há 3 anos, amo nossa comunidade! Sempre disposta a ajudar os vizinhos.';
  String _unitInfo = 'Apartamento 304 - Bloco B';
  String _profileImageUrl =
      'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg';
  bool _isVerified = true;

  // Engagement metrics
  int _helpOffered = 14;
  int _helpReceived = 7;
  int _recommendationsMade = 19;

  // Mock data for user posts
  final List<Map<String, dynamic>> _userPosts = [
    {
      'id': 1,
      'type': 'Ajuda',
      'title': 'Preciso de ajuda para carregar móveis',
      'description':
          'Mudança no final de semana, preciso de ajuda para carregar alguns móveis pesados.',
      'date': '14/10/2025',
      'status': 'Ativo',
    },
    {
      'id': 2,
      'type': 'Oferta',
      'title': 'Ofereço aulas de culinária',
      'description':
          'Ensino receitas tradicionais brasileiras para quem tem interesse.',
      'date': '12/10/2025',
      'status': 'Concluído',
    },
    {
      'id': 3,
      'type': 'Doação',
      'title': 'Doação de livros infantis',
      'description':
          'Tenho vários livros infantis em ótimo estado para doação.',
      'date': '10/10/2025',
      'status': 'Concluído',
    },
    {
      'id': 4,
      'type': 'Troca',
      'title': 'Troco plantas por mudas',
      'description':
          'Tenho mudas de suculentas para trocar por outras plantas.',
      'date': '08/10/2025',
      'status': 'Expirado',
    },
  ];

  // Mock data for available coupons
  final List<Map<String, dynamic>> _availableCoupons = [
    {
      'id': 1,
      'businessName': 'Padaria do Bairro',
      'discount': '15% OFF',
      'description': 'Em compras acima de R\$ 20,00',
      'daysLeft': 5,
      'qrCode': 'PADARIA_15OFF_MARIA',
    },
    {
      'id': 2,
      'businessName': 'Farmácia Central',
      'discount': '10% OFF',
      'description': 'Em medicamentos sem receita',
      'daysLeft': 2,
      'qrCode': 'FARMACIA_10OFF_MARIA',
    },
    {
      'id': 3,
      'businessName': 'Mercadinho da Esquina',
      'discount': 'R\$ 5,00 OFF',
      'description': 'Em compras acima de R\$ 30,00',
      'daysLeft': 10,
      'qrCode': 'MERCADO_5OFF_MARIA',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 5, vsync: this, initialIndex: _currentTabIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showEditProfileModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditProfileModalWidget(
        currentName: _userName,
        currentBio: _userBio,
        currentUnit: _unitInfo,
        currentProfileImage: _profileImageUrl,
        onSave: (name, bio, unit, profileImage) {
          setState(() {
            _userName = name;
            _userBio = bio;
            _unitInfo = unit;
            if (profileImage != null) {
              _profileImageUrl = profileImage;
            }
          });
        },
      ),
    );
  }

  void _handleLogout() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login-screen',
      (route) => false,
    );
  }

  void _navigateToTab(int index) {
    setState(() {
      _currentTabIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/community-feed-screen');
        break;
      case 1:
        Navigator.pushNamed(context, '/post-creation-screen');
        break;
      case 2:
        // Already on profile screen
        break;
      case 3:
        Navigator.pushNamed(context, '/urgent-alerts-screen');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    'Meu Perfil',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _showEditProfileModal,
                    icon: CustomIconWidget(
                      iconName: 'edit',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 6.w,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile Header
                    ProfileHeaderWidget(
                      userName: _userName,
                      unitInfo: _unitInfo,
                      profileImageUrl: _profileImageUrl,
                      isVerified: _isVerified,
                      onEditProfile: _showEditProfileModal,
                    ),

                    SizedBox(height: 2.h),

                    // Engagement Metrics
                    EngagementMetricsWidget(
                      helpOffered: _helpOffered,
                      helpReceived: _helpReceived,
                      recommendationsMade: _recommendationsMade,
                      onHelpOfferedTap: () {
                        // Navigate to help offered history
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Histórico de ajudas oferecidas')),
                        );
                      },
                      onHelpReceivedTap: () {
                        // Navigate to help received history
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Histórico de ajudas recebidas')),
                        );
                      },
                      onRecommendationsTap: () {
                        // Navigate to recommendations history
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Histórico de recomendações')),
                        );
                      },
                    ),

                    SizedBox(height: 2.h),

                    // User Posts Section
                    UserPostsWidget(
                      userPosts: _userPosts,
                      onViewAllPosts: () {
                        // Navigate to all posts screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Visualizar todos os posts')),
                        );
                      },
                    ),

                    SizedBox(height: 2.h),

                    // Coupons Wallet
                    CouponsWalletWidget(
                      availableCoupons: _availableCoupons,
                    ),

                    SizedBox(height: 2.h),

                    // Settings Section
                    SettingsSectionWidget(
                      onEditProfile: _showEditProfileModal,
                      onNotifications: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Configurações de notificação')),
                        );
                      },
                      onPrivacy: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Configurações de privacidade')),
                        );
                      },
                      onCommunity: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Informações da comunidade')),
                        );
                      },
                      onSupport: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Central de suporte')),
                        );
                      },
                    ),

                    // Logout Section
                    LogoutSectionWidget(
                      onLogout: _handleLogout,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentTabIndex,
          onTap: _navigateToTab,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
          unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          items: [
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'home',
                color: _currentTabIndex == 0
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 6.w,
              ),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'add_circle',
                color: _currentTabIndex == 1
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 6.w,
              ),
              label: 'Criar',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'person',
                color: _currentTabIndex == 2
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 6.w,
              ),
              label: 'Perfil',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  CustomIconWidget(
                    iconName: 'notifications',
                    color: _currentTabIndex == 3
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 6.w,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 2.w,
                      height: 2.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              label: 'Alertas',
            ),
          ],
        ),
      ),
    );
  }
}