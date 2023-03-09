import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sample_restapi/screens/add_page.dart';
import 'package:sample_restapi/services/todo_service.dart';
import 'package:sample_restapi/utils/snackbar_helper.dart';
import 'package:sample_restapi/widgets/todo_card.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List items = [];
  late bool _isLoading;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    setLoadingTimer();
  }

  Future<void> setLoadingTimer() async {
    _isLoading = true;
    setState(() {});

    Timer(
      const Duration(seconds: 5),
      () {
        setState(() {
          _isLoading = false;
        });
      },
    );
    await fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "No Todo Item",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            setLoadingTimer();
                          },
                          child: const Icon(Icons.replay_outlined)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: fetchTodo,
                  child: ListView.builder(
                    itemCount: items.length,
                    padding: const EdgeInsets.all(8.0),
                    itemBuilder: (context, index) {
                      final item = items[index] as Map;
                      return TodoCard(
                        index: index,
                        item: item,
                        deleteById: deleteById,
                        navigationEdit: navigateToEditPage,
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: const Text("Add Todo"),
      ),
    );
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo: item),
    );
    await Navigator.push(context, route);
    setLoadingTimer();
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodoPage(),
    );
    await Navigator.push(context, route);
    setLoadingTimer();
  }

  Future<void> deleteById(String id) async {
    final isSuccess = await TodoService.deleteById(id);
    if (isSuccess) {
      // Remove item from the list
      setState(() {
        items = items.where((element) => element["_id"] != id).toList();
      });
    } else {
      // Show error
      doSomething(() {
        showErrorMessage(context, message: "Deletaion Failed");
      });
    }
  }

  Future<void> fetchTodo() async {
    final response = await TodoService.fetchTodos();
    if (response != null) {
      setState(() {
        items = response;
        _isLoading = false;
      });
    } else {
      doSomething(() {
        showErrorMessage(context, message: "Something went wrong");
      });
    }
  }
}
