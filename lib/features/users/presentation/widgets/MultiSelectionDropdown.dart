import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class MultiSelectionDropdown extends StatelessWidget {
  final String title;
  final List<String> items;
  final List<String> selectedItems;
  final ValueChanged<List<String>> onSelected;
  final String hintText;
  final bool isEnabled;

  const MultiSelectionDropdown({
    Key? key,
    required this.title,
    required this.items,
    required this.selectedItems,
    required this.onSelected,
    required this.hintText,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16.0),
        DropdownSearch<String>.multiSelection(
          items: (context, lp)=> items,
          mode: Mode.form,
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),
          suffixProps: DropdownSuffixProps(
              dropdownButtonProps: DropdownButtonProps(
                  color: Theme.of(context).colorScheme.primary)),
          popupProps: MultiSelectionPopupProps.dialog(
            dialogProps: DialogProps(
              clipBehavior: Clip.antiAlias,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            fit: FlexFit.loose,
            title: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inversePrimary),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary),
              ),
            ),
            showSearchBox: false,
          ),
          enabled: isEnabled,
          onSelected: onSelected,
          selectedItems: selectedItems,
        ),
      ],
    );
  }
}
