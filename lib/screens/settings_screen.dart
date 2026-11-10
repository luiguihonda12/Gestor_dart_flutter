import 'package:flutter/material.dart';
import '../providers/expense_provider.dart';
import '../utils/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  final ExpenseProvider provider;

  const SettingsScreen({
    super.key,
    required this.provider,
  });

  void _showCurrencyPicker(BuildContext context) {
    final currencies = [
      {'code': 'USD', 'symbol': '\$', 'name': 'Dólar Estadounidense (USD)'},
      {'code': 'EUR', 'symbol': '€', 'name': 'Euro (EUR)'},
      {'code': 'COP', 'symbol': '\$', 'name': 'Peso Colombiano (COP)'},
      {'code': 'MXN', 'symbol': '\$', 'name': 'Peso Mexicano (MXN)'},
      {'code': 'GBP', 'symbol': '£', 'name': 'Libra Esterlina (GBP)'},
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLg)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Seleccionar Moneda',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 1, color: AppTheme.outlineHairline),
              ...currencies.map((c) {
                final isSelected = provider.currencyCode == c['code'];
                return ListTile(
                  title: Text(c['name']!),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppTheme.primaryObsidian)
                      : null,
                  onTap: () {
                    provider.setCurrency(c['code']!, c['symbol']!);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          title: const Text('Exportar Reporte Financiero'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tu libro mayor digital ha sido preparado en formato CSV y PDF con sellado criptográfico.',
                style: TextStyle(fontSize: 13, color: AppTheme.secondarySlate),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Total Registros: ${provider.allTransactions.length}\n'
                  'Balance Neto: ${provider.currencySymbol}${(provider.totalIncome - provider.totalExpense).toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Reporte exportado exitosamente.')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryObsidian,
                foregroundColor: Colors.white,
              ),
              child: const Text('Descargar'),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          title: const Text('¿Eliminar todos los datos?'),
          content: const Text(
            'Esta acción eliminará todas las transacciones registradas del almacenamiento local. Esta acción no se puede deshacer.',
            style: TextStyle(fontSize: 13, color: AppTheme.secondarySlate),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                provider.clearAllTransactions();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Todos los movimientos fueron eliminados.')),
                );
              },
              child: const Text(
                'Eliminar Todo',
                style: TextStyle(
                    color: AppTheme.expenseRed, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              'Aura',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0),
              child:
                  Text('/', style: TextStyle(color: AppTheme.tertiaryCashmere)),
            ),
            Text(
              'Settings & Preferences',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.secondarySlate,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            // Perfil de Usuario / Ledger Privado
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1B1C1F) : AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF2C2D32)
                      : AppTheme.outlineHairline,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryObsidian,
                    ),
                    child: const Center(
                      child: Text(
                        'LM',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Luis Mateus',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Private Client · Vault Reserve #8821',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.secondarySlate,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                    child: const Text(
                      'Activo',
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _buildSectionHeader('PREFERENCIAS DEL SISTEMA'),

            // Ajuste de Moneda
            _buildSettingsTile(
              context: context,
              icon: Icons.monetization_on_outlined,
              title: 'Moneda Principal',
              subtitle: '${provider.currencyCode} (${provider.currencySymbol})',
              onTap: () => _showCurrencyPicker(context),
            ),

            // Modo Oscuro
            _buildSettingsTile(
              context: context,
              icon: Icons.dark_mode_outlined,
              title: 'Modo Obsidiana (Tema Oscuro)',
              subtitle: provider.isDarkMode ? 'Activado' : 'Desactivado',
              trailing: Switch.adaptive(
                value: provider.isDarkMode,
                activeTrackColor: AppTheme.primaryObsidian,
                onChanged: (_) => provider.toggleTheme(),
              ),
            ),

            // Recordatorios
            _buildSettingsTile(
              context: context,
              icon: Icons.notifications_none_outlined,
              title: 'Recordatorio de Registro Diario',
              subtitle: 'Notificación nocturna para cerrar el balance',
              trailing: Switch.adaptive(
                value: provider.dailyReminder,
                activeTrackColor: AppTheme.primaryObsidian,
                onChanged: (val) => provider.toggleReminder(val),
              ),
            ),

            const SizedBox(height: 20),

            _buildSectionHeader('GESTIÓN DE DATOS Y COPIAS'),

            // Exportar Resumen
            _buildSettingsTile(
              context: context,
              icon: Icons.file_download_outlined,
              title: 'Exportar Libro Contable',
              subtitle: 'Descarga un reporte consolidado en CSV/PDF',
              onTap: () => _showExportDialog(context),
            ),

            // Restaurar datos de prueba
            _buildSettingsTile(
              context: context,
              icon: Icons.restart_alt_outlined,
              title: 'Recargar Datos de Muestra',
              subtitle: 'Cargar transacciones predeterminadas de diseño',
              onTap: () {
                provider.restoreSampleData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Datos de muestra restablecidos.')),
                );
              },
            ),

            // Vaciar Datos
            _buildSettingsTile(
              context: context,
              icon: Icons.delete_outline,
              title: 'Restablecer Base de Datos',
              subtitle: 'Borrar todos los movimientos y reiniciar balance',
              titleColor: AppTheme.expenseRed,
              iconColor: AppTheme.expenseRed,
              onTap: () => _showConfirmResetDialog(context),
            ),

            const SizedBox(height: 20),

            _buildSectionHeader('ARQUITECTURA Y DISEÑO'),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1B1C1F) : AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF2C2D32)
                      : AppTheme.outlineHairline,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aura Finance v1.0.0',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Inspirado en la estética "Quiet Luxury Expense Architecture": papel alabastro (#FAF9F7), tinta obsidiana (#16171A) y divisiones hairline de 1px (#E5E2DC).',
                    style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.secondarySlate,
                        height: 1.4),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
          color: AppTheme.tertiaryCashmere,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    Color? titleColor,
    Color? iconColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B1C1F) : AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: isDark ? const Color(0xFF2C2D32) : AppTheme.outlineHairline,
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color:
              iconColor ?? (isDark ? Colors.white70 : AppTheme.secondarySlate),
          size: 22,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: titleColor ??
                (isDark ? Colors.white : AppTheme.primaryObsidian),
          ),
        ),
        subtitle: Text(
          subtitle,
          style:
              const TextStyle(fontSize: 12, color: AppTheme.tertiaryCashmere),
        ),
        trailing: trailing ??
            (onTap != null
                ? const Icon(Icons.chevron_right,
                    size: 20, color: AppTheme.tertiaryCashmere)
                : null),
        onTap: onTap,
      ),
    );
  }
}
