import 'package:flutter/material.dart';

class GenderToggle extends StatefulWidget {
  // The callback function that will notify the parent of the selection change
  final Function(bool) onChange;
  bool isMaleSelected;
  // Constructor accepting the callback function
  GenderToggle({required this.onChange, required this.isMaleSelected});

  @override
  _GenderToggleState createState() => _GenderToggleState();
}

class _GenderToggleState extends State<GenderToggle> {
  // Track the selected gender


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        height: 44, // Height of the toggle bar
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary, // Light pink background
          borderRadius: BorderRadius.circular(16), // Rounded corners for the parent container
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Male Button
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.isMaleSelected = true;
                    });
                    widget.onChange(widget.isMaleSelected); // Notify parent with updated state
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: widget.isMaleSelected
                          ? Colors.white // White when selected
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "الرجال",
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .primary, // Dark purple text color
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Female Button
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.isMaleSelected = false;
                    });
                    widget.onChange(widget.isMaleSelected); // Notify parent with updated state
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: !widget.isMaleSelected
                          ? Colors.white // White when selected
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "النساء",
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .primary, // Dark purple text color
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
