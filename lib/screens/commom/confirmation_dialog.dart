import 'package:flutter/material.dart';

Future <dynamic> showConfirmationDialog(
  BuildContext context, {
  String title = "Atenção",
  String content = "Deseja realmente executar esta operação?",
  String affimativeOption = "Confirmar",
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text("Cancelar")),
          TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                affimativeOption.toUpperCase(),
                style: TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ],
      );
    },
  );
}
