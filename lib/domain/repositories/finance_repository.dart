import '../entities/financial_summary.dart';
import '../entities/transaction.dart';

abstract class FinanceRepository {
  Future<List<FinancialTransaction>> getTransactions();
  Future<FinancialSummary> getSummary();
  Future<void> addTransaction(FinancialTransaction transaction);
  Future<void> deleteTransaction(String id);
}
