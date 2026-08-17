import 'transaction.dart';

class FinancialSummary {
  final double balance;
  final double income;
  final double expense;
  final List<double> monthlyIncome;
  final List<double> monthlyExpense;
  final Map<String, double> expensesByCategory;
  final List<FinancialTransaction> recentTransactions;

  const FinancialSummary({
    required this.balance,
    required this.income,
    required this.expense,
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.expensesByCategory,
    required this.recentTransactions,
  });
}
