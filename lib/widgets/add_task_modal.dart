import 'package:flutter/material.dart';
import '../models/task_model.dart';

class AddTaskModal extends StatefulWidget {
  final Function(Task) onSave;

  const AddTaskModal({super.key, required this.onSave});

  @override
  State<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int? _selectedPriority;

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: ThemeData.dark(),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: ThemeData.dark(),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _saveTask() {
    if (_titleController.text.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null ||
        _selectedPriority == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    final newTask = Task(
      title: _titleController.text,
      description: _descController.text,
      date: _selectedDate!,
      time: _selectedTime!,
      priority: _selectedPriority!,
    );

    widget.onSave(newTask);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(16)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add Task', style: TextStyle(color: Colors.white, fontSize: 20)),
            const SizedBox(height: 16),

            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('Title'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _descController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('Description'),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _pickDate,
                    child: Text(
                      _selectedDate == null
                          ? 'Choose Date'
                          : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _pickTime,
                    child: Text(
                      _selectedTime == null
                          ? 'Choose Time'
                          : _selectedTime!.format(context),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            const Text('Task Priority', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (index) {
                final level = index + 1;
                final isSelected = _selectedPriority == level;
                return GestureDetector(
                  onTap: () => setState(() => _selectedPriority = level),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF8687E7) : Colors.transparent,
                      border: Border.all(color: Colors.white30),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('P$level', style: const TextStyle(color: Colors.white)),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8687E7),
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: _saveTask,
              child: const Text('Save Task'),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white24),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF8687E7)),
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: Colors.transparent,
    );
  }
}
