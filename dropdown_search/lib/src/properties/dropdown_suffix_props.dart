import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DropdownSuffixProps {
  final ClearButtonProps? clearButtonProps;
  final DropdownButtonProps? dropdownButtonProps;
  final TextDirection? direction;

  const DropdownSuffixProps({
    this.clearButtonProps,
    this.dropdownButtonProps,
    this.direction,
  });
}
