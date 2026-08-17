import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/transaction.dart';
import '../bloc/finance_bloc.dart';

class AddTransactionDialog extends StatefulWidget {
  const AddTransactionDialog({super.key});

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  TransactionType type = TransactionType.expense;
  String category = 'Alimentação';
  DateTime date = DateTime.now();

  final categories = const [
    'Alimentação',
    'Moradia',
    'Transporte',
    'Contas',
    'Saúde',
    'Lazer',
    'Salário',
    'Freelance',
    'Outros',
  ];

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Nova transação',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.text,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Registre uma entrada ou saída.',
                  style: TextStyle(color: AppTheme.muted),
                ),
                const SizedBox(height: 24),
                SegmentedButton<TransactionType>(
                  segments: const [
                    ButtonSegment(
                      value: TransactionType.expense,
                      icon: Icon(Icons.north_east_rounded),
                      label: Text('Saída'),
                    ),
                    ButtonSegment(
                      value: TransactionType.income,
                      icon: Icon(Icons.south_west_rounded),
                      label: Text('Entrada'),
                    ),
                  ],
                  selected: {type},
                  onSelectionChanged: (value) {
                    setState(() => type = value.first);
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    prefixIcon: Icon(Icons.edit_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Valor',
                    prefixIcon: Icon(Icons.attach_money_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: categories
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => category = value);
                  },
                ),
                const SizedBox(height: 12),
                InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () async {
                    final selected = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (selected != null) {
                      setState(() => date = selected);
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Data',
                      prefixIcon: Icon(Icons.calendar_month_rounded),
                    ),
                    child: Text(
                      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _save,
                        child: const Text('Salvar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _save() {
    final title = titleController.text.trim();
    final normalized =
        amountController.text.trim().replaceAll('.', '').replaceAll(',', '.');
    final amount = double.tryParse(normalized);

    if (title.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha a descrição e informe um valor válido.'),
        ),
      );
      return;
    }

    final transaction = FinancialTransaction(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      amount: amount,
      type: type,
      date: date,
      category: category,
    );

    context.read<FinanceBloc>().add(TransactionAdded(transaction));
    Navigator.pop(context);
  }
}
