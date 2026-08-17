import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/transaction.dart';
import '../bloc/finance_bloc.dart';
import 'add_transaction_dialog.dart';
import 'stat_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinanceBloc, FinanceState>(
      builder: (context, state) {
        if (state is FinanceLoading || state is FinanceInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is FinanceError) {
          return Center(child: Text(state.message));
        }

        final loaded = state as FinanceLoaded;

        return RefreshIndicator(
          onRefresh: () async {
            context.read<FinanceBloc>().add(const FinanceRefreshed());
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1250),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Header(
                      onAdd: () => showDialog<void>(
                        context: context,
                        builder: (_) => const AddTransactionDialog(),
                      ),
                    ),
                    const SizedBox(height: 28),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final compact = constraints.maxWidth < 700;
                        final cards = [
                          StatCard(
                            title: 'Saldo disponível',
                            value: loaded.summary.balance,
                            icon: Icons.account_balance_wallet_rounded,
                            accent: AppTheme.primary,
                          ),
                          StatCard(
                            title: 'Entradas',
                            value: loaded.summary.income,
                            icon: Icons.south_west_rounded,
                            accent: AppTheme.success,
                          ),
                          StatCard(
                            title: 'Saídas',
                            value: loaded.summary.expense,
                            icon: Icons.north_east_rounded,
                            accent: AppTheme.danger,
                          ),
                        ];

                        if (compact) {
                          return Column(
                            children: cards
                                .map(
                                  (card) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: card,
                                  ),
                                )
                                .toList(),
                          );
                        }

                        return Row(
                          children: cards
                              .map(
                                (card) => Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: card,
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final compact = constraints.maxWidth < 850;

                        final chart = _MonthlyChart(
                          income: loaded.summary.monthlyIncome,
                          expense: loaded.summary.monthlyExpense,
                        );

                        final category = _CategoryChart(
                          data: loaded.summary.expensesByCategory,
                        );

                        if (compact) {
                          return Column(
                            children: [
                              chart,
                              const SizedBox(height: 18),
                              category,
                            ],
                          );
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: chart),
                            const SizedBox(width: 18),
                            Expanded(child: category),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    _RecentTransactions(
                      transactions: loaded.summary.recentTransactions,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onAdd;

  const _Header({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final date =
        DateFormat("EEEE, d 'de' MMMM", 'pt_BR').format(DateTime.now());

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Olá! 👋',
                style: TextStyle(
                  fontSize: 29,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.text,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                date[0].toUpperCase() + date.substring(1),
                style: const TextStyle(color: AppTheme.muted),
              ),
            ],
          ),
        ),
        FilledButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Nova transação'),
        ),
      ],
    );
  }
}

class _MonthlyChart extends StatelessWidget {
  final List<double> income;
  final List<double> expense;

