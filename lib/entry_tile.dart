import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'income_entry.dart';

// Ensure this path is correct based on your project structure

class EntryTile extends StatelessWidget {
  final IncomeEntry entry;

  const EntryTile({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4, // Increased elevation for a more lifted look
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // More rounded corners
      shadowColor: Colors.grey.withOpacity(0.3), // Subtle shadow color
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Increased padding inside the card
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Enhanced Leading Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1), // Light green background
                shape: BoxShape.circle, // Circular shape for the icon background
              ),
              child: const Icon(
                Icons.attach_money_rounded,
                color: Colors.green, // Keep original green color
                size: 28, // Slightly larger icon
              ),
            ),
            const SizedBox(width: 16), // Spacing between icon and text

            // Amount and Date/Time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PKR ${entry.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20, // Larger font size for amount
                      fontWeight: FontWeight.bold, // Bolder
                      color: Colors.green, // Prominent green color
                    ),
                  ),
                  const SizedBox(height: 4), // Spacing between amount and date
                  Text(
                    DateFormat('dd MMM yyyy, hh:mm a').format(entry.timestamp),
                    style: TextStyle(
                      fontSize: 13, // Slightly adjusted font size
                      color: Colors.grey[600], // Darker grey for better readability
                    ),
                  ),
                ],
              ),
            ),

            // Trailing Icon (could be a subtle animation or different icon if desired)
            const Icon(
              Icons.check_circle_outline, // Changed to a checkmark for 'added'
              color: Colors.green,
              size: 32, // Larger checkmark icon
            ),
          ],
        ),
      ),
    );
  }
}
