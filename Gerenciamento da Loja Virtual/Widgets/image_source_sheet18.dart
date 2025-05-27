import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  final Function(File) naImagemSelecionada;

  const ImageSourceSheet({super.key, required this.naImagemSelecionada});

  void imagemSelecionada(XFile? imagem) async {
    try {
      if (imagem != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: imagem.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Editar imagem',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              lockAspectRatio: false,
            ),
            IOSUiSettings(title: 'Editar imagem'),
          ],
        );

        if (croppedFile != null) {
          final imagemFinal = File(croppedFile.path);
          if (await imagemFinal.exists()) {
            naImagemSelecionada(imagemFinal);
          } else {
            print("Imagem recortada não encontrada: ${croppedFile.path}");
          }
        } else {
          print("Recorte cancelado pelo usuário.");
        }
      }
    } catch (e) {
      print("Erro ao selecionar/recortar imagem: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder:
          (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () async {
                  final picker = ImagePicker();
                  final imagem = await picker.pickImage(
                    source: ImageSource.camera,
                  );
                  imagemSelecionada(imagem);
                },
                child: const Text('Câmera'),
              ),
              TextButton(
                onPressed: () async {
                  final picker = ImagePicker();
                  final imagem = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  imagemSelecionada(imagem);
                },
                child: const Text('Galeria'),
              ),
            ],
          ),
    );
  }
}
