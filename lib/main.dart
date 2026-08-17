import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/theme/app_theme.dart';
import 'data/datasources/local_finance_datasource.dart';
import 'data/repositories/finance_repository_impl.dart';
import 'domain/usecases/add_transaction.dart';
import 'domain/usecases/delete_transaction.dart';
import 'domain/usecases/get_financial_summary.dart';
import 'domain/usecases/get_transactions.dart';
import 'presentation/bloc/finance_bloc.dart';
import 'presentation/pages/app_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR');

  final datasource = LocalFinanceDatasource();
  final repository = FinanceRepositoryImpl(datasource);

  runApp(
    FinanceFlowApp(
      getTransactions: GetTransactions(repository),
      getSummary: GetFinancialSummary(repository),
      addTransaction: AddTransaction(repository),
      deleteTransaction: DeleteTransaction(repository),
    ),
  );
}

class FinanceFlowApp extends StatelessWidget {
  final GetTransactions getTransactions;
  final GetFinancialSummary getSummary;
  final AddTransaction addTransaction;
  final DeleteTransaction deleteTransaction;

  const FinanceFlowApp({
    super.key,
    required this.getTransactions,
    required this.getSummary,
    required this.addTransaction,
    required this.deleteTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => FinanceBloc(
            getTransactions: getTransactions,
            getSummary: getSummary,
            addTransaction: addTransaction,
            deleteTransaction: deleteTransaction,
          )..add(const FinanceStarted()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Finance Flow',
        theme: AppTheme.light,
        home: const AppShell(),
      ),
    );
  }
}
