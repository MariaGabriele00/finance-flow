import '../entities/transaction.dart';
import '../repositories/finance_repository.dart';

class AddTransaction {
  final FinanceRepository repository;

  AddTransaction(this.repository);

  Future<void> call(FinancialTransaction transaction) {
    return repository.addTransaction(transaction);
  }
}
