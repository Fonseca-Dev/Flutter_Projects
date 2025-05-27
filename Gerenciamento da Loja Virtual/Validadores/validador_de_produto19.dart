mixin class ValidadorProduto {

  String? validadorImagem(List<dynamic>? imagens) {
    if (imagens == null || imagens.isEmpty) return "Adicione imagens do produto";
    return null;
  }

  String? validadorTitulo(String? texto) {
    if (texto == null || texto.isEmpty) return 'Preencha o título do produto';
    return null;
  }

  String? validadorDescricao(String? texto) {
    if (texto == null || texto.isEmpty) return 'Preencha a descrição do produto';
    return null;
  }

  String? validadorPreco(String? texto) {
    if (texto == null || texto.isEmpty) return 'Preço inválido';
    double? preco = double.tryParse(texto);
    if (preco != null) {
      if (!texto.contains('.') || texto.split('.')[1].length != 2)
        return 'Utilize 2 casas decimais';
    } else {
      return 'Preço inválido';
    }
    return null;
  }
}
