import 'package:flutter/material.dart';

class GenderDropdown extends StatefulWidget {
  final ValueChanged<String?> onChanged;

  const GenderDropdown({super.key, required this.onChanged});

  @override
  _GenderDropdownState createState() => _GenderDropdownState();
}

class _GenderDropdownState extends State<GenderDropdown> {
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF7854), Color(0xFFFD267D)],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(1.5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: DropdownButtonFormField<String>(
            value: _selectedGender,
            dropdownColor: Colors.black,
            hint: const Text(
              "Select Gender",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            iconEnabledColor: Colors.white,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: InputBorder.none,
            ),
            style: TextStyle(color: Colors.white),
            items: [
              DropdownMenuItem(
                value: "Male",
                child: Row(
                  children: [
                    Icon(Icons.male, color: Colors.lightBlue),
                    SizedBox(width: 10),
                    Text("Male", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: "Female",
                child: Row(
                  children: [
                    Icon(Icons.female, color: Colors.pinkAccent),
                    SizedBox(width: 10),
                    Text("Female", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedGender = value;
              });
              widget.onChanged(value); // Notify parent
            },
          ),
        ),
      ),
    );
  }
}
