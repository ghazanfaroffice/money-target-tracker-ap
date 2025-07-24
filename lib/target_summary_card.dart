import 'package:flutter/material.dart';

class TargetSummaryCard extends StatelessWidget {
  final double totalTarget;
  final double collectedAmount;
  final double remainingAmount;

  const TargetSummaryCard({
    super.key,
    required this.totalTarget,
    required this.collectedAmount,
    required this.remainingAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly Target Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            const SizedBox(height: 15),
            _buildSummaryRow('Total Target:', totalTarget, Colors.blue),
            _buildSummaryRow('Collected Amount:', collectedAmount, Colors.green),
            _buildSummaryRow('Remaining Amount:', remainingAmount,
                remainingAmount >= 0 ? Colors.orange[700]! : Colors.red),
            const SizedBox(height: 15),
            LinearProgressIndicator(
              value: totalTarget > 0 ? collectedAmount / totalTarget : 0,
              backgroundColor: Colors.grey[300],
              color: Colors.lightGreen,
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${(totalTarget > 0 ? (collectedAmount / totalTarget * 100) : 0).toStringAsFixed(1)}% collected',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
          Text(
            'PKR ${amount.toStringAsFixed(2)}',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
