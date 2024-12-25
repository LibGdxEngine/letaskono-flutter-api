import 'package:flutter/material.dart';

class AcceptRejectToggle extends StatefulWidget {
  final Function(bool?) onChange; // Accepts a nullable boolean
  bool? isAcceptSelected; // Nullable to handle no selection

  AcceptRejectToggle({required this.onChange, this.isAcceptSelected});

  @override
  _AcceptRejectToggleState createState() => _AcceptRejectToggleState();
}

class _AcceptRejectToggleState extends State<AcceptRejectToggle> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        height: 44, // Height of the toggle bar
        decoration: BoxDecoration(
          color: const Color(0xFFDD88CF), // Background color
          borderRadius: BorderRadius.circular(16), // Rounded corners
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Accept Button
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.isAcceptSelected = true; // Set to "Accept"
                    });
                    widget.onChange(widget.isAcceptSelected);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: widget.isAcceptSelected == true
                          ? Colors.grey.shade100 // Light green when selected
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "طلب رؤية شرعية",
                      style: TextStyle(
                        color: widget.isAcceptSelected == true
                            ? const Color(0xFF22172A)
                            : const Color(0xFFF5F5F5),
                        // Dark green text
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 1,
              height: 44,
              color: Theme.of(context).colorScheme.surface,
            ),
            // Reject Button
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.isAcceptSelected = false; // Set to "Reject"
                    });
                    widget.onChange(widget.isAcceptSelected);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: widget.isAcceptSelected == false
                          ? Colors.grey.shade100 // Light red when selected
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "رفض الاستمرار",
                      style: TextStyle(
                        color: widget.isAcceptSelected == false
                            ? const Color(0xFF22172A)
                            : const Color(0xFFF5F5F5),
                        // Dark red text
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
