import 'package:flutter/material.dart';
import '../models/transaction.dart';

class ExpenseProvider extends ChangeNotifier {
  String _currencySymbol = '\$';
  String _currencyCode = 'USD';
  bool _isDarkMode = false;
  bool _dailyReminder = true;
  DateTime _selectedDate = DateTime.now();

  String get currencySymbol => _currencySymbol;
  String get currencyCode => _currencyCode;
  bool get isDarkMode => _isDarkMode;
  bool get dailyReminder => _dailyReminder;
  DateTime get selectedDate => _selectedDate;

  final List<TransactionItem> _transactions = [];

  List<TransactionItem> get allTransactions => List.unmodifiable(_transactions);

  ExpenseProvider() {
    _loadSampleTransactions();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = DateTime(date.year, date.month, date.day);
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setCurrency(String code, String symbol) {
    _currencyCode = code;
    _currencySymbol = symbol;
    notifyListeners();
  }

  void toggleReminder(bool value) {
    _dailyReminder = value;
    notifyListeners();
  }

  // Carga inicial con datos elegantes basados en el diseño de Quiet Luxury
  void _loadSampleTransactions() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final twoDaysAgo = today.subtract(const Duration(days: 2));
    final threeDaysAgo = today.subtract(const Duration(days: 3));

    _transactions.addAll([
      // Hoy
      TransactionItem(
        id: '1',
        title: 'Freelance Retainer',
        amount: 2800.00,
        type: TransactionType.income,
        categoryId: 'client',
        categoryName: 'Client Project',
        categoryIcon: Icons.account_balance,
        date: today.add(const Duration(hours: 9, minutes: 14)),
        paymentMethod: 'Chase Private Client',
        notes: 'Design advisory retainer Q4',
        tags: ['#work', '#retainer'],
      ),
      TransactionItem(
        id: '2',
        title: 'Aesop Skincare',
        amount: 85.00,
        type: TransactionType.expense,
        categoryId: 'health',
        categoryName: 'Wellness & Body',
        categoryIcon: Icons.spa,
        date: today.add(const Duration(hours: 14, minutes: 30)),
        paymentMethod: 'Amex •••• 4012',
        notes: 'Personal care botanical replenishment',
        tags: ['#wellness'],
      ),
      TransactionItem(
        id: '3',
        title: 'Blue Bottle Coffee',
        amount: 6.50,
        type: TransactionType.expense,
        categoryId: 'dining',
        categoryName: 'Dining & Rituals',
        categoryIcon: Icons.local_cafe,
        date: today.add(const Duration(hours: 10, minutes: 22)),
        paymentMethod: 'Apple Pay',
        notes: 'Single origin pour-over',
        tags: ['#ritual'],
      ),

      // Ayer
      TransactionItem(
        id: '4',
        title: 'Equinox Club',
        amount: 240.00,
        type: TransactionType.expense,
        categoryId: 'health',
        categoryName: 'Wellness & Body',
        categoryIcon: Icons.fitness_center,
        date: yesterday.add(const Duration(hours: 7, minutes: 15)),
        paymentMethod: 'Auto Debit',
        notes: 'Monthly membership dues',
        tags: ['#membership'],
      ),
      TransactionItem(
        id: '5',
        title: 'The Guild Wine & Grill',
        amount: 142.50,
        type: TransactionType.expense,
        categoryId: 'dining',
        categoryName: 'Dining & Rituals',
        categoryIcon: Icons.restaurant,
        date: yesterday.add(const Duration(hours: 20, minutes: 45)),
        paymentMethod: 'Amex •••• 4012',
        notes: 'Dinner with client partners',
        tags: ['#work', '#reimbursable'],
      ),

      // Hace 2 días
      TransactionItem(
        id: '6',
        title: 'Whole Foods Market',
        amount: 118.20,
        type: TransactionType.expense,
        categoryId: 'groceries',
        categoryName: 'Groceries',
        categoryIcon: Icons.local_grocery_store,
        date: twoDaysAgo.add(const Duration(hours: 17, minutes: 10)),
        paymentMethod: 'Chase •••• 8821',
        notes: 'Organic groceries and pantry',
        tags: ['#living'],
      ),
      TransactionItem(
        id: '7',
        title: 'Investment Yield',
        amount: 1700.00,
        type: TransactionType.income,
        categoryId: 'yield',
        categoryName: 'Investment Yield',
        categoryIcon: Icons.trending_up,
        date: twoDaysAgo.add(const Duration(hours: 8, minutes: 0)),
        paymentMethod: 'Treasury Reserve',
        notes: 'High-yield treasury dividend settlement',
        tags: ['#yield'],
      ),

      // Hace 3 días
      TransactionItem(
        id: '8',
        title: 'Studio Hardware Upgrade',
        amount: 740.00,
        type: TransactionType.expense,
        categoryId: 'utilities',
        categoryName: 'Studio & Hardware',
        categoryIcon: Icons.computer,
        date: threeDaysAgo.add(const Duration(hours: 15, minutes: 20)),
        paymentMethod: 'Amex •••• 4012',
        notes: 'Ergonomic display mount and studio lighting',
        tags: ['#studio'],
      ),
      TransactionItem(
        id: '9',
        title: 'Urban Sanctuary Rent',
        amount: 1650.00,
        type: TransactionType.expense,
        categoryId: 'living',
        categoryName: 'Housing & Maintenance',
        categoryIcon: Icons.cottage,
        date: threeDaysAgo.add(const Duration(hours: 9, minutes: 0)),
        paymentMethod: 'Chase Private Client',
        notes: 'Studio loft rent',
        tags: ['#housing'],
      ),
    ]);
  }

  // Operaciones CRUD
  void addTransaction(TransactionItem item) {
    _transactions.insert(0, item);
    notifyListeners();
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void clearAllTransactions() {
    _transactions.clear();
    notifyListeners();
  }

  void restoreSampleData() {
    _transactions.clear();
    _loadSampleTransactions();
    notifyListeners();
  }

  // Filtros y agregaciones
  List<TransactionItem> getTransactionsForDay(DateTime date) {
    return _transactions.where((item) {
      return item.date.year == date.year &&
          item.date.month == date.month &&
          item.date.day == date.day;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  double getTotalIncomeForDay(DateTime date) {
    return getTransactionsForDay(date)
        .where((item) => item.isIncome)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double getTotalExpenseForDay(DateTime date) {
    return getTransactionsForDay(date)
        .where((item) => item.isExpense)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double getDailyNetForDay(DateTime date) {
    return getTotalIncomeForDay(date) - getTotalExpenseForDay(date);
  }

  // Totales globales
  double get totalIncome => _transactions
      .where((item) => item.isIncome)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get totalExpense => _transactions
      .where((item) => item.isExpense)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get netWorth => 24850.40 + (totalIncome - totalExpense);

  // Distribución de gastos por categoría
  Map<String, double> getExpenseDistribution() {
    final Map<String, double> map = {};
    for (var item in _transactions.where((t) => t.isExpense)) {
      map[item.categoryName] = (map[item.categoryName] ?? 0.0) + item.amount;
    }
    return map;
  }
}
