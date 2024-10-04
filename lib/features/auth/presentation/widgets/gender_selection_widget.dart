import 'package:flutter/material.dart';

class GenderSelectionWidget extends StatefulWidget {
  final ValueChanged<String?> onGenderSelected;

  const GenderSelectionWidget({super.key, required this.onGenderSelected});

  @override
  _GenderSelectionWidgetState createState() => _GenderSelectionWidgetState();
}

class _GenderSelectionWidgetState extends State<GenderSelectionWidget> {
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildGenderOption('Male', Icons.male, 'male'),
        const SizedBox(width: 20), // Add spacing between the options
        _buildGenderOption('Female', Icons.female, 'female'),
      ],
    );
  }

  // Helper method to build each gender option
  Widget _buildGenderOption(String label, IconData icon, String gender) {
    bool isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
        widget.onGenderSelected(_selectedGender);
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.blue : Colors.grey[300],
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black,
              size: 40,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
