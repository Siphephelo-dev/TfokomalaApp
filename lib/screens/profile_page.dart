import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileController = TextEditingController();
  String _email = '';
  bool _isEditing = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc =
      await _firestore.collection('users').doc(user.uid).get();
      final data = doc.data();
      if (data != null) {
        setState(() {
          _email = data['email'] ?? '';
          _firstNameController.text = data['firstName'] ?? '';
          _lastNameController.text = data['lastName'] ?? '';
          _mobileController.text = data['mobile'] ?? '';
          _isLoading = false;
        });
      }
    }
  }

  void _saveChanges() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'mobile': _mobileController.text.trim(),
      });
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated")),
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _saveChanges();
              } else {
                setState(() => _isEditing = true);
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/avatar.png'),
              // Later: replace with user's profile picture from Firebase Storage
            ),
            const SizedBox(height: 20),
            _buildTextField("First Name", _firstNameController),
            const SizedBox(height: 16),
            _buildTextField("Last Name", _lastNameController),
            const SizedBox(height: 16),
            _buildReadOnlyField("Email", _email),
            const SizedBox(height: 16),
            _buildTextField("Mobile Number", _mobileController,
                keyboardType: TextInputType.phone),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      enabled: _isEditing,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return TextField(
      controller: TextEditingController(text: value),
      enabled: false,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
