import 'package:flutter/material.dart';
import 'showform.dart';

class CardWidget extends StatelessWidget {
  Map<String, dynamic> currentItem;
  Function _deleteItem;
  ShowForm show;

  CardWidget(this.currentItem, this.show, this._deleteItem);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange.shade100,
      margin: const EdgeInsets.all(10),
      elevation: 3,
      child: ListTile(
        title: Text(currentItem[
            'task']), //name to task, quantity to tag, need date, from, to
        subtitle: Row(
          children: [
            Text("Tag: " + currentItem['tag'] + " | "),
            Text("Date: " + currentItem['date'] + " | "),
            Text("From: " + currentItem['from'] + " | "),
            Text("To: " + currentItem['to'] + ""),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Edit button
            IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async =>
                    show.showForm(context, currentItem['key'])),
            // Delete button
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteItem(currentItem['key']),
            ),
          ],
        ),
      ),
    );
  }
}
