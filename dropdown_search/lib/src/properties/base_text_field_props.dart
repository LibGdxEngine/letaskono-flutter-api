import 'package:dropdown_search/src/base_dropdown_search.dart';
import 'package:flutter/material.dart';

abstract class BaseTextFieldProps {
  final TextEditingController? controller;
  final ContainerBuilder? containerBuilder;

  const BaseTextFieldProps({
    this.controller,
    this.containerBuilder,
  });
}
