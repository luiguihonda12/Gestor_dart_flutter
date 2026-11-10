import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'providers/expense_provider.dart';
import 'screens/main_screen.dart';
import 'utils/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const AuraExpenseApp());
}

class AuraExpenseApp extends StatefulWidget {
  const AuraExpenseApp({super.key});

  @override
  State<AuraExpenseApp> createState() => _AuraExpenseAppState();
}

class _AuraExpenseAppState extends State<AuraExpenseApp> {
  late final ExpenseProvider _expenseProvider;

  @override
  void initState() {
    super.initState();
    _expenseProvider = ExpenseProvider();
  }

  @override
  void dispose() {
    _expenseProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _expenseProvider,
      builder: (context, _) {
        return MaterialApp(
          title: 'Aura - Gestor de Gastos',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode:
              _expenseProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: MainScreen(provider: _expenseProvider),
        );
      },
    );
  }
}