  const _MonthlyChart({
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    final months = List.generate(6, (index) {
      final date = DateTime(
        DateTime.now().year,
        DateTime.now().month - 5 + index,
      );

      return DateFormat('MMM', 'pt_BR').format(date).replaceAll('.', '');
    });

    return _Panel(
      title: 'Fluxo financeiro',
      subtitle: 'Entradas x saídas nos últimos 6 meses',
      child: Column(
        children: [
          const SizedBox(height: 4),
          const Row(
            children: [
              _ChartLegend(
                color: AppTheme.success,
                label: 'Entradas',
              ),
              SizedBox(width: 20),
              _ChartLegend(
                color: AppTheme.danger,
                label: 'Saídas',
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 280,
            child: BarChart(
              BarChartData(
                minY: 0,
                maxY: _maxY,
                alignment: BarChartAlignment.spaceAround,
                groupsSpace: 16,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _interval,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: Color(0xFFECEEF4),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 48,
                      interval: _interval,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          _formatValue(value),
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppTheme.muted,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();

                        if (index < 0 || index >= months.length) {
                          return const SizedBox.shrink();
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            months[index],
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.muted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppTheme.text,
                    tooltipRoundedRadius: 12,
                    tooltipPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    getTooltipItem: (
                      group,
                      groupIndex,
                      rod,
                      rodIndex,
                    ) {
                      final isIncome = rodIndex == 0;

                      return BarTooltipItem(
                        '${isIncome ? 'Entrada' : 'Saída'}\n'
                        '${NumberFormat.currency(
                          locale: 'pt_BR',
                          symbol: 'R\$',
                        ).format(rod.toY)}',
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                        ),
                      );
                    },
                  ),
                ),
                barGroups: List.generate(
                  6,
                  (index) {
                    return BarChartGroupData(
                      x: index,
                      barsSpace: 5,
                      barRods: [
                        BarChartRodData(
                          toY: income[index],
                          width: 10,
                          color: AppTheme.success,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(5),
                          ),
                        ),
                        BarChartRodData(
                          toY: expense[index],
                          width: 10,
                          color: AppTheme.danger,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(5),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
            ),
          ),
        ],
      ),
    );
  }

  double get _maxY {
    final values = [
      ...income,
      ...expense,
    ];

    final maxValue = values.fold<double>(
      0,
      (max, value) => value > max ? value : max,
    );

    if (maxValue <= 1000) {
      return 2000;
    }

    if (maxValue <= 2500) {
      return 3000;
    }

    if (maxValue <= 5000) {
      return 6000;
    }

    if (maxValue <= 8000) {
      return 10000;
    }

    return ((maxValue / 2000).ceil() * 2000).toDouble();
  }

  double get _interval {
    if (_maxY <= 2000) {
      return 500;
    }

    if (_maxY <= 6000) {
      return 1000;
    }

    return 2000;
  }

  String _formatValue(double value) {
    if (value == 0) {
      return '0';
    }

    if (value >= 1000) {
      final valueInThousands = value / 1000;

      if (valueInThousands == valueInThousands.roundToDouble()) {
        return '${valueInThousands.toInt()} mil';
      }

      return '${valueInThousands.toStringAsFixed(1)} mil';
    }

    return value.toInt().toString();
  }
}

class _ChartLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _ChartLegend({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.muted,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _CategoryChart extends StatelessWidget {
  final Map<String, double> data;

  const _CategoryChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return _Panel(
      title: 'Gastos por categoria',
      subtitle: 'Onde seu dinheiro está indo',
      child: Column(
        children: [
          SizedBox(
            height: 190,
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 52,
                sectionsSpace: 3,
                sections: List.generate(entries.length, (index) {
                  final item = entries[index];
                  final total = data.values.fold<double>(0, (a, b) => a + b);
                  return PieChartSectionData(
                    value: item.value,
                    title: '${(item.value / total * 100).round()}%',
                    radius: 62,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  );
                }),
              ),
              duration: const Duration(milliseconds: 900),
            ),
          ),
          const SizedBox(height: 8),
          ...entries.take(5).map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _chartColor(entries.indexOf(entry)),
                        ),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          entry.key,
                          style: const TextStyle(
                            color: AppTheme.text,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        NumberFormat.currency(
                          locale: 'pt_BR',
                          symbol: 'R\$',
                        ).format(entry.value),
                        style: const TextStyle(
                          color: AppTheme.muted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Color _chartColor(int index) {
    const colors = [
      AppTheme.primary,
      AppTheme.success,
      AppTheme.danger,
      Color(0xFFFFB84D),
      Color(0xFF4E9AF1),
    ];
    return colors[index % colors.length];
  }
}

class _RecentTransactions extends StatelessWidget {
  final List<FinancialTransaction> transactions;

  const _RecentTransactions({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: 'Transações recentes',
      subtitle: 'Últimos movimentos registrados',
      child: Column(
        children: transactions.map((transaction) {
          final income = transaction.type == TransactionType.income;
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 2),
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: (income ? AppTheme.success : AppTheme.danger)
                    .withValues(alpha: .10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                income ? Icons.south_west_rounded : Icons.north_east_rounded,
                color: income ? AppTheme.success : AppTheme.danger,
              ),
            ),
            title: Text(
              transaction.title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppTheme.text,
              ),
            ),
            subtitle: Text(
              '${transaction.category} • ${DateFormat('dd/MM/yyyy').format(transaction.date)}',
              style: const TextStyle(color: AppTheme.muted),
            ),
            trailing: Text(
              '${income ? '+' : '-'} ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(transaction.amount)}',
              style: TextStyle(
                color: income ? AppTheme.success : AppTheme.danger,
                fontWeight: FontWeight.w800,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _Panel({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppTheme.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppTheme.muted,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}
