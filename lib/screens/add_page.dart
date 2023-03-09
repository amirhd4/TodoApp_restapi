import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo["title"];
      final description = todo["description"];
      titleController.text = title;
      descriptionController.text = description;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Todo" : "Add Todo"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: "Title"),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: "Description"),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(isEdit ? "Update" : "Submit"),
            ),
          )
        ],
      ),
    );
  }

  Future<void> updateData() async {
    // Get the data from form
    final todo = widget.todo;
    if (todo == null) {
      debugPrint("You can not call updated without todo data");
      return;
    }
    final id = todo["_id"];
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    // Submit update data to the server
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await put(uri, body: jsonEncode(body), headers: {
      "Content-Type": "application/json",
    });

    // show success or fail messaage based on status
    if (response.statusCode == 200) {
      showSuccessMessage("Updation Success");
    } else {
      showErrorMessage("Updation Failed");
    }
  }

  Future<void> submitData() async {
    // Get the data from form
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    // Submit data to the server
    const url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await post(uri, body: jsonEncode(body), headers: {
      "Content-Type": "application/json",
    });

    // show success or fail messaage based on status
    if (response.statusCode == 201) {
      titleController.text = "";
      descriptionController.text = "";
      showSuccessMessage("Creation Success");
    } else {
      showErrorMessage("Creation Failed");
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
