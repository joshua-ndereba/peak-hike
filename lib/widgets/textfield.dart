import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint; 

  final IconData icon;
  

  const MyTextField({
    super.key,
    required this.controller,
    this.hint = "",
    this.icon = Icons.abc, required bool obscureText,
    
  });
  
 

  @override
  Widget build(BuildContext context) {
    return TextField(
      
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(),
        fillColor: Colors.grey.withOpacity(0.6),
        filled: false, // Ensures background color fills the entire field
        prefixIcon: Icon(icon),
      ),
    );
  }
}
