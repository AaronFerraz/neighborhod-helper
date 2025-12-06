import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart'; // Importe suas rotas (AppRoutes)

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  // Lógica de navegação replicada do CommunityFeedScreen (Simplificada para rotas nomeadas)
  void _handleTabNavigation(BuildContext context, int index) {
    String route = '';
    // Mapeamento dos índices para as rotas (usando as constantes AppRoutes)
    switch (index) {
      case 0:
        route = AppRoutes.communityFeed;
        break;
      case 1:
        route = AppRoutes.profile;
        break;
      case 2:
        return; // Já está na tela de mensagens
      case 3:
        route = AppRoutes.communityFeed; // Mock para Marketplace
        break;
      case 4:
        route = AppRoutes.profile; // Mock para Configurações
        break;
    }

    if (route.isNotEmpty) {
      Navigator.pushNamed(context, route); 
    }
  }

  // NOVO MÉTODO: Cor para o status da conversa
  Color _getStatusColor(String status) {
    switch (status) {
      case 'security':
        return Colors.red.shade600; 
      case 'help':
        return AppTheme.lightTheme.colorScheme.error; 
      case 'marketplace':
        return AppTheme.lightTheme.colorScheme.secondary; 
      case 'donation':
        return AppTheme.lightTheme.colorScheme.tertiary; 
      case 'admin':
        return AppTheme.lightTheme.colorScheme.primary; 
      default:
        return AppTheme.lightTheme.colorScheme.primary.withOpacity(0.5);
    }
  }


  @override
  Widget build(BuildContext context) {
    // Mock data expandido para refletir o contexto do app (unidade, fotos, contexto)
    final List<Map<String, dynamic>> conversations = [
      {
        'id': 1,
        'name': 'João Santos',
        'unit': 'Apto 105',
        'lastMessage': 'Combinado! Pego a furadeira amanhã às 10h.',
        'time': '5m',
        'avatar': 'https://images.unsplash.com/photo-1735181094336-7fa757df9622',
        'status': 'help',
      },
      {
        'id': 2,
        'name': 'Pedro Almeida',
        'unit': 'Apto 301',
        'lastMessage': 'Estou interessado na bike. Qual o menor preço?',
        'time': '2h',
        'avatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
        'status': 'marketplace',
      },
      {
        'id': 3,
        'name': 'Administração',
        'unit': 'Geral',
        'lastMessage': 'Lembrete: Fechamento da piscina na próxima semana.',
        'time': '3d',
        'avatar': 'https://images.unsplash.com/photo-1542744173-8e7e53415bb0',
        'status': 'admin',
      },
      {
        'id': 4,
        'name': 'Maria Silva',
        'unit': 'Apto 201',
        'lastMessage': 'Obrigado pela ajuda com a doação!',
        'time': '4d',
        'avatar': 'https://images.unsplash.com/photo-1661357525268-0461f3c4b815',
        'status': 'donation',
      },
      {
        'id': 5,
        'name': 'Carlos Oliveira',
        'unit': 'Apto 102',
        'lastMessage': 'Vi seu alerta, vou verificar o que está acontecendo.',
        'time': '1sem',
        'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
        'status': 'security',
      },
    ];

    // Constante para o índice ativo
    const int currentIndex = 2; 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensagens', style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary, 
        elevation: 0,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(4.w),
        itemCount: conversations.length,
        separatorBuilder: (_, __) => SizedBox(height: 1.h),
        itemBuilder: (context, index) {
          final convo = conversations[index];
          
          // Construção do Avatar com CustomImageWidget
          Widget avatar = CircleAvatar(
              radius: 4.w,
              // Usando a cor baseada no status da conversa
              backgroundColor: _getStatusColor(convo['status'] as String), 
              child: convo['avatar'] != null 
                  ? ClipOval(
                      child: CustomImageWidget(
                        imageUrl: convo['avatar'] as String,
                        width: 12.w,
                        height: 12.w,
                        fit: BoxFit.cover,
                        semanticLabel: 'Avatar de ${convo['name']}',
                      ),
                    )
                  : Text(
                      (convo['name'] as String)[0],
                      style: TextStyle(color: Colors.white),
                    ),
          );

          return ListTile(
            leading: avatar,
            title: Text(
                '${convo['name']} (${convo['unit']})',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
                convo['lastMessage'] as String,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(convo['time'] as String),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    contactName: convo['name'] as String,
                    contactUnit: convo['unit'] as String,
                  ),
                ),
              );
            },
          );
        },
      ),

      // BOTTOM NAVIGATION BAR (Replicado do CommunityFeedScreen)
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex, 
        onTap: (index) => _handleTabNavigation(context, index),
        selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: currentIndex == 0 ? AppTheme.lightTheme.colorScheme.primary : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: currentIndex == 1 ? AppTheme.lightTheme.colorScheme.primary : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'message',
              color: AppTheme.lightTheme.colorScheme.primary, 
              size: 6.w,
            ),
            label: 'Mensagens',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'store',
              color: currentIndex == 3 ? AppTheme.lightTheme.colorScheme.primary : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Marketplace',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'settings',
              color: currentIndex == 4 ? AppTheme.lightTheme.colorScheme.primary : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Configurações',
          ),
        ],
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String contactName;
  final String contactUnit;

  const ChatScreen({
    Key? key, 
    required this.contactName, 
    required this.contactUnit,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> _messages = [
    {'fromMe': false, 'text': 'Olá! Vi seu anúncio da Bicicleta de Montanha.'},
    {'fromMe': false, 'text': 'Ela ainda está disponível e qual seria o último preço?'},
    {'fromMe': true, 'text': 'Sim, ainda está. O menor que consigo fazer é R\$ 600, pois está em ótimo estado.'},
    {'fromMe': false, 'text': 'Entendo. Se for R\$ 550, fecho agora e pego ainda hoje no Apto 301.'},
    {'fromMe': true, 'text': 'Fechado em R\$ 580. Posso descer ela até a portaria em 20 minutos.'},
    {'fromMe': false, 'text': 'Ótimo! Estarei lá. Obrigado!'},
  ];
  final TextEditingController _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({'fromMe': true, 'text': text});
    });
    _ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nome na cor branca e tamanho maior
            Text(widget.contactName, style: TextStyle(fontSize: 10.sp, color: Colors.white)),
            Text(
              widget.contactUnit, 
              style: TextStyle(fontSize: 7.sp, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary, // Cor do tema
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, 
              padding: EdgeInsets.all(4.w),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[_messages.length - 1 - index]; 
                return Align(
                  alignment:
                      m['fromMe'] ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 0.5.h),
                    padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
                    constraints: BoxConstraints(maxWidth: 75.w), 
                    decoration: BoxDecoration(
                      color: m['fromMe']
                          ? AppTheme.lightTheme.colorScheme.primary 
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        )
                      ],
                    ),
                    child: Text(
                      m['text'] as String,
                      style: TextStyle(
                          color: m['fromMe'] ? Colors.white : Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: 'Escreva uma mensagem...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.5.w), // Aumentado para altura
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  FloatingActionButton(
                    onPressed: _send,
                    mini: true,
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                    child: const Icon(Icons.send, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
