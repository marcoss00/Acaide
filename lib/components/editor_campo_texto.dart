import 'package:flutter/material.dart';

class EditorCampoTexto extends StatelessWidget {
  final String? Function(String?)? validador;
  final TextInputType? teclado;
  final TextEditingController? controlador;
  final String? counterText;
  final String? dica;
  final String? rotulo;
  final IconData? icone;


  EditorCampoTexto(
      {this.validador,
      this.teclado,
      this.controlador,
      this.counterText,
      this.dica,
      this.rotulo,
      this.icone});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validador,
      controller: controlador,
      keyboardType: teclado != null ? TextInputType.text : null,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        counterText: counterText,
        counterStyle: TextStyle(color: Colors.white),
        hintText: dica,
        hintStyle: TextStyle(color: Colors.white),
        labelText: rotulo,
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        prefixIcon: Icon(
          icone,
          color: Colors.white,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
