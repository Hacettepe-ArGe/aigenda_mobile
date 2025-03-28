import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "Martha Hays";
  int tasksLeft = 10;
  int tasksDone = 5;
  ImageProvider avatar = const AssetImage('assets/images/profile_placeholder.png');

  void _changeName() {
    showDialog(
      context: context,
      builder: (_) {
        final controller = TextEditingController(text: userName);
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text("Change account name", style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Enter new name",
              hintStyle: TextStyle(color: Colors.white38),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                setState(() => userName = controller.text);
                Navigator.pop(context);
              },
              child: const Text("Edit"),
            )
          ],
        );
      },
    );
  }

  void _changePassword() {
    showDialog(
      context: context,
      builder: (_) {
        final oldPass = TextEditingController();
        final newPass = TextEditingController();
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text("Change account Password", style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPass,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Enter old password",
                  hintStyle: TextStyle(color: Colors.white38),
                ),
              ),
              TextField(
                controller: newPass,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Enter new password",
                  hintStyle: TextStyle(color: Colors.white38),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Edit")),
          ],
        );
      },
    );
  }

  void _changeAvatar() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Take Picture", style: TextStyle(color: Colors.white)),
              onTap: () {
                // Handle camera
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Import from Gallery", style: TextStyle(color: Colors.white)),
              onTap: () {
                // Handle gallery
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Import from Google Drive", style: TextStyle(color: Colors.white)),
              onTap: () {
                // Handle drive
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white30, size: 16),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Profile", style: TextStyle(color: Colors.white)), backgroundColor: Colors.black),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Profile Info
            Column(
              children: [
                GestureDetector(
                  onTap: _changeAvatar,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: avatar,
                  ),
                ),
                const SizedBox(height: 12),
                Text(userName, style: const TextStyle(color: Colors.white, fontSize: 20)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _statChip("$tasksLeft Task left"),
                    const SizedBox(width: 8),
                    _statChip("$tasksDone Task done"),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(color: Colors.white30),

            /// Settings
            _buildTile("App Settings", Icons.settings, () {}),
            _buildTile("Change account name", Icons.person, _changeName),
            _buildTile("Change account password", Icons.lock, _changePassword),
            _buildTile("Change account image", Icons.image, _changeAvatar),

            const Divider(color: Colors.white30),

            /// Info
            _buildTile("About Us", Icons.info_outline, () {}),
            _buildTile("FAQ", Icons.help_outline, () {}),
            _buildTile("Help & Feedback", Icons.message, () {}),
            _buildTile("Support Us", Icons.favorite, () {}),

            const Divider(color: Colors.white30),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {}, // TODO: implement logout
              child: const Text("Log out", style: TextStyle(color: Colors.red)),
            )
          ],
        ),
      ),
    );
  }

  Widget _statChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}
