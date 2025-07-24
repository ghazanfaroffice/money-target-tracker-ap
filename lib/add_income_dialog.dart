import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddIncomeDialog extends StatefulWidget {
  final Function(double) onAdd;

  const AddIncomeDialog({super.key, required this.onAdd});

  @override
  State<AddIncomeDialog> createState() => _AddIncomeDialogState();
}

class _AddIncomeDialogState extends State<AddIncomeDialog> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Income Entry (PKR)'),
      content: TextField(
        controller: _amountController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ],
        decoration: const InputDecoration(
          hintText: 'e.g., 500.50',
          prefixText: 'PKR ',
          border: OutlineInputBorder(),
          labelText: 'Amount',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final double? amount = double.tryParse(_amountController.text);
            if (amount != null && amount > 0) {
              widget.onAdd(amount);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a valid positive amount.')),
              );
            }
          },
          child: const Text('Add Income'),
        ),
      ],
    );
  }
}
