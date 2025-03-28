import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../widgets/task_tile.dart';
import '../widgets/add_task_modal.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final List<Task> _allTasks = [];
  DateTime _selectedDate = DateTime.now();
  bool _showCompleted = false;

  void _addTask(Task task) {
    setState(() {
      _allTasks.add(task);
    });
  }

  void _showAddTaskModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AddTaskModal(onSave: _addTask),
    );
  }

  List<Task> get _filteredTasks {
    return _allTasks.where((task) {
      return task.date.year == _selectedDate.year &&
          task.date.month == _selectedDate.month &&
          task.date.day == _selectedDate.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Calendar', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Column(
        children: [
          /// 📆 Date Picker
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: Colors.grey[900],
            child: SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 30,
                itemBuilder: (_, index) {
                  final date = DateTime.now().add(Duration(days: index));
                  final isSelected = _selectedDate.day == date.day &&
                      _selectedDate.month == date.month &&
                      _selectedDate.year == date.year;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedDate = date),
                    child: Container(
                      width: 64,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF8687E7) : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? const Color(0xFF8687E7) : Colors.white24,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(DateFormat.E().format(date),
                              style: const TextStyle(color: Colors.white70)),
                          const SizedBox(height: 4),
                          Text("${date.day}",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : Colors.white)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          /// 🔘 Tabs: Today / Completed (you can make it toggle switch too)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Row(
              children: [
                TextButton(
                  onPressed: () => setState(() => _showCompleted = false),
                  child: Text("Today",
                      style: TextStyle(
                        color: !_showCompleted ? Colors.white : Colors.white38,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                TextButton(
                  onPressed: () => setState(() => _showCompleted = true),
                  child: Text("Completed",
                      style: TextStyle(
                        color: _showCompleted ? Colors.white : Colors.white38,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ],
            ),
          ),

          /// 🧾 Task List
          Expanded(
            child: _filteredTasks.isEmpty
                ? const Center(
              child: Text("No tasks for this day",
                  style: TextStyle(color: Colors.white70)),
            )
                : ListView.builder(
              itemCount: _filteredTasks.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (_, index) {
                final task = _filteredTasks[index];
                return TaskTile(task: task);
              },
            ),
          ),
        ],
      ),

      /// ➕ Add Task
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8687E7),
        onPressed: _showAddTaskModal,
        child: const Icon(Icons.add),
      ),

      /// 🔽 Bottom Navigation (index = 1 for calendar)

    );
  }
}
