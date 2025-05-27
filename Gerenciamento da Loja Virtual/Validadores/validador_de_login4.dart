import 'dart:async';

mixin class ValidadordeLogin {
  final validadordeEmail = StreamTransformer<String, String>.fromHandlers( //Entreda de String e se válido sairá String
    handleData: (email, sink) {
      if(email.contains('@')){
        sink.add(email); //Caso seja válido envia o email para o tubo como String
      } else {
        sink.addError('Insira um e-mail válido!');//Caso o e-mail não seja válido envia o erro ao sink
      }
    },
  );

  final validadordeSenha = StreamTransformer<String, String>.fromHandlers(
    handleData: (senha, sink) {
      if(senha.length >= 8){
        sink.add(senha); //Caso seja válida a senha, add a senha para o tubo como String
      } else {
        sink.addError('Senha inválida, deve conter pelo menos 8 caracteres!');//Caso a senha não seja válido envia o erro ao sink
      }
    },
  );
}
