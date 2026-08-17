import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/transaction.dart';
import '../bloc/finance_bloc.dart';
import 'add_transaction_dialog.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinanceBloc, FinanceState>(
      builder: (context, state) {
        if (state is! FinanceLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final transactions = [...state.transactions]
          ..sort((a, b) => b.date.compareTo(a.date));

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Transações',
                              style: TextStyle(
                                fontSize: 29,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.text,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Acompanhe todos os seus movimentos financeiros.',
                              style: TextStyle(color: AppTheme.muted),
                            ),
                          ],
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: () => showDialog<void>(
                          context: context,
                          builder: (_) => const AddTransactionDialog(),
                        ),
                        icon: const Icon(Icons.add),
                        label: const Text('Nova'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      children: transactions
                          .map(
                            (transaction) => _TransactionTile(
                              transaction: transaction,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final FinancialTransaction transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final income = transaction.type == TransactionType.income;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 7, 10, 7),
      child: ListTile(
        leading: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: (income ? AppTheme.success : AppTheme.danger)
                .withValues(alpha: .10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            income
                ? Icons.south_west_rounded
                : Icons.north_east_rounded,
            color: income ? AppTheme.success : AppTheme.danger,
          ),
        ),
        title: Text(
          transaction.title,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: AppTheme.text,
          ),
        ),
        subtitle: Text(
          '${transaction.category} • ${DateFormat('dd/MM/yyyy').format(transaction.date)}',
          style: const TextStyle(color: AppTheme.muted),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${income ? '+' : '-'} ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(transaction.amount)}',
              style: TextStyle(
                color: income ? AppTheme.success : AppTheme.danger,
                fontWeight: FontWeight.w900,
              ),
            ),
            IconButton(
              tooltip: 'Excluir',
              onPressed: () {
                context
                    .read<FinanceBloc>()
                    .add(TransactionDeleted(transaction.id));
              },
              icon: const Icon(Icons.delete_outline_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
