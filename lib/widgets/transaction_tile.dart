import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../utils/app_theme.dart';

class TransactionTile extends StatelessWidget {
  final TransactionItem transaction;
  final String currencySymbol;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const TransactionTile({
    super.key,
    required this.transaction,
    required this.currencySymbol,
    this.onDelete,
    this.onTap,
  });

  String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isIncome = transaction.isIncome;

    return Dismissible(
      key: Key(transaction.id),
      direction: onDelete != null
          ? DismissDirection.endToStart
          : DismissDirection.none,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppTheme.expenseRed,
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => onDelete?.call(),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
          child: Row(
            children: [
              // Icono de categoría en contenedor circular
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF242529)
                      : (isIncome
                          ? const Color(0xFFE9F1EC)
                          : AppTheme.surfaceContainer),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  transaction.categoryIcon,
                  size: 20,
                  color: isIncome
                      ? AppTheme.incomeGreen
                      : (isDark ? Colors.white70 : AppTheme.primaryObsidian),
                ),
              ),
              const SizedBox(width: 14),

              // Título y categoría / hora
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppTheme.primaryObsidian,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${transaction.categoryName} · ${_formatTime(transaction.date)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white54 : AppTheme.tertiaryCashmere,
                      ),
                    ),
                  ],
                ),
              ),

              // Monto y estado/método
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isIncome ? "+" : "-"}$currencySymbol${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isIncome
                          ? AppTheme.incomeGreen
                          : (isDark ? Colors.white : AppTheme.primaryObsidian),
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    transaction.paymentMethod,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.white38 : AppTheme.tertiaryCashmere,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
