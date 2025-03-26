import 'package:flutter/material.dart';
import '../models/category_model.dart';

class CreateCategoryScreen extends StatefulWidget {
  final Function(Category) onCreate;

  const CreateCategoryScreen({super.key, required this.onCreate});

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final TextEditingController _nameController = TextEditingController();
  IconData? _selectedIcon;
  Color? _selectedColor;

  final List<IconData> _iconOptions = [
    Icons.work,
    Icons.home,
    Icons.school,
    Icons.favorite,
    Icons.fitness_center,
    Icons.shopping_cart,
    Icons.book,
    Icons.music_note,
    Icons.movie,
    Icons.pets,
  ];

  final List<Color> _colorOptions = [
    Colors.red,
    Colors.pink,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.teal,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.brown,
  ];

  void _createCategory() {
    final name = _nameController.text.trim();
    if (name.isEmpty || _selectedIcon == null || _selectedColor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    final newCategory = Category(
      name: name,
      icon: _selectedIcon!,
      color: _selectedColor!,
    );

    widget.onCreate(newCategory);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Create new category', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Category name', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('Enter name'),
            ),
            const SizedBox(height: 24),

            const Text('Category icon', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: _iconOptions.map((icon) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = icon),
                  child: CircleAvatar(
                    backgroundColor: _selectedIcon == icon
                        ? const Color(0xFF8687E7)
                        : Colors.white12,
                    child: Icon(icon, color: Colors.white),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            const Text('Category color', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children: _colorOptions.map((color) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: CircleAvatar(
                    backgroundColor: color,
                    radius: 14,
                    child: _selectedColor == color
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8687E7),
                    ),
                    onPressed: _createCategory,
                    child: const Text('Create Category'),
                  ),
                ),
              ],
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
      filled: true,
      fillColor: Colors.transparent,
    );
  }
}
