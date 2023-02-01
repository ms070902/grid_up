import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart';

@immutable
class AlertDialogModel<T> {
  final String title;
  final String message;
  final Map<String, T> buttons;

  const AlertDialogModel({
    required this.title,
    required this.message,
    required this.buttons,
  });
}

extension Present<T> on AlertDialogModel<T> {
  Future<T?> present(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: buttons.entries.map((entry) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(entry.value);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueGrey[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  )
                ),
                child: Text(
                  entry.key,
                ),
              );
            }).toList(),
          );
        });
  }
}
