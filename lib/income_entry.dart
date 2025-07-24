// This class is directly from your provided income_entry.dart
class IncomeEntry {
  final double amount;
  final DateTime timestamp; // Using 'timestamp' as per your original class

  IncomeEntry({required this.amount, required this.timestamp});

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory IncomeEntry.fromJson(Map<String, dynamic> json) {
    return IncomeEntry(
      amount: json['amount'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
