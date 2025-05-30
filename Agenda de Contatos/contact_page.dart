import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../helpers/contact_helper.dart';

class ContactPage extends StatefulWidget {
  final Contact? contact;

  ContactPage({this.contact});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  bool _userEdited = false;

  Contact? _editedContact;

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = widget.contact != null
          ? Contact.fromMap(widget.contact!.toMap())
          : Contact();

      _nameController.text = _editedContact!.name ?? '';
      _emailController.text = _editedContact!.email ?? '';
      _phoneController.text = _editedContact!.phone ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            title: Text(_editedContact?.name ?? "Novo Contato"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_editedContact!.name != null &&
                  _editedContact!.name!.isNotEmpty) {
                Navigator.pop(context, _editedContact);
              } else {
                FocusScope.of(context).requestFocus(_nameFocus);
              }
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: (_editedContact?.img != null &&
                                  _editedContact!.img!.isNotEmpty)
                              ? FileImage(File(_editedContact!.img!))
                              : AssetImage('images/person.png')
                                  as ImageProvider),
                    ),
                  ),
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? file =
                        await picker.pickImage(source: ImageSource.camera);
                    if (file == null) return;
                    setState(() {
                      _editedContact!.img = file.path;
                    });
                  },
                ),
                TextField(
                  focusNode: _nameFocus,
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nome'),
                  onChanged: (text) {
                    _userEdited = true;
                    setState(() {
                      _editedContact!.name = text;
                    });
                  },
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'E-mail'),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedContact!.email = text;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedContact!.phone = text;
                  },
                  keyboardType: TextInputType.phone,
                )
              ],
            ),
          ),
        ),
        onWillPop: _requestPop);
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Descartar alterações?'),
              content: Text('Se sair as alterações serão perdidas.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text('Sim'),
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
