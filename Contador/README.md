# Contador — Aplicativo Flutter para Controle de Acesso com Contador de Pessoas

Bem-vindo ao **Contador**, um app Flutter simples e elegante que simula o controle de entrada e saída de pessoas em um ambiente limitado, como uma sala, evento ou espaço comercial.

## 🚪 Funcionalidades Principais

- **Contador Dinâmico:** Acompanhe em tempo real quantas pessoas estão presentes no ambiente, com atualização instantânea na tela.
- **Limite de Capacidade:** O sistema impede que o número ultrapasse **20 pessoas** — quando o limite é alcançado, o botão de entrada é desativado. Da mesma forma, não permite valores negativos, bloqueando o botão de saída quando não há ninguém.
- **Mensagens Contextuais:** O status do local muda conforme o fluxo de pessoas, mostrando mensagens intuitivas como:
  - 🔵 *Vazio* (0 pessoas)
  - 🟢 *Pode entrar* (1 a 19 pessoas)
  - 🔴 *Lotado* (20 pessoas)
- **Interface Interativa:** Botões estilizados e responsivos permitem incrementar ou decrementar a contagem, com feedback visual claro e agradável.
- **Design Atraente:** Imagem de fundo personalizada, botões arredondados e paleta de cores pensada para destacar o status atual do ambiente.

## 🛠 Tecnologias Utilizadas

- **Flutter & Dart:** Desenvolvimento de interface nativa, moderna e responsiva para múltiplas plataformas.
- **Widgets Flutter:** Uso de `StatefulWidget`, `TextButton`, `Container` e outros para criar uma UI fluida.
- **Gestão de Estado com `setState()`:** Atualização simples e eficiente da contagem em tempo real.
- **Estilização Visual:** Imagens, cores e efeitos para tornar a experiência do usuário intuitiva e agradável.

## 🚀 Para que serve?

Este app é perfeito para quem está começando a aprender Flutter, servindo como base para projetos de controle de fluxo de pessoas. Também pode ser facilmente expandido para:

- Persistência de dados (local ou na nuvem)
- Notificações automáticas
- Integração com sensores físicos para controle real de acesso
