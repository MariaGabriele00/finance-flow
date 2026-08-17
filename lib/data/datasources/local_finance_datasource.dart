import '../../domain/entities/transaction.dart';

class LocalFinanceDatasource {
  final List<FinancialTransaction> _transactions = [
    FinancialTransaction(
      id: '1',
      title: 'Salário',
      amount: 7200,
      type: TransactionType.income,
      date: DateTime(2026, 8, 5),
      category: 'Salário',
    ),
    FinancialTransaction(
      id: '2',
      title: 'Aluguel',
      amount: 1600,
      type: TransactionType.expense,
      date: DateTime(2026, 8, 7),
      category: 'Moradia',
    ),
    FinancialTransaction(
      id: '3',
      title: 'Supermercado',
      amount: 680.40,
      type: TransactionType.expense,
      date: DateTime(2026, 8, 9),
      category: 'Alimentação',
    ),
    FinancialTransaction(
      id: '4',
      title: 'Freelance',
      amount: 1250,
      type: TransactionType.income,
      date: DateTime(2026, 8, 10),
      category: 'Freelance',
    ),
    FinancialTransaction(
      id: '5',
      title: 'Internet',
      amount: 119.90,
      type: TransactionType.expense,
      date: DateTime(2026, 8, 11),
      category: 'Contas',
    ),
    FinancialTransaction(
      id: '6',
      title: 'Academia',
      amount: 89.90,
      type: TransactionType.expense,
      date: DateTime(2026, 8, 12),
      category: 'Saúde',
    ),
    FinancialTransaction(
      id: '7',
      title: 'Projeto extra',
      amount: 900,
      type: TransactionType.income,
      date: DateTime(2026, 8, 13),
      category: 'Freelance',
    ),
    FinancialTransaction(
      id: '8',
      title: 'Combustível',
      amount: 220,
      type: TransactionType.expense,
      date: DateTime(2026, 8, 14),
      category: 'Transporte',
    ),
  ];

  Future<List<FinancialTransaction>> getTransactions() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return List.unmodifiable(_transactions);
  }

  Future<void> addTransaction(FinancialTransaction transaction) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    _transactions.add(transaction);
  }

  Future<void> deleteTransaction(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    _transactions.removeWhere((item) => item.id == id);
  }
}
