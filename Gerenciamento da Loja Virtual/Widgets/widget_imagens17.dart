import 'dart:io';
import 'package:flutter/material.dart';
import 'image_source_sheet18.dart';

class WidgetImagens extends FormField<List> {
  WidgetImagens({
    required BuildContext context,
    FormFieldSetter<List>? onSaved,
    FormFieldValidator<List>? validador,
    List? valorInicial,
    bool validadorAutomatico = false,
  }) : super(
    onSaved: onSaved,
    validator: validador,
    initialValue: valorInicial ?? [],
    autovalidateMode: validadorAutomatico
        ? AutovalidateMode.always
        : AutovalidateMode.disabled,
    builder: (estado) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 124,
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: estado.value!.map<Widget>((i) {
                return Container(
                  height: 100,
                  width: 100,
                  margin: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    child: i is String
                        ? Image.network(i, fit: BoxFit.cover)
                        : Image.file(i as File, fit: BoxFit.cover),
                    onLongPress: () {
                      estado.didChange(estado.value!..remove(i));
                    },
                  ),
                );
              }).toList()
                ..add(
                  GestureDetector(
                    child: Container(
                      height: 100,
                      width: 100,
                      color: Colors.white.withAlpha(50),
                      child: const Icon(Icons.camera_enhance, color: Colors.white),
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => ImageSourceSheet(
                          naImagemSelecionada: (imagem) {
                            estado.didChange(estado.value!..add(imagem));
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  ),
                ),
            ),
          ),
          if (estado.hasError)
            Text(
              estado.errorText ?? '',
              style: const TextStyle(color: Colors.red, fontSize: 12),
            )
        ],
      );
    },
  );
}
