import 'package:flutter/material.dart';

class ItemValidationMixin {
  BuildContext validationContext;
  String validateItem(String value) {
    value = value.trim();
    if(value.isEmpty) {
      return 'cannot_empty';
    }
    else if(value.length > 1000 ) {
      return 'item_cannot_gt';
    }
    return null;
  }
}