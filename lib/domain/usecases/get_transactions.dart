import '../entities/transaction.dart';
import '../repositories/finance_repository.dart';

class GetTransactions {
  final FinanceRepository repository;

  GetTransactions(this.repository);

  Future<List<FinancialTransaction>> call() {
    return repository.getTransactions();
  }
}
