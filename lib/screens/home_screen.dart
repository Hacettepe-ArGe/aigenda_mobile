import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../widgets/add_task_modal.dart';
import '../widgets/task_tile.dart';
import 'task_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> _tasks = [];

  void _addTask(Task task) {
    setState(() {
      _tasks.add(task);
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
      builder: (_) {
        return AddTaskModal(onSave: _addTask);
      },
    );
  }

  void _openTaskDetail(int index) async {
    final updatedTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute(
        builder: (_) => TaskDetailScreen(
          task: _tasks[index],
          onDelete: () {
            setState(() {
              _tasks.removeAt(index);
            });
          },
          onUpdate: (updated) {
            setState(() {
              _tasks[index] = updated;
            });
          },
        ),
      ),
    );

    if (updatedTask != null) {
      setState(() {
        _tasks[index] = updatedTask;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Index', style: TextStyle(color: Colors.white)),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
            ),
          ),
        ],
      ),
      body: _tasks.isEmpty
          ? const Center(
        child: Text(
          "What do you want to do today?\nTap + to add your tasks",
          style: TextStyle(color: Colors.white70, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _tasks.length,
        itemBuilder: (_, index) {
          return GestureDetector(
            onTap: () => _openTaskDetail(index),
            child: TaskTile(task: _tasks[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8687E7),
        onPressed: _showAddTaskModal,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: const Color(0xFF8687E7),
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Index'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 0,
        onTap: (int index) {
          // Add navigation logic here in future
        },
      ),
    );
  }
}
