import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/Blocos/bloco_categoria23.dart';
import 'package:gerente_loja/Widgets/image_source_sheet18.dart';

class DialogEditarCategoria extends StatefulWidget {
  final DocumentSnapshot? categoria;

  DialogEditarCategoria({this.categoria});

  @override
  State<DialogEditarCategoria> createState() =>
      _DialogEditarCategoriaState(categoria: categoria);
}

class _DialogEditarCategoriaState extends State<DialogEditarCategoria> {
  final BlocoCategoria _blocoCategoria;
  final TextEditingController _controlador;

  _DialogEditarCategoriaState({DocumentSnapshot? categoria})
    : _blocoCategoria = BlocoCategoria(categoria),
      _controlador = TextEditingController(
        text: (categoria?.data() as Map<String, dynamic>?)?['title'] ?? '',
      );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder:
                        (context) => ImageSourceSheet(
                          naImagemSelecionada: (imagem) {
                            Navigator.of(context).pop();
                            _blocoCategoria.setImage(imagem);
                          },
                        ),
                  );
                },
                child: StreamBuilder(
                  stream: _blocoCategoria.saidaImagem,
                  builder: (context, snapshot) {
                    if (snapshot.data != null)
                      return CircleAvatar(
                        child:
                            snapshot.data is File
                                ? Image.file(snapshot.data, fit: BoxFit.cover)
                                : Image.network(
                                  snapshot.data,
                                  fit: BoxFit.cover,
                                ),
                        backgroundColor: Colors.transparent,
                      );
                    else
                      return Icon(Icons.image);
                  },
                ),
              ),
              title: StreamBuilder<String>(
                stream: _blocoCategoria.saidaTitulo,
                builder: (context, snapshot) {
                  return TextField(
                    controller: _controlador,
                    onChanged: _blocoCategoria.setTitle,
                    decoration: InputDecoration(
                      errorText: snapshot.hasError ? snapshot.error as String : null
                    ),
                  );
                }
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StreamBuilder<bool>(
                  stream: _blocoCategoria.saidaDeletar,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    return ElevatedButton(
                      child: Text(
                        'Excluir',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: snapshot.data! ? () {
                        _blocoCategoria.deletar();
                        Navigator.of(context).pop();
                      } : null,
                    );
                  },
                ),
                StreamBuilder<bool>(
                  stream: _blocoCategoria.submitValid,
                  builder: (context, snapshot) {
                    return ElevatedButton(child: Text('Salvar'), onPressed: snapshot.hasData ? () async{
                      await _blocoCategoria.salvarDados();
                      Navigator.of(context).pop();
                    } : null);
                  }
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
