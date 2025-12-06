import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart'; 
import './widgets/alert_card_widget.dart';
import './widgets/alert_details_sheet.dart';
import './widgets/alert_filter_widget.dart';
import './widgets/empty_alerts_widget.dart';

class UrgentAlertsScreen extends StatefulWidget {
  const UrgentAlertsScreen({Key? key}) : super(key: key);

  @override
  State<UrgentAlertsScreen> createState() => _UrgentAlertsScreenState();
}

class _UrgentAlertsScreenState extends State<UrgentAlertsScreen> {
  String _selectedFilter = 'all';
  bool _isRefreshing = false;

  // Mapa de cores para tipos de alerta
  final Map<String, Color> _alertTypeColors = {
    'emergency': Colors.red.shade600,     // Vermelho
    'security': Colors.orange.shade700,   // Laranja
    'maintenance': Colors.green.shade600, // Verde
  };

  // Mock data para comentários
  final List<String> _mockComments = [
    'Estou isolando a área do Bloco A, conforme solicitado.',
    'A segurança já foi notificada sobre o veículo suspeito.',
    'O técnico do elevador deve chegar em 30 minutos.',
    'Alguém mais está com falta de água na Torre C?',
    'A tentativa de invasão foi no portão de serviço.',
    'Vazamento de gás confirmado. Por favor, evacuem.',
    'A manutenção já foi concluída, elevador liberado.',
  ];

  // Mock de Alertas EXPANDIDO e EMBARALHADO
  final List<Map<String, dynamic>> _allAlerts = [
    // --- EMERGENCY (3) ---
    {
      'id': 1,
      'type': 'emergency',
      'title': 'Vazamento de Gás - Bloco A',
      'description': 'Detectado vazamento de gás no subsolo do Bloco A. Área foi isolada e bombeiros foram acionados. Moradores dos apartamentos 101 a 110 devem evacuar imediatamente.',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'sender': 'Administração',
      'affectedAreas': 'Bloco A - Apartamentos 101 a 110',
      'priority': 'critical',
      'isRead': false,
    },
    // --- MAINTENANCE (1 - Novo topo) ---
    {
      'id': 7,
      'type': 'maintenance',
      'title': 'Rompimento de Tubulação Principal',
      'description': 'Rompimento de tubulação de esgoto na garagem subsolo. Garagem isolada. Evitar estacionar no nível -1.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      'sender': 'Síndico',
      'affectedAreas': 'Garagem Subsolo - Nível -1',
      'priority': 'critical',
      'isRead': false,
    },
    // --- SECURITY (1) ---
    {
      'id': 2,
      'type': 'security',
      'title': 'Tentativa de Invasão',
      'description': 'Câmeras de segurança registraram tentativa de invasão no portão lateral às 02:30h. Suspeito foi afugentado pelo segurança. Reforçar atenção nos próximos dias.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'sender': 'Equipe de Segurança',
      'affectedAreas': 'Portão lateral - Área de serviço',
      'priority': 'high',
      'isRead': false,
    },
    // --- MAINTENANCE (2) ---
    {
      'id': 3,
      'type': 'maintenance',
      'title': 'Manutenção do Elevador',
      'description': 'Elevador social do Bloco B apresentou falha no sistema de segurança. Manutenção emergencial será realizada hoje. Utilizem o elevador de serviço.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 4)),
      'sender': 'Síndico',
      'affectedAreas': 'Bloco B - Elevador Social',
      'estimatedResolution': 'Hoje até 18:00h',
      'priority': 'medium',
      'isRead': true,
    },
    // --- SECURITY (2) ---
    {
      'id': 4,
      'type': 'security',
      'title': 'Veículo Suspeito',
      'description': 'Veículo não identificado permanece estacionado na rua há 3 dias. Placa parcialmente coberta. Moradores devem ficar atentos e reportar movimentações.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 6)),
      'sender': 'Maria Santos - Apt 205',
      'affectedAreas': 'Rua principal - Em frente ao portão',
      'priority': 'medium',
      'isRead': true,
    },
    // --- EMERGENCY (2) ---
    {
      'id': 6,
      'type': 'emergency',
      'title': 'Incêndio em Lixeira Externa',
      'description': 'Pequeno foco de incêndio em lixeira externa controlado pela vigilância. Não há risco de propagação, mas a área deve ser evitada.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 8)),
      'sender': 'Equipe de Segurança',
      'affectedAreas': 'Área de Lazer - Próximo ao Bloco B',
      'priority': 'high',
      'isRead': false,
    },
    // --- MAINTENANCE (3) ---
    {
      'id': 9,
      'type': 'maintenance',
      'title': 'Limpeza da Caixa d\'Água',
      'description': 'Limpeza anual da caixa d\'água da Torre A será realizada. Moradores terão interrupção no abastecimento das 08h às 12h.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 12)),
      'sender': 'Administração',
      'affectedAreas': 'Torre A',
      'estimatedResolution': 'Amanhã 12:00h',
      'priority': 'low',
      'isRead': true,
    },
    // --- SECURITY (3) ---
    {
      'id': 8,
      'type': 'security',
      'title': 'Animal Solto no Condomínio',
      'description': 'Cachorro de porte médio solto na área comum próximo ao playground. Tentativa de captura em andamento.',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'sender': 'Vigilância',
      'affectedAreas': 'Área Comum e Playground',
      'priority': 'low',
      'isRead': true,
    },
    // --- EMERGENCY (3) ---
    {
      'id': 5,
      'type': 'emergency',
      'title': 'Falta de Água - Torre C',
      'description': 'Problema na bomba d\'água afetou o abastecimento da Torre C. Técnico já foi acionado. Previsão de normalização em 4 horas.',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'sender': 'Administração',
      'affectedAreas': 'Torre C - Todos os apartamentos',
      'estimatedResolution': 'Hoje até 20:00h',
      'priority': 'high',
      'isRead': true,
    },
  ];

