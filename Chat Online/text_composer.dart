import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {

  final Function({String text, XFile imgFile}) sendMessage;

  TextComposer(this.sendMessage);

  @override
  State<TextComposer> createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  bool _isComposing = false;

  final TextEditingController _controller = TextEditingController();

  void _reset() {
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () async {
              ImagePicker picker = ImagePicker();
              final XFile? imgFile = await picker.pickImage(source: ImageSource.camera);

              if (imgFile != null) {
                widget.sendMessage(imgFile: imgFile);
              }
            },
            icon: Icon(Icons.photo_camera),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration.collapsed(
                hintText: 'Enviar uma Mensagem',
              ),
              onChanged: (text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: (text) {
                widget.sendMessage(text: text);
                _reset();
              },
            ),
          ),
          IconButton(
            onPressed:
                _isComposing
                    ? () {
                      widget.sendMessage(text: _controller.text);
                      _reset();
                    }
                    : null,
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
