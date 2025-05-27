import 'package:flutter/material.dart';
import 'package:gerente_loja/Blocos/bloco_login3.dart';
import 'package:gerente_loja/Telas/tela_principal5.dart';
import 'package:gerente_loja/Widgets/entrada_text_field2.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _blocoLogin = BlocoLogin();


  @override
  void initState() {
    super.initState();

    _blocoLogin.outEstado.listen((estado) {
      switch (estado) {
        case EstadoLogin.SUCESSO:
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => TelaPrincipal()));
          break;
        case EstadoLogin.FALHA:
          showDialog(context: context,
              builder: (context) =>
                  AlertDialog(title: Text('Erro'),
                    content: Text(
                        'Você não possui os privilégios necessários'),));
          break;
        case EstadoLogin.PROCESSANDO:
        case EstadoLogin.PREENCHENDO:
      }
    });
  }


  @override
  void dispose() {
    _blocoLogin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Adicionado Scaffold
      backgroundColor: Colors.grey[850],
      body: StreamBuilder<EstadoLogin>(
        stream: _blocoLogin.outEstado,
        initialData: EstadoLogin.PROCESSANDO,
        builder: (context, snapshot) {
          switch (snapshot.data!) {
            case EstadoLogin.PROCESSANDO:
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
                ),
              );
            case EstadoLogin.FALHA:
            case EstadoLogin.SUCESSO:
            case EstadoLogin.PREENCHENDO:
              return Stack(
                //Utilizado para centralizar os widgets da tela
                alignment: Alignment.center,
                children: [
                  Container(), //Necessário para a centralização dos widgets
                  SingleChildScrollView(
                    //Utilizado pq quando abrir o teclado, o mesmo ocupará um espaço da tela e assim será possivel o rolamento do restante da tela
                    child: Container(
                      //Utilizado para definir uma margem
                      margin: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        //serve para ocupar toda a coluna no eixo cruzado da coluna
                        children: [
                          Icon(
                            Icons.store_mall_directory,
                            color: Colors.pinkAccent,
                            size: 160,
                          ),
                          EntradaTextField(
                            icone: Icons.person_outline,
                            hint: 'Usuário',
                            obscure: false,
                            stream: _blocoLogin.outEmail,
                            onChanged: _blocoLogin.changeEmail,
                          ),
                          EntradaTextField(
                            icone: Icons.lock_outline,
                            hint: 'Senha',
                            obscure: true,
                            stream: _blocoLogin.outSenha,
                            onChanged: _blocoLogin.changeSenha,
                          ),
                          SizedBox(height: 32),
                          StreamBuilder<bool>(
                            stream: _blocoLogin.outSubmitValid,
                            builder: (context, snapshot) {
                              return SizedBox(
                                //Instaurado para configurar o height ou a altura do botão
                                height: 50,
                                child: ElevatedButton(
                                  onPressed:
                                  snapshot.hasData ? _blocoLogin.submit : null,
                                  //Quando retornar true do outSubmitValid ativa o botão Entrar
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pinkAccent,
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: Colors.pinkAccent
                                        .withAlpha(100),
                                    disabledForegroundColor: Colors.grey
                                        .withAlpha(
                                      100,
                                    ),
                                  ),
                                  child: Text('Entrar'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
          }
        },
      ),
    );
  }
}
