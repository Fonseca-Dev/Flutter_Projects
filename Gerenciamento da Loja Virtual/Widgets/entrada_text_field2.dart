import 'package:flutter/material.dart';

class EntradaTextField extends StatelessWidget {
  //Criação de parâmetros para diferenciar as TextFields
  final IconData? icone;
  final String? hint;
  final bool obscure;
  final Stream<String>? stream;
  final Function(String)? onChanged;

  const EntradaTextField({super.key, this.icone, this.hint, this.obscure = false, this.stream, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: stream,
      builder: (context, snapshot) {
        return TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            //Utilizado pois é uma eentrada de texto
            icon: Icon(icone, color: Colors.white),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white),
            focusedBorder: UnderlineInputBorder( //é a linha que fica embaixo do TextField
              borderSide: BorderSide(color: Colors.pinkAccent)
            ),
            contentPadding: EdgeInsets.only(//Configuração do padding das TextFields
              left: 5,
              right: 30,
              bottom: 30,
              top: 30
            ),
              errorText: snapshot.hasError ? snapshot.error.toString() : null, //Se a stream que pegarmos apresentar um erro, aqui será apresentado ao usuário
          ),
          style: TextStyle(color: Colors.white),
          obscureText: obscure,
        );
      }
    );
  }
}
