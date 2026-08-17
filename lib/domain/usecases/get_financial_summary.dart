import '../entities/financial_summary.dart';
import '../repositories/finance_repository.dart';

class GetFinancialSummary {
  final FinanceRepository repository;

  GetFinancialSummary(this.repository);

  Future<FinancialSummary> call() {
    return repository.getSummary();
  }
}
