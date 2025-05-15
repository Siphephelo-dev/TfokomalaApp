import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String firstName = '';
  String lastName = '';
  String mobile = '';
  String email = '';
  String password = '';
  String confirmPassword = '';

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool isLoading = false;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Save user data to Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'firstName': firstName,
          'lastName': lastName,
          'mobile': mobile,
          'email': email,
        });

        Navigator.pushReplacementNamed(context, '/login');
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Registration failed')),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  bool _isStrongPassword(String value) {
    return RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$').hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Create Account", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("Fill in your details", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(label: "First Name", onChanged: (val) => firstName = val),
                    const SizedBox(height: 16),
                    _buildTextField(label: "Last Name", onChanged: (val) => lastName = val),
                    const SizedBox(height: 16),
                    _buildTextField(label: "Mobile Number", keyboardType: TextInputType.phone, onChanged: (val) => mobile = val),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: "Email",
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (val) => email = val,
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 16),
                    _buildPasswordField(
                      label: "Password",
                      isObscured: _obscurePassword,
                      toggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
                      onChanged: (val) => password = val,
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Enter a password';
                        if (!_isStrongPassword(val)) {
                          return 'Password must be 8+ chars with uppercase, lowercase & number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildPasswordField(
                      label: "Confirm Password",
                      isObscured: _obscureConfirm,
                      toggleObscure: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      onChanged: (val) => confirmPassword = val,
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Re-enter your password';
                        if (val != password) return 'Passwords do not match';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Register", style: TextStyle(fontSize: 18)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                      child: const Text("Already have an account? Login"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    TextInputType? keyboardType,
    required Function(String) onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator ?? (val) => val == null || val.isEmpty ? 'Please enter $label' : null,
    );
  }

  Widget _buildPasswordField({
    required String label,
    required bool isObscured,
    required Function toggleObscure,
    required Function(String) onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      obscureText: isObscured,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility),
          onPressed: () => toggleObscure(),
        ),
      ),
      onChanged: onChanged,
      validator: validator,
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty || !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }
}
