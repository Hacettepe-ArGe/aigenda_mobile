import 'package:aigenda_mobile/services/firebase/model_based/task_service.dart';
import 'package:aigenda_mobile/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../models/user.dart';
import '../services/providers/user_provider.dart';
import '../widgets/add_task_modal.dart';
import '../widgets/task_tile.dart';
import 'task_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user;
  List<Task> _tasks = [];

  void _addTask(Task task) async {
    if (user != null) {
      task.userid = user!.id;
      try {
        await TaskService().createDocument(task);
      } catch (e) {
        context.showMessage("Something went wrong :/");
      }
    }
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
          onDelete: () async {
            try {
              await TaskService().deleteDocument(_tasks[index].id!);
            } catch (e) {
              context.showMessage("Something went wrong :/");
            }
          },
          onUpdate: (updated) async {
            try {
              await TaskService().updateDocument(updated.id!, updated.toMap());
            } catch (e) {
              context.showMessage("Something went wrong :/");
            }
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
              child: Icon(Icons.person),
            ),
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (!userProvider.isAuthenticated || userProvider.user == null) {
            return const Center(child: CircularProgressIndicator());
          }
          user = userProvider.user!;
          return StreamBuilder<List<Task>>(
            stream: TaskService().getDocumentsByQueryOrderBy('userid', userProvider.user!.id, true, 'date'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                _tasks = snapshot.data ?? [];
                return _tasks.isEmpty
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
                      );
              } else {
                return const Center(child: Text("Something went wrong :/"));
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8687E7),
        onPressed: _showAddTaskModal,
        child: const Icon(Icons.add),
      ),
    );
  }
}
