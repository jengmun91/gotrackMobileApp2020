import 'package:flutter/material.dart';

addItemDialog(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: const Text('Select assignment'),
        children: <Widget>[
          SimpleDialogOption(
            child: const Text('Treasury department'),
          ),
          SimpleDialogOption(
            child: const Text('State department'),
          ),
        ],
      );
    },
  );
}
