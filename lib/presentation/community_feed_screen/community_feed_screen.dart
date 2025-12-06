import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/business_carousel_widget.dart';
import './widgets/community_header_widget.dart';
import './widgets/empty_feed_widget.dart';
import './widgets/post_card_widget.dart';
import './widgets/quick_action_chips_widget.dart';
import './widgets/marketplace_teaser_widget.dart';
// import '../messages_screen/messages_screen.dart';

class CommunityFeedScreen extends StatefulWidget {
  const CommunityFeedScreen({Key? key}) : super(key: key);

  @override
  State<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends State<CommunityFeedScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isRefreshing = false;
  int _currentTabIndex = 0;

  // Mock data
  final List<Map<String, dynamic>> _posts = [
    {
      "id": 1,
      "userName": "Maria Silva",
      "userUnit": "201",
      "userAvatar":
          "https://images.unsplash.com/photo-1661357525268-0461f3c4b815",
      "userAvatarSemanticLabel":
          "Mulher sorridente com cabelos castanhos longos usando blusa branca",
      "type": "help",
      "title": "Preciso de ajuda com mudança",
      "content":
          "Olá vizinhos! Estou me mudando no próximo sábado e preciso de ajuda para carregar alguns móveis. Posso oferecer pizza e refrigerante para quem puder ajudar!",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "helpsOffered": 3,
      "commentsCount": 7,
      "isUrgent": false,
      "imageUrl": null,
      "imageSemanticLabel": null,
    },
    {
      "id": 2,
      "userName": "João Santos",
      "userUnit": "105",
      "userAvatar":
          "https://images.unsplash.com/photo-1735181094336-7fa757df9622",
      "userAvatarSemanticLabel":
          "Homem de meia-idade com barba e camisa social azul sorrindo",
      "type": "service",
      "title": "Serviços de encanamento",
      "content":
          "Sou encanador profissional e moro aqui no prédio. Ofereço serviços com desconto especial para vizinhos. Disponível finais de semana também!",
      "timestamp": DateTime.now().subtract(const Duration(hours: 5)),
      "helpsOffered": 0,
      "commentsCount": 12,
      "isUrgent": false,
      "imageUrl":
          "https://images.unsplash.com/photo-1732660513320-a6b489f3fece",
      "imageSemanticLabel":
          "Homem trabalhando em encanamento com ferramentas profissionais",
    },
    {
      "id": 3,
      "userName": "Ana Costa",
      "userUnit": "304",
      "userAvatar":
          "https://images.unsplash.com/photo-1670785737632-3304b3c84b35",
      "userAvatarSemanticLabel":
          "Mulher jovem com cabelos cacheados e sorriso alegre",
      "type": "donation",
      "title": "Doação de roupas infantis",
      "content":
          "Tenho várias roupas infantis (tamanhos 2 a 6 anos) em ótimo estado para doação. Quem tiver interesse, pode me procurar!",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      "helpsOffered": 5,
      "commentsCount": 8,
      "isUrgent": false,
      "imageUrl":
          "https://images.unsplash.com/photo-1649302047319-aba014f3f0f6",
      "imageSemanticLabel":
          "Pilha organizada de roupas infantis coloridas dobradas",
    },
    {
      "id": 4,
      "userName": "Carlos Oliveira",
      "userUnit": "102",
      "userAvatar":
          "https://images.unsplash.com/photo-1655882752624-7c01aa90fa27",
      "userAvatarSemanticLabel":
          "Homem jovem com óculos e camiseta casual sorrindo",
      "type": "help",
      "title": "URGENTE: Vazamento no apartamento",
      "content":
          "Pessoal, estou com um vazamento urgente no banheiro que está afetando o apartamento de baixo. Alguém conhece um encanador de emergência?",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 30)),
      "helpsOffered": 2,
      "commentsCount": 15,
      "isUrgent": true,
      "imageUrl": null,
      "imageSemanticLabel": null,
    },
    {
      "id": 5,
      "userName": "Lucia Ferreira",
      "userUnit": "408",
      "userAvatar":
          "https://images.unsplash.com/photo-1669159248167-89c2e4763940",
      "userAvatarSemanticLabel":
          "Mulher madura com cabelos grisalhos e expressão amigável",
      "type": "exchange",
      "title": "Troco livros por plantas",
      "content":
          "Tenho uma coleção de livros de romance e ficção que gostaria de trocar por plantas ou mudas. Alguém se interessa?",
      "timestamp": DateTime.now().subtract(const Duration(days: 2)),
      "helpsOffered": 1,
      "commentsCount": 4,
      "isUrgent": false,
      "imageUrl":
          "https://images.unsplash.com/photo-1602990721338-9cbb5b983c4d",
      "imageSemanticLabel":
          "Estante com livros organizados e pequenas plantas decorativas",
    },
  ];

  final List<Map<String, dynamic>> _businesses = [
    {
      "id": 1,
      "name": "Padaria do Bairro",
      "category": "Alimentação",
      "description":
          "Pães frescos e salgados todos os dias. Desconto especial para moradores!",
      "discount": 15,
      "distance": "200m do condomínio",
      "logo":
          "https://images.unsplash.com/photo-1626076064671-eab3a7997927",
      "logoSemanticLabel": "Fachada acolhedora de padaria com pães na vitrine",
    },
    {
      "id": 2,
      "name": "Farmácia Saúde+",
      "category": "Saúde",
      "description":
          "Medicamentos e produtos de higiene com entrega gratuita no condomínio.",
      "discount": 10,
      "distance": "150m do condomínio",
      "logo":
          "https://images.unsplash.com/photo-1559574326-b28980940fae",
      "logoSemanticLabel":
          "Interior moderno de farmácia com prateleiras organizadas de medicamentos",
    },
    {
      "id": 3,
      "name": "Lavanderia Express",
      "category": "Serviços",
      "description":
          "Lavagem e passadoria de roupas com coleta e entrega no local.",
      "discount": 20,
      "distance": "300m do condomínio",
      "logo":
          "https://images.unsplash.com/photo-1702971916926-948dd75f0898",
      "logoSemanticLabel":
          "Lavanderia limpa e organizada com máquinas de lavar industriais",
    },
  ];

  final List<Map<String, dynamic>> _marketplaceItems = [
    {
        'id': 1,
        'title': 'Bicicleta de Montanha',
        'price': 'R\$ 650',
        'image': 'https://images.unsplash.com/photo-1485965120184-e220f721d03e',
        'imageSemantic': 'Bicicleta de montanha preta e verde encostada',
        'sellerName': 'Pedro Almeida', 
        'sellerUnit': '301', 
        'condition': 'Seminova, pneus novos',
    },
    {
        'id': 2,
        'title': 'Sofá 3 Lugares',
        'price': 'R\$ 900',
        'image': 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc',
        'imageSemantic': 'Sofá de tecido cinza escuro moderno',
        'sellerName': 'Julia Mendes', 
        'sellerUnit': '402', 
        'condition': 'Ótimo estado, sem manchas',
    },
    {
        'id': 3,
        'title': 'Cadeira Gamer Ergonômica',
        'price': 'R\$ 220',
        'image': 'https://images.unsplash.com/photo-1598300053892-5f6f7c7d1a5e',
        'imageSemantic': 'Cadeira de escritório preta com detalhes coloridos',
        'sellerName': 'Ricardo Gomes', 
        'sellerUnit': '110', 
        'condition': 'Usada, 6 meses de uso, pequenos desgastes',
    },
    {
        'id': 4,
        'title': 'Mudas de Suculentas',
        'price': 'R\$ 15/unidade',
        'image': 'https://images.unsplash.com/photo-1520627993099-0d8858d4a974',
        'imageSemantic': 'Pequenas suculentas em vasos de cerâmica',
        'sellerName': 'Ana Clara', 
        'sellerUnit': '805', 
        'condition': 'Novas, cultivadas em casa',
    },
    {
        'id': 5,
        'title': 'Micro-ondas 20L',
        'price': 'R\$ 180',
        'image': 'https://images.unsplash.com/photo-1627986060010-33e14316a3c9',
        'imageSemantic': 'Micro-ondas prateado em bancada de cozinha',
        'sellerName': 'Marcos Souza', 
        'sellerUnit': '601', 
        'condition': 'Funcionando perfeitamente, sem garantia',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMorePosts();
    }
  }

  Future<void> _loadMorePosts() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshFeed() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    Fluttertoast.showToast(
      msg: "Feed atualizado!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _navigateToPostCreation() {
    Navigator.pushNamed(context, AppRoutes.postCreation);
  }

  void _navigateToProfile() {
    Navigator.pushNamed(context, AppRoutes.profile);
  }

  void _navigateToUrgentAlerts() {
    Navigator.pushNamed(context, AppRoutes.urgentAlerts);
  }

  void _handleQuickAction(String action) {
    Fluttertoast.showToast(
      msg: "Abrindo criação de post: $action",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
    // _navigateToPostCreation();
  }

  void _handlePostAction(String action, Map<String, dynamic> post) {
    String message = "";
    switch (action) {
      case 'offer_help':
        message = "Oferecendo ajuda para ${post['userName']}";
        break;
      case 'save':
        message = "Post salvo";
        break;
      case 'share':
        message = "Compartilhando post";
        break;
      case 'report':
        message = "Post denunciado";
        break;
      case 'hide':
        message = "Post ocultado";
        break;
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleBusinessCoupon(Map<String, dynamic> business) {
    Fluttertoast.showToast(
      msg: "Abrindo cupom: ${business['name']}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleTabChange(int index) {
    String tabName = "";
    switch (index) {
      case 0:
        tabName = "Feed";
        break;
      case 1:
        tabName = "Perfil";
        Navigator.pushNamed(context, AppRoutes.profile);
        return;
      case 2:
        tabName = "Mensagens";
        Navigator.pushNamed(context, AppRoutes.messages);
        break;
      case 3:
        tabName = "Marketplace";
        break;
      case 4:
        tabName = "Configurações";
        break;
    }

    if (index != 1) {
      Fluttertoast.showToast(
        msg: "Navegando para: $tabName",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          CommunityHeaderWidget(
            communityName: "Residencial Harmonia",
            urgentAlertsCount: 2,
            userAvatarUrl:
                "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
            onAvatarTap: _navigateToProfile,
            onUrgentAlertsTap: _navigateToUrgentAlerts,
          ),
          QuickActionChipsWidget(
            onPedirAjuda: () => _handleQuickAction("Pedir Ajuda"),
            onOferecerServico: () => _handleQuickAction("Oferecer Serviço"),
            onDoacao: () => _handleQuickAction("Doação"),
            onTroca: () => _handleQuickAction("Troca"),
          ),
          Expanded(
            child: _posts.isEmpty
                ? EmptyFeedWidget(
                    onCreateFirstPost: _navigateToPostCreation,
                  )
                : RefreshIndicator(
                    onRefresh: _refreshFeed,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      // posts (5) + carousel (1) + marketplace (1) + loading (1) = 8 itens
                      itemCount: _posts.length + 3, 
                      itemBuilder: (context, index) {

                        // 1. CAROUSEL (Index 2) - SIMPLIFICADO E CORRIGIDO
                        if (index == 2) {
                          // Wrap com Container para garantir a aplicação da margem vertical
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 2.h),
                            child: BusinessCarouselWidget(
                              businesses: _businesses,
                              onViewCoupon: _handleBusinessCoupon,
                            ),
                          );
                        }

                        // 2. MARKETPLACE (Index 3)
                        if (index == 3) {
                          return Container(
                                  margin: EdgeInsets.only(bottom: 6.h), // Adiciona 6% da altura da tela de margem inferior
                                  child: MarketplaceTeaserWidget(items: _marketplaceItems),
                              );                        
                        }

                        // 3. INDICADOR DE LOADING (Último item - Index 7)
                        // Note que o itemCount é 8, então o último item válido é index 7 (5 posts + 2 widgets)
                        if (index == _posts.length + 2) { 
                          return _isLoading
                              ? Container(
                                  padding: EdgeInsets.all(4.w),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink();
                        }
                        
                        // 4. POSTCARDS - Lógica de Indexação CORRIGIDA
                        final postIndex = index < 2 ? index : index - 2;

                        if (postIndex >= _posts.length) {
                            return const SizedBox.shrink();
                        }

                        final post = _posts[postIndex];
                        return PostCardWidget(
                          post: post,
                          onOfferHelp: () =>
                              _handlePostAction('offer_help', post),
                          onSave: () => _handlePostAction('save', post),
                          onShare: () => _handlePostAction('share', post),
                          onReport: () => _handlePostAction('report', post),
                          onHide: () => _handlePostAction('hide', post),
                          onTap: () {
                            Fluttertoast.showToast(
                              msg: "Abrindo post de ${post['userName']}",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                            );
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToPostCreation,
        mini: true,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary, // Usando primary
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 4.w,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentTabIndex,
        onTap: (index) {
          _tabController.animateTo(index);
          _handleTabChange(index);
        },
        selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: _currentTabIndex == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentTabIndex == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'message',
              color: _currentTabIndex == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Mensagens',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'store',
              color: _currentTabIndex == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Marketplace',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'settings',
              color: _currentTabIndex == 4
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Configurações',
          ),
        ],
      ),
    );
  }
}
