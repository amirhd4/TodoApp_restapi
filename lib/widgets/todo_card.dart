import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigationEdit;
  final Function(String) deleteById;
  const TodoCard(
      {super.key,
      required this.index,
      required this.item,
      required this.navigationEdit,
      required this.deleteById});

  @override
  Widget build(BuildContext context) {
    final id = item["_id"] as String;
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text("${index + 1}")),
        title: Text(item["title"]),
        subtitle: Text(item["description"]),
        trailing: PopupMenuButton(
          tooltip: "Options",
          onSelected: (value) {
            if (value == "edit") {
              // open edit page
              navigationEdit(item);
            } else if (value == "delete") {
              // delete and remove the item
              deleteById(id);
            }
          },
          itemBuilder: (context) {
            return const [
              PopupMenuItem(
                value: "edit",
                child: Text("Edit"),
              ),
              PopupMenuItem(
                value: "delete",
                child: Text("Delete"),
              ),
            ];
          },
        ),
      ),
    );
  }
}
