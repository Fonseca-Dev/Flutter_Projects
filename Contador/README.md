Descrição do Aplicativo – Controle de Acesso com Contador

Este aplicativo Flutter simula um sistema de controle de entrada e saída de pessoas em um ambiente, como uma sala ou evento, com capacidade máxima de 20 pessoas. A interface é visualmente atrativa, utilizando uma imagem de fundo e botões estilizados.

Funcionalidades principais:
Contador dinâmico: Exibe em tempo real a quantidade atual de pessoas presentes no ambiente.

Limites de capacidade: O app bloqueia o botão de entrada ao atingir a capacidade máxima (20 pessoas) e o botão de saída quando não há ninguém no local (0 pessoas).

Mensagens contextuais: O status do ambiente é exibido com mensagens como "Vazio", "Pode entrar" ou "Lotado", variando conforme o número de pessoas.

Interface interativa: Os botões “Entrou” e “Saiu” permitem alterar o número de pessoas, com feedback visual intuitivo.

Tecnologias utilizadas:
Flutter e Dart: Framework para criação de interfaces modernas e responsivas.

Widgets: StatefulWidget, TextButton, Text, Container, entre outros.

Gestão de estado: Implementada com setState() para atualizações em tempo real.

Estilização: Uso de imagens de fundo, botões arredondados e cores para destacar o status atual do ambiente.

Esse app é ideal como base para projetos iniciais que envolvem controle de fluxo de pessoas, podendo ser expandido para incluir persistência de dados, notificações ou integração com sensores físicos em um cenário real.
