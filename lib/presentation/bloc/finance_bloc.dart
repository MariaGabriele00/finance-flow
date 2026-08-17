import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/financial_summary.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/delete_transaction.dart';
import '../../domain/usecases/get_financial_summary.dart';
import '../../domain/usecases/get_transactions.dart';

sealed class FinanceEvent extends Equatable {
  const FinanceEvent();

  @override
  List<Object?> get props => [];
}

class FinanceStarted extends FinanceEvent {
  const FinanceStarted();
}

class TransactionAdded extends FinanceEvent {
  final FinancialTransaction transaction;

  const TransactionAdded(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class TransactionDeleted extends FinanceEvent {
  final String id;

  const TransactionDeleted(this.id);

  @override
  List<Object?> get props => [id];
}

class FinanceRefreshed extends FinanceEvent {
  const FinanceRefreshed();
}

sealed class FinanceState extends Equatable {
  const FinanceState();

  @override
  List<Object?> get props => [];
}

class FinanceInitial extends FinanceState {
  const FinanceInitial();
}

class FinanceLoading extends FinanceState {
  const FinanceLoading();
}

class FinanceLoaded extends FinanceState {
  final FinancialSummary summary;
  final List<FinancialTransaction> transactions;

  const FinanceLoaded({
    required this.summary,
    required this.transactions,
  });

  @override
  List<Object?> get props => [summary, transactions];
}

class FinanceError extends FinanceState {
  final String message;

  const FinanceError(this.message);

  @override
  List<Object?> get props => [message];
}

class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  final GetTransactions getTransactions;
  final GetFinancialSummary getSummary;
  final AddTransaction addTransaction;
  final DeleteTransaction deleteTransaction;

  FinanceBloc({
    required this.getTransactions,
    required this.getSummary,
    required this.addTransaction,
    required this.deleteTransaction,
  }) : super(const FinanceInitial()) {
    on<FinanceStarted>(_load);
    on<FinanceRefreshed>(_load);
    on<TransactionAdded>(_add);
    on<TransactionDeleted>(_delete);
  }

  Future<void> _load(
    FinanceEvent event,
    Emitter<FinanceState> emit,
  ) async {
    emit(const FinanceLoading());
    try {
      final transactions = await getTransactions();
      final summary = await getSummary();
      emit(FinanceLoaded(summary: summary, transactions: transactions));
    } catch (e) {
      emit(FinanceError(e.toString()));
    }
  }

  Future<void> _add(
    TransactionAdded event,
    Emitter<FinanceState> emit,
  ) async {
    await addTransaction(event.transaction);
    add(const FinanceRefreshed());
  }

  Future<void> _delete(
    TransactionDeleted event,
    Emitter<FinanceState> emit,
  ) async {
    await deleteTransaction(event.id);
    add(const FinanceRefreshed());
  }
}
