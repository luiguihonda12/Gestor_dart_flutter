import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../providers/expense_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/custom_keypad.dart';

class AddTransactionScreen extends StatefulWidget {
  final ExpenseProvider provider;
  final VoidCallback? onTransactionAdded;

  const AddTransactionScreen({
    super.key,
    required this.provider,
    this.onTransactionAdded,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  TransactionType _currentType = TransactionType.expense;
  String _amountStr = '142.50';
  bool _isInitialState = true;

  late TransactionCategory _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  String _selectedPaymentMethod = 'Amex •••• 4012';
  final TextEditingController _noteController =
      TextEditingController(text: 'Dinner with client');
  final List<String> _selectedTags = ['#work', '#reimbursable'];
  bool _showReceiptPreview = false;

  final List<String> _paymentMethods = [
    'Amex •••• 4012',
    'Chase Private Client',
    'Apple Pay',
    'Treasury Reserve',
    'Efectivo / Cash',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = TransactionCategory.defaultExpenseCategories.first;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _switchType(TransactionType type) {
    if (_currentType == type) return;
    setState(() {
      _currentType = type;
      if (type == TransactionType.expense) {
        _selectedCategory = TransactionCategory.defaultExpenseCategories.first;
        _amountStr = '142.50';
        _selectedPaymentMethod = 'Amex •••• 4012';
        _noteController.text = 'Dinner with client';
      } else {
        _selectedCategory = TransactionCategory.defaultIncomeCategories.first;
        _amountStr = '4500.00';
        _selectedPaymentMethod = 'Chase Private Client';
        _noteController.text = 'Q4 Client Retainer';
      }
      _isInitialState = true;
    });
  }

  void _onKeyPress(String key) {
    setState(() {
      if (_isInitialState) {
        _amountStr = '';
        _isInitialState = false;
      }

      if (key == '.') {
        if (!_amountStr.contains('.')) {
          _amountStr = '${_amountStr.isEmpty ? '0' : _amountStr}.';
        }
      } else {
        // Máximo 2 decimales y longitud razonable
        if (_amountStr.contains('.')) {
          final parts = _amountStr.split('.');
          if (parts[1].length < 2) {
            _amountStr += key;
          }
        } else {
          if (_amountStr.length < 7) {
            _amountStr += key;
          }
        }
      }
    });
  }

  void _onBackspace() {
    setState(() {
      if (_isInitialState) {
        _amountStr = '';
        _isInitialState = false;
        return;
      }
      if (_amountStr.isNotEmpty) {
        _amountStr = _amountStr.substring(0, _amountStr.length - 1);
      }
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
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
      setState(() {
        _selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDate.hour,
          _selectedDate.minute,
        );
      });
    }
  }

  void _submitTransaction() {
    final amount = double.tryParse(_amountStr) ?? 0.0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa un monto válido superior a 0.'),
          backgroundColor: AppTheme.expenseRed,
        ),
      );
      return;
    }

    final newTransaction = TransactionItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _noteController.text.trim().isNotEmpty
          ? _noteController.text.trim()
          : _selectedCategory.name,
      amount: amount,
      type: _currentType,
      categoryId: _selectedCategory.id,
      categoryName: _selectedCategory.name,
      categoryIcon: _selectedCategory.icon,
      date: _selectedDate,
      paymentMethod: _selectedPaymentMethod,
      notes: _noteController.text.trim(),
      tags: List.from(_selectedTags),
    );

