import 'dart:async';

import 'package:flutter/material.dart';

class SnackBarError<T> {
  final BuildContext _context;

  SnackBarError(this._context);

  FutureOr<T> call(Object error, StackTrace trace) {
    final snack = SnackBar(content: Text('$error'));
    ScaffoldMessenger.of(_context).showSnackBar(snack);
    throw error;
  }
}
