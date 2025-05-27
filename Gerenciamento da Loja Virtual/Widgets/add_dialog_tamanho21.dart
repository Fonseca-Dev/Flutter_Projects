import 'package:flutter/material.dart';

class AddDialogTamanho extends StatelessWidget {

  final _controlador = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8, top: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controlador,
            ),
            Container(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(_controlador.text);
                },
                child: Text('Adicionar', style: TextStyle(color: Colors.pink)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
