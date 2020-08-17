import 'package:flutter/material.dart';

class ItemValidationMixin {
  BuildContext validationContext;
  String validateItem(String value) {
    value = value.trim();
    if(value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }
}