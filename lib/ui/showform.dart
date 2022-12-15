import 'package:flutter/material.dart';
import '../util/dbhelper.dart';
import 'page1.dart';

class ShowForm extends StatelessWidget {
  void Function() refreshItems;
  Database db;
  late List<Map<String, dynamic>> items;
  //late List<Map<String, dynamic>> searchedItems;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime dateTime = DateTime.now();
  bool showDate = false;
  bool showTime = false;
  bool showDateTime = false;

  late String taskquery;
  late String tagquery;
  late String datequery;

  ShowForm({required this.db, required this.refreshItems});

// TextFields' controllers
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  final TextEditingController _querytaskController = TextEditingController();
  final TextEditingController _querytagController = TextEditingController();
  final TextEditingController _querydateController = TextEditingController();

  void updateItems(List<Map<String, dynamic>> items) {
    this.items = items;
  }

  void searchTask(String query) {
    List<Map<String, dynamic>> searchedItems = [];
    print("Search task activated");
    for (Map<String, dynamic> item in items) {
      if (item['task'] == query) {
        searchedItems.add(item);
        //items.add(item);
        print("Match found");
      } else {
        print("Match not found");
      }
    }
    print("These items match your search: ");
    print(searchedItems);
  }

  void searchTag(String query) {
    List<Map<String, dynamic>> searchedItems = [];
    print("Search task activated");
    for (Map<String, dynamic> item in items) {
      if (item['tag'] == query) {
        searchedItems.add(item);
        //items.add(item);
        print("Match found");
      } else {
        print("Match not found");
      }
    }
    print("These items match your search: ");
    print(searchedItems);
  }

  void searchDate(
    String query,
  ) {
    // List<String> strings = [];
    List<Map<String, dynamic>> searchedItems = [];
    print("Search task activated");
    for (Map<String, dynamic> item in items) {
      if (item['date'] == query) {
        searchedItems.add(item);
        //items.add(item);
        print("Match found");
      } else {
        print("Match not found");
      }
    }
    print("These items match your search: ");
    print(searchedItems);
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      selectedDate = selected;
    }

    return selectedDate;
  }

  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (selected != null && selected != selectedTime) {
      selectedTime = selected;
    }
    return selectedTime;
  }

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void showForm(BuildContext ctx, int? itemKey) async {
    // itemKey == null -> create new item
    // itemKey != null -> update an existing item

    if (itemKey != null) {
      final existingItem =
          items.firstWhere((element) => element['key'] == itemKey);
      _taskController.text = existingItem['task'];
      _tagController.text = existingItem['tag'];
      _taskController.text = existingItem['date'];
      _taskController.text = existingItem['from'];
      _taskController.text = existingItem['to'];
    }

    showModalBottomSheet(
      context: ctx,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            top: 15,
            left: 15,
            right: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(hintText: 'task'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _tagController,
              decoration: const InputDecoration(hintText: 'tag'),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  var date = await _selectDate(ctx);

                  // showDate = true;
                  _dateController.text = date.toString();
                },
                child: const Text('Date Picker'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  var fromtime = await _selectTime(ctx);
                  print("From time below: ");
                  print(fromtime);

                  // showDate = true;
                  _fromController.text = fromtime.toString();
                },
                child: const Text('From Picker'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  var totime = await _selectTime(ctx);

                  // showDate = true;
                  _toController.text = totime.toString();
                },
                child: const Text('To Picker'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                // Save new item
                if (itemKey == null) {
                  db.createItem(
                    {
                      "task": _taskController.text,
                      "tag": _tagController.text,
                      "date": _dateController.text,
                      "from": _fromController.text,
                      "to": _toController.text,
                    },
                  );
                } else {
                  db.updateItem(
                    itemKey,
                    {
                      'task': _taskController.text.trim(),
                      'tag': _tagController.text.trim(),
                      'date': _dateController.text.trim(),
                      'from': _fromController.text.trim(),
                      'to': _toController.text.trim(),
                    },
                  );
                }
                refreshItems();

                // Clear the text fields
                _taskController.text = '';
                _tagController.text = '';
                _dateController.text = '';
                _fromController.text = '';
                _toController.text = '';

                Navigator.of(ctx).pop(); // Close the bottom sheet
              },
              child: Text(itemKey == null ? 'Create New' : 'Update'),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  void showForm2(BuildContext ctx, int? itemKey) async {
    // itemKey == null -> create new item
    // itemKey != null -> update an existing item

    if (itemKey != null) {
      final existingItem =
          items.firstWhere((element) => element['key'] == itemKey);
      _taskController.text = existingItem['task'];
      _tagController.text = existingItem['tag'];
      _taskController.text = existingItem['date'];
      _taskController.text = existingItem['from'];
      _taskController.text = existingItem['to'];
    }

    showModalBottomSheet(
      context: ctx,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            top: 15,
            left: 15,
            right: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _querytaskController,
              decoration: const InputDecoration(hintText: 'Query for task'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _querytagController,
              decoration: const InputDecoration(hintText: 'Query for tag'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _querydateController,
              decoration: const InputDecoration(hintText: 'Query for date'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                // Save new item
                if (_querytaskController.text.isNotEmpty) {
                  searchTask(_querytaskController.text);
                } else if (_querytagController.text.isNotEmpty) {
                  searchTag(_querytagController.text);
                } else if (_querydateController.text.isNotEmpty) {
                  searchDate(_querydateController.text);
                } else {
                  print("Nothing input");
                }

                //refreshItems();
                // Clear the text fields
                _querytaskController.text = '';
                _querytagController.text = '';
                _querydateController.text = '';

                Navigator.of(ctx).pop(); // Close the bottom sheet
              },
              child: Text(itemKey == null ? 'Search' : 'Update'),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
