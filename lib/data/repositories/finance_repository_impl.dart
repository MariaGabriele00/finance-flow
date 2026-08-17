import '../../domain/entities/financial_summary.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/finance_repository.dart';
import '../datasources/local_finance_datasource.dart';

class FinanceRepositoryImpl implements FinanceRepository {
  final LocalFinanceDatasource datasource;

  FinanceRepositoryImpl(this.datasource);

  @override
  Future<List<FinancialTransaction>> getTransactions() {
    return datasource.getTransactions();
  }

  @override
  Future<void> addTransaction(FinancialTransaction transaction) {
    return datasource.addTransaction(transaction);
  }

  @override
  Future<void> deleteTransaction(String id) {
    return datasource.deleteTransaction(id);
  }

  @override
  Future<FinancialSummary> getSummary() async {
    final transactions = await datasource.getTransactions();
    final income = transactions
        .where((item) => item.type == TransactionType.income)
        .fold<double>(0, (sum, item) => sum + item.amount);
    final expense = transactions
        .where((item) => item.type == TransactionType.expense)
        .fold<double>(0, (sum, item) => sum + item.amount);

    final monthlyIncome = List<double>.filled(6, 0);
    final monthlyExpense = List<double>.filled(6, 0);

    for (final transaction in transactions) {
      final month = transaction.date.month;
      final index = month - DateTime.now().month + 5;

      if (index >= 0 && index < 6) {
        if (transaction.type == TransactionType.income) {
          monthlyIncome[index] += transaction.amount;
        }

        if (transaction.type == TransactionType.expense) {
          monthlyExpense[index] += transaction.amount;
        }
      }
    }

    final expensesByCategory = <String, double>{};
    for (final transaction in transactions.where(
      (item) => item.type == TransactionType.expense,
    )) {
      expensesByCategory.update(
        transaction.category,
        (value) => value + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }

    final sorted = [...transactions]..sort((a, b) => b.date.compareTo(a.date));

    return FinancialSummary(
      balance: income - expense,
      income: income,
      expense: expense,
      monthlyIncome: monthlyIncome,
      monthlyExpense: monthlyExpense,
      expensesByCategory: expensesByCategory,
      recentTransactions: sorted.take(6).toList(),
    );
  }
}
