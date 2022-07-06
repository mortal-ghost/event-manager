import 'package:flutter/material.dart';

import 'colors.dart';

final textFieldDecoration = InputDecoration(
  filled: true,
  fillColor: kWhite,
  contentPadding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: kGrey,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: Colors.red,
    ),
  ),
);