    widget.provider.addTransaction(newTransaction);
    widget.provider.setSelectedDate(_selectedDate);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _currentType == TransactionType.expense
              ? 'Gasto de ${widget.provider.currencySymbol}${amount.toStringAsFixed(2)} registrado'
              : 'Ingreso de ${widget.provider.currencySymbol}${amount.toStringAsFixed(2)} registrado',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        backgroundColor: _currentType == TransactionType.expense
            ? AppTheme.primaryObsidian
            : AppTheme.incomeGreen,
        duration: const Duration(seconds: 2),
      ),
    );

    widget.onTransactionAdded?.call();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isExpense = _currentType == TransactionType.expense;
    final categories = isExpense
        ? TransactionCategory.defaultExpenseCategories
        : TransactionCategory.defaultIncomeCategories;

    final displayAmount = _amountStr.isEmpty ? '0.00' : _amountStr;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'Aura',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0),
              child:
                  Text('/', style: TextStyle(color: AppTheme.tertiaryCashmere)),
            ),
            Text(
              isExpense ? 'Add Expense' : 'Add Income',
              style: const TextStyle(
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Selector de Tipo: Gasto / Ingreso (Segmented Pills)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF222327)
                      : AppTheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _switchType(TransactionType.expense),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isExpense
                                ? (isDark
                                    ? Colors.white
                                    : AppTheme.primaryObsidian)
                                : Colors.transparent,
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusMd),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.remove_circle_outline,
                                size: 16,
                                color: isExpense
                                    ? (isDark
                                        ? AppTheme.primaryObsidian
                                        : Colors.white)
                                    : AppTheme.secondarySlate,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Gasto / Expense',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isExpense
                                      ? (isDark
                                          ? AppTheme.primaryObsidian
                                          : Colors.white)
                                      : AppTheme.secondarySlate,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _switchType(TransactionType.income),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: !isExpense
                                ? AppTheme.incomeGreen
                                : Colors.transparent,
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusMd),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                size: 16,
                                color: !isExpense
                                    ? Colors.white
                                    : AppTheme.secondarySlate,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Ingreso / Income',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: !isExpense
                                      ? Colors.white
                                      : AppTheme.secondarySlate,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Visualizador de Monto Editorial
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          isExpense ? '-' : '+',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w300,
                            color: isExpense
                                ? AppTheme.secondarySlate
                                : AppTheme.incomeGreen,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.provider.currencySymbol,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w300,
                            color: AppTheme.secondarySlate,
                            fontFamily: 'serif',
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          displayAmount,
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -1.0,
                            color: isDark
                                ? Colors.white
                                : AppTheme.primaryObsidian,
                            fontFamily: 'serif',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Toca el teclado para ajustar la cifra',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w500,
                        color:
                            isDark ? Colors.white54 : AppTheme.tertiaryCashmere,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Selector de Categoría (Horizontal scroll)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'CATEGORÍA',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            color: isDark
                                ? Colors.white54
                                : AppTheme.secondarySlate,
                          ),
                        ),
                        Text(
                          _selectedCategory.name.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: AppTheme.primaryObsidian,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final isSelected = cat.id == _selectedCategory.id;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = cat;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (isExpense
                                      ? (isDark
                                          ? Colors.white
                                          : AppTheme.primaryObsidian)
                                      : AppTheme.incomeGreen)
                                  : (isDark
                                      ? const Color(0xFF242529)
                                      : AppTheme.surfaceContainer),
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusMd),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  cat.icon,
                                  size: 16,
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark
                                          ? Colors.white70
                                          : AppTheme.secondarySlate),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  cat.name,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? Colors.white
                                        : (isDark
                                            ? Colors.white70
                                            : AppTheme.secondarySlate),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Metadatos: Fecha y Método de pago
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _pickDate,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1B1C1F)
                              : AppTheme.surfaceCard,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMd),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF2C2D32)
                                : AppTheme.outlineHairline,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FECHA / REGISTRO',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: isDark
                                    ? Colors.white54
                                    : AppTheme.secondarySlate,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 15,
                                  color: AppTheme.secondarySlate,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? Colors.white
                                          : AppTheme.primaryObsidian,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(AppTheme.radiusLg),
                            ),
                          ),
                          builder: (context) {
                            return SafeArea(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: _paymentMethods.map((m) {
                                  return ListTile(
                                    leading: const Icon(Icons.credit_card),
                                    title: Text(m),
                                    trailing: _selectedPaymentMethod == m
                                        ? const Icon(Icons.check,
                                            color: AppTheme.primaryObsidian)
                                        : null,
                                    onTap: () {
                                      setState(() {
                                        _selectedPaymentMethod = m;
                                      });
                                      Navigator.pop(context);
                                    },
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        );
                      },
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1B1C1F)
                              : AppTheme.surfaceCard,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMd),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF2C2D32)
                                : AppTheme.outlineHairline,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isExpense ? 'CUENTA / PAGO' : 'DESTINO',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: isDark
                                    ? Colors.white54
                                    : AppTheme.secondarySlate,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.account_balance_wallet_outlined,
                                  size: 15,
                                  color: AppTheme.secondarySlate,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    _selectedPaymentMethod,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? Colors.white
                                          : AppTheme.primaryObsidian,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Nota / Concepto
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color:
                      isDark ? const Color(0xFF1B1C1F) : AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF2C2D32)
                        : AppTheme.outlineHairline,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.edit_note_outlined,
                      size: 20,
                      color: AppTheme.secondarySlate,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _noteController,
                        decoration: const InputDecoration(
                          hintText: 'Añadir concepto o nota...',
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: AppTheme.tertiaryCashmere,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              isDark ? Colors.white : AppTheme.primaryObsidian,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _showReceiptPreview
                            ? Icons.receipt_long
                            : Icons.receipt_long_outlined,
                        size: 20,
                        color: _showReceiptPreview
                            ? AppTheme.primaryObsidian
                            : AppTheme.secondarySlate,
                      ),
                      onPressed: () {
                        setState(() {
                          _showReceiptPreview = !_showReceiptPreview;
                        });
                      },
                      tooltip: 'Comprobante / Recibo',
                    ),
                  ],
                ),
              ),

              if (_showReceiptPreview) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        isDark ? const Color(0xFF242529) : AppTheme.surfaceLow,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryObsidian,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.description_outlined,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Factura_Digital.pdf',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Escaneado · 442 KB · Verificado',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppTheme.secondarySlate,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          setState(() {
                            _showReceiptPreview = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 14),

              // Teclado Numérico Quiet Luxury
              CustomKeypad(
                onKeyPress: _onKeyPress,
                onBackspace: _onBackspace,
              ),

              const SizedBox(height: 16),

              // Botón de Registrar
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submitTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isExpense
                        ? (isDark ? Colors.white : AppTheme.primaryObsidian)
                        : AppTheme.incomeGreen,
                    foregroundColor: isExpense && isDark
                        ? AppTheme.primaryObsidian
                        : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isExpense ? 'Registrar Gasto' : 'Registrar Ingreso',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
