import 'package:flutter/material.dart';

enum TransactionType { income, expense }

class TransactionCategory {
  final String id;
  final String name;
  final IconData icon;
  final bool isIncome;

  const TransactionCategory({
    required this.id,
    required this.name,
    required this.icon,
    this.isIncome = false,
  });

  // Categorías de Gastos predeterminadas según el diseño
  static const List<TransactionCategory> defaultExpenseCategories = [
    TransactionCategory(
      id: 'dining',
      name: 'Dining',
      icon: Icons.restaurant,
      isIncome: false,
    ),
    TransactionCategory(
      id: 'groceries',
      name: 'Groceries',
      icon: Icons.local_grocery_store,
      isIncome: false,
    ),
    TransactionCategory(
      id: 'transit',
      name: 'Transit',
      icon: Icons.directions_subway,
      isIncome: false,
    ),
    TransactionCategory(
      id: 'living',
      name: 'Living',
      icon: Icons.cottage,
      isIncome: false,
    ),
    TransactionCategory(
      id: 'shopping',
      name: 'Shopping',
      icon: Icons.shopping_bag,
      isIncome: false,
    ),
    TransactionCategory(
      id: 'health',
      name: 'Health',
      icon: Icons.spa,
      isIncome: false,
    ),
    TransactionCategory(
      id: 'utilities',
      name: 'Utilities',
      icon: Icons.bolt,
      isIncome: false,
    ),
  ];

  // Categorías de Ingresos predeterminadas según el diseño
  static const List<TransactionCategory> defaultIncomeCategories = [
    TransactionCategory(
      id: 'salary',
      name: 'Salary',
      icon: Icons.work,
      isIncome: true,
    ),
    TransactionCategory(
      id: 'client',
      name: 'Client Project',
      icon: Icons.business_center,
      isIncome: true,
    ),
    TransactionCategory(
      id: 'yield',
      name: 'Investment Yield',
      icon: Icons.trending_up,
      isIncome: true,
    ),
    TransactionCategory(
      id: 'dividend',
      name: 'Dividend',
      icon: Icons.pie_chart_outline,
      isIncome: true,
    ),
    TransactionCategory(
      id: 'consulting',
      name: 'Consulting',
      icon: Icons.lightbulb_outline,
      isIncome: true,
    ),
    TransactionCategory(
      id: 'gift',
      name: 'Gift',
      icon: Icons.card_giftcard,
      isIncome: true,
    ),
  ];
}

class TransactionItem {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final String categoryId;
  final String categoryName;
  final IconData categoryIcon;
  final DateTime date;
  final String paymentMethod;
  final String notes;
  final List<String> tags;

  TransactionItem({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.date,
    this.paymentMethod = 'Checking •••• 8821',
    this.notes = '',
    this.tags = const [],
  });

  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;

  TransactionItem copyWith({
    String? id,
    String? title,
    double? amount,
    TransactionType? type,
    String? categoryId,
    String? categoryName,
    IconData? categoryIcon,
    DateTime? date,
    String? paymentMethod,
    String? notes,
    List<String>? tags,
  }) {
    return TransactionItem(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      categoryIcon: categoryIcon ?? this.categoryIcon,
      date: date ?? this.date,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
    );
  }
}
