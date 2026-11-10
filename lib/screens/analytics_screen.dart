import 'package:flutter/material.dart';
import '../providers/expense_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/custom_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  final ExpenseProvider provider;

  const AnalyticsScreen({
    super.key,
    required this.provider,
  });

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _activeHorizon = 'month'; // 'week', 'month', 'ytd'
  String _activeTrajectoryPeriod = 'M'; // 'W', 'M', '6M', '1Y'

  final Map<String, List<double>> _trajectoryData = {
    'W': [0.4, 0.7, 0.5, 0.8, 0.6, 0.9, 0.75],
    'M': [0.25, 0.45, 0.35, 0.75, 0.55, 0.95, 0.65],
    '6M': [0.3, 0.5, 0.65, 0.45, 0.8, 0.7, 0.88],
    '1Y': [0.2, 0.4, 0.5, 0.6, 0.7, 0.85, 0.92],
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalIn = widget.provider.totalIncome;
    final totalOut = widget.provider.totalExpense;
    final netFlow = totalIn - totalOut;

    // Calcular velocidad diaria aproximada
    final dailyVelocity = totalOut > 0 ? (totalOut / 30) : 0.0;

    // Distribución de categorías
    final categoryMap = widget.provider.getExpenseDistribution();
    final totalExpense = totalOut > 0 ? totalOut : 1.0;

    final categoryColors = [
      AppTheme.primaryObsidian,
      AppTheme.secondarySlate,
      const Color(0xFF8A8D93),
      const Color(0xFFB0B3B8),
      const Color(0xFFD5D2CC),
    ];

    final sortedCategories = categoryMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final percentages =
        sortedCategories.map((e) => e.value / totalExpense).toList();

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
              'Analytics & Trajectory',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selector de Horizonte Temporal (Tabs superiores tipo píldora)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF222327)
                        : AppTheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHorizonTab('week', 'Esta Semana'),
                      _buildHorizonTab('month', 'Este Mes'),
                      _buildHorizonTab('ytd', 'Año a la fecha'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Tarjeta de Síntesis Ejecutiva "Aura Synthesis"
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E2024) : AppTheme.surfaceLow,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF2C2D32)
                        : AppTheme.outlineHairline,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      size: 20,
                      color: AppTheme.primaryObsidian,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'AURA SYNTHESIS',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.0,
                                  color: isDark
                                      ? Colors.white70
                                      : AppTheme.secondarySlate,
                                ),
                              ),
                              const Text(
                                'Actualizado hoy',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppTheme.tertiaryCashmere,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Tu ritmo de gasto discrecional disminuyó un 14% respecto al ciclo anterior.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : AppTheme.primaryObsidian,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'La moderación constante en ocio y restaurantes te sitúa 6 días por delante de tu meta de liquidez.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.secondarySlate,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Métrica de Flujo Neto y Velocidad de Consumo
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color:
                      isDark ? const Color(0xFF1B1C1F) : AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF2C2D32)
                        : AppTheme.outlineHairline,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'FLUJO NETO DEL PERIODO',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.0,
                                color: AppTheme.secondarySlate,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${netFlow >= 0 ? "+" : "-"}${widget.provider.currencySymbol}${netFlow.abs().toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w400,
                                color: netFlow >= 0
                                    ? AppTheme.incomeGreen
                                    : AppTheme.expenseRed,
                                fontFamily: 'serif',
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF242529)
                                : AppTheme.surfaceContainer,
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusSm),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.local_fire_department,
                                    size: 14,
                                    color: AppTheme.primaryObsidian,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${widget.provider.currencySymbol}${dailyVelocity.toStringAsFixed(0)} / día',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Text(
                                'Consumo diario',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppTheme.tertiaryCashmere,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Barras comparativas Salida vs Entrada
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                CircleAvatar(
                                  radius: 3.5,
                                  backgroundColor: AppTheme.primaryObsidian,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Egresos Totales',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.secondarySlate),
                                ),
                              ],
                            ),
                            Text(
                              '${widget.provider.currencySymbol}${totalOut.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: totalIn > 0
                                ? (totalOut / totalIn).clamp(0.0, 1.0)
                                : 0.5,
                            backgroundColor: AppTheme.surfaceContainer,
                            color: AppTheme.primaryObsidian,
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                CircleAvatar(
                                  radius: 3.5,
                                  backgroundColor: AppTheme.incomeGreen,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Ingresos Totales',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.secondarySlate),
                                ),
                              ],
                            ),
                            Text(
                              '${widget.provider.currencySymbol}${totalIn.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: const LinearProgressIndicator(
                            value: 1.0,
                            backgroundColor: AppTheme.surfaceContainer,
                            color: AppTheme.incomeGreen,
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Gráfica de Trayectoria Editorial (Net Cash Velocity SVG)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color:
                      isDark ? const Color(0xFF1B1C1F) : AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF2C2D32)
                        : AppTheme.outlineHairline,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TRAYECTORIA',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.0,
                                color: AppTheme.secondarySlate,
                              ),
                            ),
                            Text(
                              'Velocidad de Flujo',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : AppTheme.primaryObsidian,
                              ),
                            ),
                          ],
                        ),
                        // Selector W, M, 6M, 1Y
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF242529)
                                : AppTheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: ['W', 'M', '6M', '1Y'].map((p) {
                              final isSelected = _activeTrajectoryPeriod == p;
                              return GestureDetector(
                                onTap: () =>
                                    setState(() => _activeTrajectoryPeriod = p),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? (isDark
                                            ? Colors.white
                                            : AppTheme.primaryObsidian)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    p,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? (isDark
                                              ? AppTheme.primaryObsidian
                                              : Colors.white)
                                          : AppTheme.secondarySlate,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    VelocityTrajectoryChart(
                      points: _trajectoryData[_activeTrajectoryPeriod] ??
                          [0.3, 0.6, 0.4, 0.8, 0.5, 0.9, 0.7],
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Día 01',
                            style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.tertiaryCashmere)),
                        Text('Día 08',
                            style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.tertiaryCashmere)),
                        Text('Día 15',
                            style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.tertiaryCashmere)),
                        Text('Día 22',
                            style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.tertiaryCashmere)),
                        Text('Día 30',
                            style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.tertiaryCashmere)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Distribución de Capital y Desglose de Categorías
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color:
                      isDark ? const Color(0xFF1B1C1F) : AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF2C2D32)
                        : AppTheme.outlineHairline,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'DISTRIBUCIÓN DE CAPITAL',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.0,
                                color: AppTheme.secondarySlate,
                              ),
                            ),
                            Text(
                              'Porcentaje por Categoría',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : AppTheme.primaryObsidian,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${sortedCategories.length} categorías',
                          style: const TextStyle(
                              fontSize: 11, color: AppTheme.tertiaryCashmere),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Barra segmentada horizontal
                    if (percentages.isNotEmpty)
                      CategorySegmentedBar(
                        percentages: percentages,
                        colors: categoryColors,
                      ),

                    const SizedBox(height: 16),

                    // Lista detallada de categorías
                    ...List.generate(sortedCategories.length, (i) {
                      final item = sortedCategories[i];
                      final pct = (item.value / totalExpense) * 100;
                      final color = categoryColors[i % categoryColors.length];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                item.key,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              '${widget.provider.currencySymbol}${item.value.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 44,
                              child: Text(
                                '${pct.toStringAsFixed(0)}%',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.secondarySlate,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizonTab(String id, String label) {
    final isSelected = _activeHorizon == id;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => setState(() => _activeHorizon = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.white : AppTheme.primaryObsidian)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? (isDark ? AppTheme.primaryObsidian : Colors.white)
                : AppTheme.secondarySlate,
          ),
        ),
      ),
    );
  }
}
