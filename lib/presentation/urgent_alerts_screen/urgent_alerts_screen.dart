import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
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

  final List<Map<String, dynamic>> _allAlerts = [
    {
      'id': 1,
      'type': 'emergency',
      'title': 'Vazamento de Gás - Bloco A',
      'description':
          'Detectado vazamento de gás no subsolo do Bloco A. Área foi isolada e bombeiros foram acionados. Moradores dos apartamentos 101 a 110 devem evacuar imediatamente.',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'sender': 'Administração',
      'affectedAreas': 'Bloco A - Apartamentos 101 a 110',
      'priority': 'critical',
      'isRead': false,
    },
    {
      'id': 2,
      'type': 'security',
      'title': 'Tentativa de Invasão',
      'description':
          'Câmeras de segurança registraram tentativa de invasão no portão lateral às 02:30h. Suspeito foi afugentado pelo segurança. Reforçar atenção nos próximos dias.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'sender': 'Equipe de Segurança',
      'affectedAreas': 'Portão lateral - Área de serviço',
      'priority': 'high',
      'isRead': false,
    },
    {
      'id': 3,
      'type': 'maintenance',
      'title': 'Manutenção do Elevador',
      'description':
          'Elevador social do Bloco B apresentou falha no sistema de segurança. Manutenção emergencial será realizada hoje. Utilizem o elevador de serviço.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 4)),
      'sender': 'Síndico',
      'affectedAreas': 'Bloco B - Elevador Social',
      'estimatedResolution': 'Hoje até 18:00h',
      'priority': 'medium',
      'isRead': true,
    },
    {
      'id': 4,
      'type': 'security',
      'title': 'Veículo Suspeito',
      'description':
          'Veículo não identificado permanece estacionado na rua há 3 dias. Placa parcialmente coberta. Moradores devem ficar atentos e reportar movimentações.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 6)),
      'sender': 'Maria Santos - Apt 205',
      'affectedAreas': 'Rua principal - Em frente ao portão',
      'priority': 'medium',
      'isRead': true,
    },
    {
      'id': 5,
      'type': 'maintenance',
      'title': 'Falta de Água - Torre C',
      'description':
          'Problema na bomba d\'água afetou o abastecimento da Torre C. Técnico já foi acionado. Previsão de normalização em 4 horas.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 8)),
      'sender': 'Administração',
      'affectedAreas': 'Torre C - Todos os apartamentos',
      'estimatedResolution': 'Hoje até 20:00h',
      'priority': 'high',
      'isRead': true,
    },
  ];

  List<Map<String, dynamic>> get _filteredAlerts {
    if (_selectedFilter == 'all') {
      return _allAlerts;
    }
    return _allAlerts
        .where((alert) => alert['type'] == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
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
            size: 24,
          ),
        ),
        title: Text(
          'Alertas Urgentes',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: _showFilterOptions,
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
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
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'visibility',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 24,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'Marcar como lido',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          secondaryBackground: Container(
                            color: AppTheme.lightTheme.colorScheme.secondary
                                .withValues(alpha: 0.1),
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Compartilhar',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.secondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                CustomIconWidget(
                                  iconName: 'share',
                                  color:
                                      AppTheme.lightTheme.colorScheme.secondary,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                          onDismissed: (direction) {
                            if (direction == DismissDirection.startToEnd) {
                              _markAsRead(alert);
                            } else {
                              _shareAlert(alert);
                            }
                          },
                          child: AlertCardWidget(
                            alert: alert,
                            onActionPressed: () => _handleAlertAction(alert),
                            onSecondaryActionPressed: () =>
                                _handleSecondaryAction(alert),
                            onMarkAsRead: () => _showAlertOptions(alert),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showFilterOptions() {
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
            _buildFilterOption('security', 'Segurança', 'security'),
            _buildFilterOption('maintenance', 'Manutenção', 'build'),
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
        size: 24,
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
              size: 20,
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

  void _handleAlertAction(Map<String, dynamic> alert) {
    final alertType = alert['type'] as String;

    if (alertType == 'emergency') {
      _callEmergency();
    } else if (alertType == 'security') {
      _markAsRead(alert);
    } else if (alertType == 'maintenance') {
      _showAlertDetails(alert);
    }
  }

  void _handleSecondaryAction(Map<String, dynamic> alert) {
    final alertType = alert['type'] as String;

    if (alertType == 'security') {
      _showAlertDetails(alert);
    }
  }

  void _callEmergency() {
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
              // In a real app, this would use url_launcher to make the call
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

  void _markAsRead(Map<String, dynamic> alert) {
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

  void _shareAlert(Map<String, dynamic> alert) {
    // In a real app, this would use the share package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Compartilhando: ${alert['title']}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAlertDetails(Map<String, dynamic> alert) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AlertDetailsSheet(alert: alert),
    );
  }

  void _showAlertOptions(Map<String, dynamic> alert) {
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
            ListTile(
              leading: CustomIconWidget(
                iconName: 'info_outline',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Ver detalhes'),
              onTap: () {
                Navigator.pop(context);
                _showAlertDetails(alert);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'visibility',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              title: const Text('Marcar como lido'),
              onTap: () {
                Navigator.pop(context);
                _markAsRead(alert);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 24,
              ),
              title: const Text('Compartilhar'),
              onTap: () {
                Navigator.pop(context);
                _shareAlert(alert);
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

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, this would fetch new alerts from the server
    // For demo purposes, we'll just add a new alert
    if (_allAlerts.isNotEmpty) {
      setState(() {
        // Update timestamps to simulate new activity
        for (var alert in _allAlerts) {
          if (alert['id'] == 1) {
            alert['timestamp'] =
                DateTime.now().subtract(const Duration(minutes: 2));
          }
        }
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
}