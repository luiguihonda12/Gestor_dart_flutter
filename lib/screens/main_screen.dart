import 'package:flutter/material.dart';
import '../providers/expense_provider.dart';
import '../utils/app_theme.dart';
import 'add_transaction_screen.dart';
import 'analytics_screen.dart';
import 'daily_ledger_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  final ExpenseProvider provider;

  const MainScreen({
    super.key,
    required this.provider,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final screens = [
      // 1. Vista donde ver los datos por día
      DailyLedgerScreen(
        provider: widget.provider,
        onAddPressed: () => _onTabSelected(1),
      ),
      // 2. Vista para ingresar ingresos y egresos
      AddTransactionScreen(
        provider: widget.provider,
        onTransactionAdded: () => _onTabSelected(0),
      ),
      // 3. Vista de gráficas
      AnalyticsScreen(
        provider: widget.provider,
      ),
      // 4. Vista de ajustes
      SettingsScreen(
        provider: widget.provider,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF16171A) : AppTheme.surfaceCard,
          border: Border(
            top: BorderSide(
              color:
                  isDark ? const Color(0xFF2C2D32) : AppTheme.outlineHairline,
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.calendar_today_outlined,
                  activeIcon: Icons.calendar_today,
                  label: 'Por Día',
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.add_circle_outline,
                  activeIcon: Icons.add_circle,
                  label: 'Ingreso/Egreso',
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.insights_outlined,
                  activeIcon: Icons.insights,
                  label: 'Gráficas',
                ),
                _buildNavItem(
                  index: 3,
                  icon: Icons.tune_outlined,
                  activeIcon: Icons.tune,
                  label: 'Ajustes',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? Colors.white : AppTheme.primaryObsidian;
    final inactiveColor = isDark ? Colors.white38 : AppTheme.secondarySlate;

    return InkWell(
      onTap: () => _onTabSelected(index),
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 22,
              color: isSelected ? activeColor : inactiveColor,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? activeColor : inactiveColor,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
