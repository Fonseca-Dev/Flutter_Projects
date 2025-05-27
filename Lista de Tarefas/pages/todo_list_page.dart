// Importação das bibliotecas necessárias
import 'package:flutter/material.dart'; // Biblioteca do Flutter para criação de widgets e interface gráfica
import 'package:todo_list/models/todo.dart'; // Importa a classe Todo que representa uma tarefa
import 'package:todo_list/repositories/todo_repository.dart';
import 'package:todo_list/widgets/todo_list_item.dart'; // Importa o widget TodoListItem para exibir cada tarefa

// Definindo a página de lista de tarefas como um StatefulWidget
class TodoListPage extends StatefulWidget {
  // Construtor padrão, recebendo a chave 'key' para gerenciamento de estado
  const TodoListPage({super.key});

  @override
  // Método que cria o estado da página
  State<TodoListPage> createState() => _TodoListPageState();
}

// Estado da página TodoListPage, que controla a lógica de interação
class _TodoListPageState extends State<TodoListPage> {
  // Controlador para o campo de texto onde o usuário digita a tarefa
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  // Lista para armazenar as tarefas
  List<Todo> todos = [];
  Todo? deletedTodo;
  int? deletedToodoPos;

  String? errorText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  // Método build que descreve a interface da página
  @override
  Widget build(BuildContext context) {
    // SafeArea garante que a UI não seja sobreposta por áreas do sistema (como a barra de status ou teclado)
    return SafeArea(
      child: Scaffold(
        // Corpo da página, que centraliza o conteúdo
        body: Center(
          child: Padding(
            // Adiciona um padding de 16 pixels ao redor do conteúdo
            padding: const EdgeInsets.all(16),
            child: Column(
              // Organiza os widgets na vertical
              mainAxisSize: MainAxisSize.min,
              children: [
                // Linha contendo o campo de texto e o botão para adicionar a tarefa
                Row(
                  children: [
                    // Expande o campo de texto para ocupar o máximo de espaço disponível
                    Expanded(
                      child: TextField(
                        // Controlador que controla o texto do campo
                        controller: todoController,
                        // Decoração do campo de texto com borda e rótulos
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Adicione uma tarefa',

                          // Texto explicativo sobre o que adicionar
                          hintText: 'Ex. Estudar Flutter',
                          // Dica sobre o que inserir
                          errorText: errorText,
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xff00d7f3), width: 2),
                          ),
                          labelStyle: TextStyle(
                            color: Color(0xff00d7f3),
                          ),
                        ),
                      ),
                    ),
                    // Espaçamento de 8 pixels entre o campo de texto e o botão
                    SizedBox(
                      width: 8,
                    ),
                    // Botão para adicionar a tarefa
                    ElevatedButton(
                      onPressed: () {
                        // Ao pressionar o botão, captura o texto inserido no campo
                        String text = todoController.text;
                        if (text.isEmpty) {
                          setState(() {
                            errorText = 'O título não pode ser vazio!';
                          });
                          return; //Esse return é utilizado para caso for vazio não executar o codigo abaixo para salvar
                        }
                        setState(() {
                          // Atualiza o estado da página, criando uma nova tarefa
                          Todo newTodo = Todo(
                            title: text,
                            // O título da tarefa é o texto inserido
                            dateTime: DateTime
                                .now(), // A data e hora da criação da tarefa
                          );
                          todos.add(
                              newTodo); // Adiciona a nova tarefa à lista de tarefas
                          errorText = null;
                        });
                        todoController.clear();
                        todoRepository.saveTodoList(todos);
                        // Limpa o campo de texto após adicionar a tarefa
                      },
                      // Estilo do botão: cor de fundo, padding e bordas arredondadas
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff00d7f3),
                        // Cor de fundo do botão
                        padding: EdgeInsets.all(14),
                        // Espaçamento interno do botão
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(5), // Bordas arredondadas
                        ),
                      ),
                      // Ícone de adicionar dentro do botão
                      child: Icon(
                        Icons.add,
                        size: 30, // Tamanho do ícone
                      ),
                    ),
                  ],
                ),
                // Espaçamento vertical de 16 pixels abaixo da linha
                SizedBox(
                  height: 16,
                ),
                // A ListView vai exibir a lista de tarefas, ajustando seu tamanho conforme necessário
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    // A lista ocupa apenas o espaço necessário para os itens
                    children: [
                      // Itera sobre a lista de tarefas e cria um widget TodoListItem para cada uma
                      for (Todo todo in todos)
                        TodoListItem(
                          todo: todo,
                          onDelete:
                              onDelete, // Passa a tarefa como parâmetro para o widget
                        ),
                    ],
                  ),
                ),
                // Espaçamento vertical de 16 pixels abaixo da lista
                SizedBox(
                  height: 16,
                ),
                // Linha contendo a informação sobre o número de tarefas pendentes e o botão "Limpar tudo"
                Row(
                  children: [
                    // Expande o texto para ocupar o espaço disponível
                    Expanded(
                      child: Text(
                        // Exibe o número de tarefas pendentes
                        'Você possui ${todos.length} tarefas pendentes',
                      ),
                    ),
                    // Espaçamento de 8 pixels entre o texto e o botão
                    SizedBox(
                      width: 8,
                    ),
                    // Botão para limpar todas as tarefas (ainda sem funcionalidade implementada)
                    ElevatedButton(
                      onPressed: showDeleteTodosConfirmationDialog,
                      // Ação do botão ainda não foi implementada
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff00d7f3),
                        padding: EdgeInsets.all(14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text('Limpar tudo'), // Texto exibido no botão
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedToodoPos = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Tarefa ${todo.title} foi removida com sucesso!',
        style: TextStyle(color: Color(0xff060708)),
      ),
      backgroundColor: Colors.white,
      action: SnackBarAction(
        label: 'Desfazer',
        textColor: const Color(0xff0085A0),
        onPressed: () {
          setState(() {
            todos.insert(deletedToodoPos!, deletedTodo!);
          });
          todoRepository.saveTodoList(todos);
        },
      ),
      duration: const Duration(seconds: 5),
    ));
  }

  void showDeleteTodosConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar Tudo?'),
        content: Text('Você tem certeza que deseja apagar todos as taferas?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Color(0xff0085A0)),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteAllTodos();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Limpar Tudo'),
          ),
        ],
      ),
    );
  }

  void deleteAllTodos() {
    setState(() {
      todos.clear();
      todoRepository.saveTodoList(todos);
    });
  }
}
