import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../widgets/category_tile.dart';
import 'create_category_screen.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final List<Category> _categories = [];

  void _openCreateCategory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateCategoryScreen(
          onCreate: (newCategory) {
            setState(() {
              _categories.add(newCategory);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Choose Category', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _categories.isEmpty
            ? const Center(
          child: Text(
            'No categories yet.\nTap below to create one!',
            style: TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        )
            : GridView.builder(
          itemCount: _categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemBuilder: (_, index) {
            return CategoryTile(category: _categories[index]);
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8687E7),
            minimumSize: const Size(double.infinity, 48),
          ),
          onPressed: _openCreateCategory,
          child: const Text('Add Category'),
        ),
      ),
    );
  }
}
