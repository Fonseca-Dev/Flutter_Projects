import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/Blocos/bloco_produtos16.dart';
import 'package:gerente_loja/Validadores/validador_de_produto19.dart';
import 'package:gerente_loja/Widgets/tamanhos_produto20.dart';

import '../Widgets/widget_imagens17.dart';

class TelaProdutos extends StatefulWidget {
  final String? categoriaId;
  final DocumentSnapshot? produto;

  TelaProdutos({this.categoriaId, this.produto});

  @override
  State<TelaProdutos> createState() => _TelaProdutosState(categoriaId, produto);
}

class _TelaProdutosState extends State<TelaProdutos> with ValidadorProduto {
  final BlocoProdutos _blocoProdutos;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _TelaProdutosState(String? categoriaId, DocumentSnapshot? produto)
    : _blocoProdutos = BlocoProdutos(
        categoriaId: categoriaId,
        produto: produto,
      );

  @override
  Widget build(BuildContext context) {
    final _estiloField = TextStyle(color: Colors.white, fontSize: 16);

    InputDecoration _construtorDecoracao(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: StreamBuilder<bool>(
          stream: _blocoProdutos.saidaCriado,
          initialData: false,
          builder: (context, snapshot) {
            return Text(snapshot.data! ? 'Editar Produto' : 'Criar Produto');
          },
        ),
        actions: [
          StreamBuilder<bool>(
            stream: _blocoProdutos.saidaCriado,
            initialData: false,
            builder: (context, snapshot){
              if(snapshot.data!)
                return StreamBuilder<bool>(
                  stream: _blocoProdutos.saidaCarregando,
                  initialData: false,
                  builder: (context, snapshot) {
                    return IconButton(
                      onPressed: (snapshot.data ?? false) ? null : (){
                        _blocoProdutos.deletarProduto();
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.remove),
                    );
                  },
                );
              else return Container();
            },
          ),
          StreamBuilder<bool>(
            stream: _blocoProdutos.saidaCarregando,
            initialData: false,
            builder: (context, snapshot) {
              return IconButton(
                onPressed: (snapshot.data ?? false) ? null : salvarProduto,
                icon: Icon(Icons.save),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Form(
            //Utilizamos para fazer validação de dados
            key: _formKey,
            child: StreamBuilder<Map>(
              //Retorna um map que é o mesmo tipo do _controladorDados
              stream: _blocoProdutos.saidaDados,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                return ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    Text(
                      'Imagens',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    WidgetImagens(
                      context: context,
                      valorInicial: snapshot.data!['images'],
                      onSaved: _blocoProdutos.salvarImagens,
                      validador: validadorImagem,
                    ),
                    TextFormField(
                      initialValue: snapshot.data!['title'],
                      style: _estiloField,
                      decoration: _construtorDecoracao('Titulo'),
                      onSaved: _blocoProdutos.salvarTitulo,
                      validator: validadorTitulo,
                    ),
                    TextFormField(
                      initialValue: snapshot.data!['description'],
                      style: _estiloField,
                      decoration: _construtorDecoracao('Descrição'),
                      maxLines: 6,
                      onSaved: _blocoProdutos.salvarDescricao,
                      validator: validadorDescricao,
                    ),
                    TextFormField(
                      initialValue: snapshot.data!['price']?.toStringAsFixed(2),
                      style: _estiloField,
                      decoration: _construtorDecoracao('Preço'),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onSaved: _blocoProdutos.salvarPreco,
                      validator: validadorPreco,
                    ),
                    SizedBox(height: 16,),
                    Text(
                      'Tamanhos',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    TamanhosProduto(
                      context: context,
                      valorInicial: snapshot.data!['sizes'],
                      onSaved: (tamanhos) => _blocoProdutos.salvarTamanhos(tamanhos!),
                      validador: (s){
                        if(s!.isEmpty) return 'Adicione um tamanho';
                      },
                    )
                  ],
                );
              },
            ),
          ),
          StreamBuilder<bool>(
            stream: _blocoProdutos.saidaCarregando,
            initialData: false,
            builder: (context, snapshot) {
              return IgnorePointer(
                ignoring: !(snapshot.data ?? false),
                child: Container(
                  color:
                      (snapshot.data ?? false)
                          ? Colors.black54
                          : Colors.transparent,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void salvarProduto() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Salvando produto...',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(minutes: 1),
          backgroundColor: Colors.pinkAccent,
        ),
      );

      bool sucesso = await _blocoProdutos.salvarProduto();

      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            sucesso ? 'Produto salvo!' : 'Erro ao salvar produto!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.pinkAccent,
        ),
      );
    }
  }
}
