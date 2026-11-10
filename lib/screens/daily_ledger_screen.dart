import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../providers/expense_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/transaction_tile.dart';

class DailyLedgerScreen extends StatefulWidget {
  final ExpenseProvider provider;
  final VoidCallback onAddPressed;

  const DailyLedgerScreen({
    super.key,
    required this.provider,
    required this.onAddPressed,
  });

  @override
  State<DailyLedgerScreen> createState() => _DailyLedgerScreenState();
}

class _DailyLedgerScreenState extends State<DailyLedgerScreen> {
  String _filterType = 'all'; // 'all', 'income', 'expense'

  String _formatDateTitle(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);

    if (target == today) {
      return 'Hoy';
    } else if (target == today.subtract(const Duration(days: 1))) {
      return 'Ayer';
    } else if (target == today.add(const Duration(days: 1))) {
      return 'Mañana';
    }

    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];
    return '${date.day} de ${months[date.month - 1]} ${date.year}';
  }

  void _changeDay(int offset) {
    final newDate = widget.provider.selectedDate.add(Duration(days: offset));
    widget.provider.setSelectedDate(newDate);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.provider.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryObsidian,
              onPrimary: Colors.white,
              surface: AppTheme.surfaceCard,
              onSurface: AppTheme.primaryObsidian,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      widget.provider.setSelectedDate(picked);
    }
  }

  void _showTransactionDetails(TransactionItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLg)),
      ),
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.isIncome ? 'DETALLE DE INGRESO' : 'DETALLE DE GASTO',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: AppTheme.secondarySlate,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.primaryObsidian,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.isIncome ? "+" : "-"}${widget.provider.currencySymbol}${item.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: item.isIncome
                        ? AppTheme.incomeGreen
                        : AppTheme.primaryObsidian,
                    fontFamily: 'serif',
                  ),
                ),
                const Divider(height: 28, color: AppTheme.outlineHairline),
                _buildDetailRow('Categoría', item.categoryName),
                _buildDetailRow('Método de Pago', item.paymentMethod),
                _buildDetailRow('Fecha y Hora',
                    '${item.date.day}/${item.date.month}/${item.date.year} ${item.date.hour}:${item.date.minute.toString().padLeft(2, '0')}'),
                if (item.notes.isNotEmpty) _buildDetailRow('Nota', item.notes),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      widget.provider.deleteTransaction(item.id);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Movimiento eliminado.')),
                      );
                    },
                    icon: const Icon(Icons.delete_outline,
                        color: AppTheme.expenseRed),
                    label: const Text('Eliminar Movimiento',
                        style: TextStyle(color: AppTheme.expenseRed)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.outlineHairline),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMd)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13, color: AppTheme.secondarySlate)),
          Text(value,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentDate = widget.provider.selectedDate;
    final allDayItems = widget.provider.getTransactionsForDay(currentDate);

    final filteredItems = allDayItems.where((item) {
      if (_filterType == 'income') return item.isIncome;
      if (_filterType == 'expense') return item.isExpense;
      return true;
    }).toList();

    final dayIncome = widget.provider.getTotalIncomeForDay(currentDate);
    final dayExpense = widget.provider.getTotalExpenseForDay(currentDate);
    final dayNet = dayIncome - dayExpense;

    final isToday = DateTime(
            currentDate.year, currentDate.month, currentDate.day) ==
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

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
              'Chronicle / Daily',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.secondarySlate,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color:
                  isDark ? const Color(0xFF242529) : AppTheme.surfaceContainer,
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppTheme.incomeGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Sync Active',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.secondarySlate,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Barra selectora de día (Navegación por días)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1B1C1F) : AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF2C2D32)
                      : AppTheme.outlineHairline,
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 22),
                    onPressed: () => _changeDay(-1),
                    tooltip: 'Día anterior',
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: _pickDate,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.calendar_month_outlined,
                                size: 16,
                                color: AppTheme.secondarySlate,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _formatDateTitle(currentDate),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.white
                                      : AppTheme.primaryObsidian,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${currentDate.day}/${currentDate.month}/${currentDate.year}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.tertiaryCashmere,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, size: 22),
                    onPressed: () => _changeDay(1),
                    tooltip: 'Día siguiente',
                  ),
                  if (!isToday) ...[
                    GestureDetector(
                      onTap: () =>
                          widget.provider.setSelectedDate(DateTime.now()),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryObsidian,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Hoy',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ],
              ),
            ),

            // Tarjeta de Resumen del Día
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'BALANCE NETO DEL DÍA',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: AppTheme.secondarySlate,
                        ),
                      ),
                      Text(
                        '${allDayItems.length} movimientos',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.tertiaryCashmere,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '${dayNet >= 0 ? "+" : "-"}${widget.provider.currencySymbol}${dayNet.abs().toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                          color: dayNet >= 0
                              ? AppTheme.incomeGreen
                              : AppTheme.expenseRed,
                          fontFamily: 'serif',
                        ),
                      ),
                      Row(
                        children: [
                          _buildIndicator(
                            label: 'Ingresos',
                            amount: dayIncome,
                            color: AppTheme.incomeGreen,
                            icon: Icons.arrow_upward,
                          ),
                          const SizedBox(width: 14),
                          _buildIndicator(
                            label: 'Gastos',
                            amount: dayExpense,
                            color: AppTheme.expenseRed,
                            icon: Icons.arrow_downward,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Filtros rápidos (Todos, Gastos, Ingresos)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  _buildFilterChip('all', 'Todos (${allDayItems.length})'),
                  const SizedBox(width: 8),
                  _buildFilterChip('expense', 'Gastos'),
                  const SizedBox(width: 8),
                  _buildFilterChip('income', 'Ingresos'),
                ],
              ),
            ),

            // Lista de Movimientos del Día
            Expanded(
              child: filteredItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 48,
                            color:
                                isDark ? Colors.white24 : AppTheme.surfaceDim,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Sin registros para este día',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white70
                                  : AppTheme.secondarySlate,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Añade un gasto o ingreso para comenzar el registro.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.tertiaryCashmere,
                            ),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: widget.onAddPressed,
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text('Registrar Movimiento'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: isDark
                                  ? Colors.white
                                  : AppTheme.primaryObsidian,
                              side: const BorderSide(
                                  color: AppTheme.outlineHairline),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppTheme.radiusMd),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 4),
                      itemCount: filteredItems.length,
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        color: AppTheme.outlineHairline,
                      ),
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return TransactionTile(
                          transaction: item,
                          currencySymbol: widget.provider.currencySymbol,
                          onTap: () => _showTransactionDetails(item),
                          onDelete: () {
                            widget.provider.deleteTransaction(item.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Movimiento eliminado')),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator({
    required String label,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 2),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 10, color: AppTheme.tertiaryCashmere),
            ),
          ],
        ),
        Text(
          '${widget.provider.currencySymbol}${amount.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String type, String label) {
    final isSelected = _filterType == type;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        setState(() {
          _filterType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.white : AppTheme.primaryObsidian)
              : (isDark ? const Color(0xFF242529) : AppTheme.surfaceContainer),
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected
                ? (isDark ? AppTheme.primaryObsidian : Colors.white)
                : AppTheme.secondarySlate,
          ),
        ),
      ),
    );
  }
}
