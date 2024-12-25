import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class SingleSelectionDropdown extends StatelessWidget {
  final String title;
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String?> onSelected;
  final String hintText;
  final bool isEnabled;
  final FormFieldValidator<String?>? validator; // Add this line

  const SingleSelectionDropdown({
    Key? key,
    required this.title,
    required this.items,
    this.selectedItem,
    required this.onSelected,
    required this.hintText,
    this.isEnabled = true,
    this.validator, // Add this line
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double borderRadiusValue = screenWidth * 0.05;
    double fontSize = screenWidth * 0.04; // 4% of screen width for font size
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(borderRadiusValue),
      ),
      child: DropdownSearch<String>(
        onSelected: onSelected,
        items: (f, cs) => items,
        mode: Mode.form,
        validator: validator, // Use the passed validator
        suffixProps: DropdownSuffixProps(
            dropdownButtonProps: DropdownButtonProps(
                color: Theme.of(context).colorScheme.primary)),
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle:TextStyle(
              color: Theme.of(context).colorScheme.inverseSurface,
              fontFamily: 'NotoKufiArabic',
              fontSize: fontSize, // Responsive font size for hint text
              height: 1.5,
            ),
            alignLabelWithHint: true,
            contentPadding: const EdgeInsets.only(left: 16.0, right: 16, top: 12),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color:  Theme.of(context).colorScheme.secondary, // Color for the underline when not focused
                width: 0,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color:  Theme.of(context).colorScheme.secondary, // Color for the underline when focused
                width:0,
              ),
            ),
          ),
        ),

        selectedItem: selectedItem,

        popupProps: PopupProps.dialog(
          fit: FlexFit.loose,
          showSelectedItems: true,
          title: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inverseSurface),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
          itemBuilder: (c, item, b,j){
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
              child: Text(item, style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontSize: 18
              )),
            );
          },
          dialogProps: DialogProps(
            clipBehavior: Clip.antiAlias,
            shape: OutlineInputBorder(
              borderSide: BorderSide(width: 0),
              borderRadius: BorderRadius.circular(28),
            ),
          ),
        ),
        enabled: isEnabled,
      ),
    );
  }
}