  List<Map<String, dynamic>> get _filteredAlerts {
    if (_selectedFilter == 'all') {
      // Ordena por timestamp (mais recente primeiro)
      return List<Map<String, dynamic>>.from(_allAlerts)
        ..sort((a, b) => (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));
    }
    return _allAlerts
        .where((alert) => alert['type'] == _selectedFilter)
        .toList();
  }

  // Lógica de navegação para o Footer
  void _handleTabNavigation(BuildContext context, int index) {
    String route = '';
    switch (index) {
      case 0:
        route = AppRoutes.communityFeed;
        break;
      case 1:
        route = AppRoutes.profile;
        break;
      case 2:
        route = AppRoutes.messages;
        break;
      case 3:
        return; 
      case 4:
        route = AppRoutes.profile; 
        break;
    }

    if (route.isNotEmpty) {
      Navigator.pushNamed(context, route); 
    }
  }
  
  // FUNÇÕES DE AÇÃO ATUALIZADAS PARA RECEBER BUILDCONTEXT
  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Filtrar Alertas',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildFilterOption('all', 'Todos os alertas', 'list'),
            _buildFilterOption('emergency', 'Emergências', 'emergency'),
            _buildFilterOption('security', 'Segurança', 'lock'), // Ícone ajustado
            _buildFilterOption('maintenance', 'Manutenção', 'construction'), // Ícone ajustado
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String value, String label, String icon) {
    final isSelected = _selectedFilter == value;
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: isSelected
            ? AppTheme.lightTheme.colorScheme.primary
            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        size: 6.w, // Tamanho ajustado
      ),
      title: Text(
        label,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      trailing: isSelected
          ? CustomIconWidget(
              iconName: 'check',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 4.w,
            )
          : null,
      onTap: () {
        setState(() {
          _selectedFilter = value;
        });
        Navigator.pop(context);
      },
    );
  }

  void _handleAlertAction(BuildContext context, Map<String, dynamic> alert) {
    final alertType = alert['type'] as String;

    if (alertType == 'emergency') {
      _callEmergency(context);
    } else if (alertType == 'security') {
      _markAsRead(context, alert);
    } else if (alertType == 'maintenance') {
      _showAlertDetails(context, alert);
    }
  }

  void _handleSecondaryAction(BuildContext context, Map<String, dynamic> alert) {
    final alertType = alert['type'] as String;

    if (alertType == 'security') {
      _showAlertDetails(context, alert);
    }
  }

  void _callEmergency(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'phone',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(
              'Ligar Emergência',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          'Deseja ligar para os serviços de emergência?\n\nBombeiros: 193\nPolícia: 190\nSAMU: 192',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Ligando para emergência...'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: const Text('Ligar'),
          ),
        ],
      ),
    );
  }

  void _markAsRead(BuildContext context, Map<String, dynamic> alert) {
    setState(() {
      alert['isRead'] = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Alerta marcado como lido'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareAlert(BuildContext context, Map<String, dynamic> alert) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Compartilhando: ${alert['title']}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAlertDetails(BuildContext context, Map<String, dynamic> alert) {
    final alertType = alert['type'] as String;
    // Filtrar comentários relevantes
    final comments = _mockComments.where((c) => c.toLowerCase().contains(alertType) || c.contains('Bomba')).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AlertDetailsSheet(
        alert: alert,
        typeColor: _alertTypeColors[alertType]!,
        mockComments: comments.isEmpty ? ['Nenhum comentário ainda.'] : comments,
      ),
    );
  }

  void _showAlertOptions(BuildContext context, Map<String, dynamic> alert) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            // ITEM 1: Ver detalhes
            ListTile(
              visualDensity: VisualDensity.compact,
              leading: CustomIconWidget(
                iconName: 'info_outline',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              title: const Text('Ver detalhes'),
              onTap: () {
                Navigator.pop(context);
                _showAlertDetails(context, alert);
              },
            ),
            // ITEM 2: Marcar como lido
            ListTile(
              visualDensity: VisualDensity.compact,
              leading: CustomIconWidget(
                iconName: 'visibility',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
              title: const Text('Marcar como lido'),
              onTap: () {
                Navigator.pop(context);
                _markAsRead(context, alert);
              },
            ),
            // ITEM 3: Compartilhar
            ListTile(
              visualDensity: VisualDensity.compact,
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 5.w,
              ),
              title: const Text('Compartilhar'),
              onTap: () {
                Navigator.pop(context);
                _shareAlert(context, alert);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshAlerts() async {
    setState(() {
      _isRefreshing = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    if (_allAlerts.isNotEmpty) {
      setState(() {
        // Simulação de atualização de timestamp
        _allAlerts.first['timestamp'] = DateTime.now().subtract(const Duration(minutes: 1));
        _isRefreshing = false;
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Alertas atualizados'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const int currentIndex = 3; 

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        title: Text(
          'Alertas Urgentes',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: () => _showFilterOptions(context),
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          AlertFilterWidget(
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },
            typeColors: _alertTypeColors, // Passando o mapa de cores
          ),

          // Alerts list or empty state
          Expanded(
            child: _filteredAlerts.isEmpty
                ? const EmptyAlertsWidget()
                : RefreshIndicator(
                    onRefresh: _refreshAlerts,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 2.h),
                      itemCount: _filteredAlerts.length,
                      itemBuilder: (context, index) {
                        final alert = _filteredAlerts[index];
                        return Dismissible(
                          key: Key('alert_${alert['id']}'),
                          direction: DismissDirection.horizontal,
                          background: Container(
                            color: AppTheme.lightTheme.colorScheme.primary.withOpacity(0.1),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'visibility',
                                  color: AppTheme.lightTheme.colorScheme.primary,
                                  size: 6.w,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'Marcar como lido',
                                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          secondaryBackground: Container(
                            color: AppTheme.lightTheme.colorScheme.secondary.withOpacity(0.1),
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Compartilhar',
                                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme.secondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                SizedBox(width: 2.w),
                                CustomIconWidget(
                                  iconName: 'share',
                                  color: AppTheme.lightTheme.colorScheme.secondary,
                                  size: 6.w,
                                ),
                              ],
                            ),
                          ),
                          onDismissed: (direction) {
                            if (direction == DismissDirection.startToEnd) {
                              _markAsRead(context, alert);
                            } else {
                              _shareAlert(context, alert);
                            }
                          },
                          child: AlertCardWidget(
                            alert: alert,
                            // Asseguramos que o onActionPressed e onSecondaryActionPressed usem o context
                            onActionPressed: () => _handleAlertAction(context, alert), 
                            onSecondaryActionPressed: () => _handleSecondaryAction(context, alert),
                            onMarkAsRead: () => _showAlertOptions(context, alert),
                            typeColors: _alertTypeColors, 
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      
      // BOTTOM NAVIGATION BAR (Footer)
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
              color: currentIndex == 2 ? AppTheme.lightTheme.colorScheme.primary : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Mensagens',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'notifications',
              color: AppTheme.lightTheme.colorScheme.primary, 
              size: 6.w,
            ),
            label: 'Alertas',
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
