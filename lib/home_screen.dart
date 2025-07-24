import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled3/storage_service.dart';
import 'package:untitled3/target_summary_card.dart';

import 'add_income_dialog.dart';
import 'entry_tile.dart';
import 'income_entry.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- FUNCTIONALITY FROM YOUR ORIGINAL HOME_SCREEN.DART ---
  final _storage = StorageService(); // Your StorageService instance
  double _target = 0.0;
  List<IncomeEntry> _entries = []; // List to hold income entries

  final _targetController = TextEditingController(); // Controller for setting target
  final _entryController = TextEditingController(); // Controller for adding new entries (though we'll use AddIncomeDialog)

  // Derived getters for calculations, directly from your original class
  double get _collected => _entries.fold(0.0, (sum, e) => sum + e.amount);
  double get _remaining => (_target - _collected).clamp(0.0, _target);

  @override
  void initState() {
    super.initState();
    // Load data when the screen initializes
    _loadData();
  }

  // Loads target and entries from storage
  Future<void> _loadData() async {
    final target = await _storage.getTarget();
    final entries = await _storage.getEntries();
    setState(() {
      _target = target;
      _entries = entries;
    });
    // Initialize _targetController here after _target is loaded
    _targetController.text = _target.toStringAsFixed(0);
  }

  // --- YOUR _setTarget FUNCTIONALITY, INTEGRATED WITH MY UI DIALOG ---
  Future<void> _setTarget(double newTarget) async { // Modified to accept newTarget from dialog
    if (newTarget > 0) { // Only set if target is positive
      await _storage.saveTarget(newTarget);
      await _storage.saveEntries([]); // Reset entries when target is set, as per your original logic
      setState(() {
        _target = newTarget;
        _entries = []; // Clear entries in UI
      });
    } else {
      // Provide feedback for invalid target (already handled by dialog usually)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Target must be a positive number.')),
      );
    }
    _targetController.clear(); // Clear the text field after setting
  }

  // --- YOUR _addEntry FUNCTIONALITY, INTEGRATED WITH MY UI DIALOG ---
  Future<void> _addEntry(double value) async { // Modified to accept value from dialog
    if (value > 0) {
      final newEntry = IncomeEntry(amount: value, timestamp: DateTime.now()); // Uses your IncomeEntry with 'timestamp'
      final updatedList = [newEntry, ..._entries]; // Add new entry to the top
      await _storage.saveEntries(updatedList); // Save updated list
      setState(() {
        _entries = updatedList; // Update UI
      });
    } else {
      // Provide feedback for invalid entry (already handled by dialog usually)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entry amount must be a positive number.')),
      );
    }
    _entryController.clear(); // Clear the text field after adding
  }

  // --- MY UI DIALOGS, MODIFIED TO CALL YOUR FUNCTIONS ---

  void _showSetTargetDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set Monthly Target (PKR)'),
          content: TextField(
            controller: _targetController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'e.g., 100000',
              prefixText: 'PKR ',
              border: OutlineInputBorder(),
              labelText: 'Target Amount',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final double? newTarget = double.tryParse(_targetController.text);
                if (newTarget != null && newTarget >= 0) {
                  _setTarget(newTarget); // Calls YOUR _setTarget method
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid target amount.')),
                  );
                }
              },
              child: const Text('Set Target'),
            ),
          ],
        );
      },
    );
  }

  void _showAddIncomeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AddIncomeDialog(
          onAdd: (amount) {
            _addEntry(amount); // Calls YOUR _addEntry method
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Target Tracker'),
        centerTitle: true,
        elevation: 0,
        actions: [
          // Settings button (UI from my design)
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSetTargetDialog,
            tooltip: 'Set Monthly Target',
          ),
          // Refresh button (UI from my design)
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async { // Changed to async to await clearAll
              await _storage.clearAll(); // Uses your StorageService clearAll
              setState(() {
                _target = 0.0;
                _entries = [];
              });
              _targetController.text = '0';
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All data cleared!')),
              );
            },
            tooltip: 'Clear All Data',
          ),
        ],
      ),
      body: Column( // Main Column for the UI layout
        children: [
          // Summary card (my UI design)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TargetSummaryCard(
              totalTarget: _target, // Uses your _target state
              collectedAmount: _collected, // Uses your _collected getter
              remainingAmount: _remaining, // Uses your _remaining getter
            ),
          ),
          // Add Income button (my UI design)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              onPressed: _showAddIncomeDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add Income'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                elevation: 3,
              ),
            ),
          ),
          // History header (my UI design)
          const Padding(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Income History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
          ),
          // History list (my UI structure, using your EntryTile)
          Expanded(
            child: _entries.isEmpty // Uses your _entries list
                ? const Center(
              child: Text(
                'No income entries yet.\nAdd some to see history!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
                : ListView.builder(
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final entry = _entries[index];
                return EntryTile(entry: entry); // Uses YOUR EntryTile
              },
            ),
          ),
        ],
      ),
    );
  }
}
