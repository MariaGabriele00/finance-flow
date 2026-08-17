import 'package:flutter/material.dart';

import '../widgets/add_transaction_dialog.dart';
import '../widgets/dashboard_page.dart';
import '../widgets/transactions_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 900;

        return Scaffold(
          body: SafeArea(
            child: Row(
              children: [
                if (desktop)
                  _Sidebar(
                    selectedIndex: index,
                    onSelected: (value) => setState(() => index = value),
                  ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: index == 0
                        ? const DashboardPage(key: ValueKey('dashboard'))
                        : const TransactionsPage(key: ValueKey('transactions')),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: desktop
              ? null
              : NavigationBar(
                  selectedIndex: index,
                  onDestinationSelected: (value) {
                    setState(() => index = value);
                  },
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.grid_view_rounded),
                      label: 'Resumo',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.receipt_long_rounded),
                      label: 'Transações',
                    ),
                  ],
                ),
          floatingActionButton: !desktop && index == 0
              ? FloatingActionButton.extended(
                  onPressed: () => _showAdd(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Nova transação'),
                )
              : null,
        );
      },
    );
  }

  void _showAdd(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => const AddTransactionDialog(),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _Sidebar({
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      margin: const EdgeInsets.all(18),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF635BFF),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.auto_graph_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Finance Flow',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 45),
          _NavItem(
            icon: Icons.grid_view_rounded,
            label: 'Visão geral',
            selected: selectedIndex == 0,
            onTap: () => onSelected(0),
          ),
          _NavItem(
            icon: Icons.receipt_long_rounded,
            label: 'Transações',
            selected: selectedIndex == 1,
            onTap: () => onSelected(1),
          ),
          const Spacer(),
          const Text(
            'Controle seu dinheiro.\nSimplifique sua vida.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF8B90A3),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? const Color(0xFFEDEAFC) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 21,
                  color: selected
                      ? const Color(0xFF635BFF)
                      : const Color(0xFF8B90A3),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected
                        ? const Color(0xFF635BFF)
                        : const Color(0xFF555A6E),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
