import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ikms/app/controller/todo_controller.dart';
import 'package:ikms/app/modules/todos/widgets/todos_card.dart';
import 'package:ikms/app/widgets/list_empty.dart';

class TodosList extends StatefulWidget {
  const TodosList({
    super.key,
    required this.done,
    required this.searchTodo,
  });
  final bool done;
  final String searchTodo;

  @override
  State<TodosList> createState() => _TodosListState();
}

class _TodosListState extends State<TodosList> {
  final todoController = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        var todos = todoController.todos
            .where((todo) =>
                todo.done == widget.done &&
                (widget.searchTodo.isEmpty ||
                    todo.name.toLowerCase().contains(widget.searchTodo)))
            .toList()
            .obs;

        return todos.isEmpty
            ? ListEmpty(
                img: 'assets/images/add.png',
                text: widget.done ? 'copletedTodo'.tr : 'addTodo'.tr,
              )
            : ListView(
                children: [
                  ...todos.map(
                    (todosList) => TodosCard(
                      key: ValueKey(todosList),
                      todos: todosList,
                    ),
                  ),
                ],
              );
      },
    );
  }
}
