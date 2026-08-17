import 'package:equatable/equatable.dart';

enum TransactionType { income, expense }

class FinancialTransaction extends Equatable {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final DateTime date;
  final String category;

  const FinancialTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
    required this.category,
  });

  FinancialTransaction copyWith({
    String? id,
    String? title,
    double? amount,
    TransactionType? type,
    DateTime? date,
    String? category,
  }) {
    return FinancialTransaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      date: date ?? this.date,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [id, title, amount, type, date, category];
}
