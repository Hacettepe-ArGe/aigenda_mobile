import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../models/category_model.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final VoidCallback onDelete;
  final Function(Task) onUpdate;

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late int _priority;
  Category? _selectedCategory;

  final List<Category> _categoryOptions = [
    Category(name: "Work", icon: Icons.work, color: Colors.orange),
    Category(name: "Study", icon: Icons.book, color: Colors.purple),
    Category(name: "Health", icon: Icons.favorite, color: Colors.red),
    Category(name: "Home", icon: Icons.home, color: Colors.green),
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descController = TextEditingController(text: widget.task.description);
    _selectedDate = widget.task.date;
    _selectedTime = widget.task.time;
    _priority = widget.task.priority;
    _selectedCategory = widget.task.category;
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(data: ThemeData.dark(), child: child!),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) => Theme(data: ThemeData.dark(), child: child!),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _editPriority() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text("Edit Priority", style: TextStyle(color: Colors.white)),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (i) {
              final p = i + 1;
              return GestureDetector(
                onTap: () => setState(() {
                  _priority = p;
                  Navigator.pop(context);
                }),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _priority == p ? const Color(0xFF8687E7) : Colors.transparent,
                    border: Border.all(color: Colors.white30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('P$p', style: const TextStyle(color: Colors.white)),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  void _editCategory() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose a Category',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _categoryOptions.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedCategory = cat);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 72,
                      height: 72,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: cat.color),
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected ? cat.color.withOpacity(0.3) : Colors.transparent,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(cat.icon, color: cat.color, size: 24),
                          const SizedBox(height: 4),
                          Flexible(
                            child: Text(
                              cat.name,
                              style: const TextStyle(color: Colors.white, fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }


  void _saveEdits() {
    final updatedTask = Task(
      title: _titleController.text,
      description: _descController.text,
      date: _selectedDate,
      time: _selectedTime,
      priority: _priority,
      category: _selectedCategory, // ✅ Save category
    );
    widget.onUpdate(updatedTask);
    Navigator.pop(context);
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text("Delete Task", style: TextStyle(color: Colors.white)),
          content: const Text(
            "Are you sure you want to delete this task?",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                widget.onDelete();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("Delete"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Task Detail", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
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
            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.white70),
              title: Text(
                "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                style: const TextStyle(color: Colors.white),
              ),
              trailing: TextButton(
                onPressed: _pickDate,
                child: const Text("Edit", style: TextStyle(color: Color(0xFF8687E7))),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.access_time, color: Colors.white70),
              title: Text(
                _selectedTime.format(context),
                style: const TextStyle(color: Colors.white),
              ),
              trailing: TextButton(
                onPressed: _pickTime,
                child: const Text("Edit", style: TextStyle(color: Color(0xFF8687E7))),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.flag, color: Colors.white70),
              title: Text(
                'Priority P$_priority',
                style: const TextStyle(color: Colors.white),
              ),
              trailing: TextButton(
                onPressed: _editPriority,
                child: const Text("Edit", style: TextStyle(color: Color(0xFF8687E7))),
              ),
            ),

            /// Category list tile
            ListTile(
              leading: const Icon(Icons.category, color: Colors.white70),
              title: _selectedCategory == null
                  ? const Text('No Category', style: TextStyle(color: Colors.white54))
                  : Row(
                children: [
                  Icon(_selectedCategory!.icon, color: _selectedCategory!.color),
                  const SizedBox(width: 8),
                  Text(
                    _selectedCategory!.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              trailing: TextButton(
                onPressed: _editCategory,
                child: const Text("Edit", style: TextStyle(color: Color(0xFF8687E7))),
              ),
            ),

            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8687E7),
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: _saveEdits,
              child: const Text('Save Task'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _confirmDelete,
              child: const Text("Delete Task", style: TextStyle(color: Colors.red)),
            )
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
    );
  }
}
