import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hive_database/main.dart';
import 'package:flutter_hive_database/widgets/PrioritySelectorCheckBox.dart';
import 'package:hive_flutter/adapters.dart';

import 'Model/task.dart';

class AddTask extends StatefulWidget {
  final Task task;

  AddTask({Key? key, required this.task}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  late final TextEditingController txtItem = TextEditingController(text: widget.task.name);



  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: themeData.colorScheme.surface,
        foregroundColor: themeData.colorScheme.onSurface,
        elevation: 0,
        title: Text("Add Task"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            priorities(),
            TextField(
              controller: txtItem,
              decoration: InputDecoration(hintText: "Add a Task for Today...",hintStyle: Theme.of(context).textTheme.bodyText1!.apply(fontSizeFactor: 1.4)),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            widget.task.name = txtItem.text;
            widget.task.priority = widget.task.priority;
            if (widget.task.isInBox) {
              widget.task.save();
            } else {
              final Box<Task> box = Hive.box(taskBoxName);
              box.add(widget.task);
            }
            Navigator.pop(context);
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          label: Row(
            children: const [
              Text("Save Changes"),
              SizedBox(width: 6),
              Icon(
                CupertinoIcons.checkmark_alt,
                size: 18,
              ),
            ],
          )),
    );
  }

  Widget priorities() {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Flexible(
            flex: 1,
            child: PeriorityCheckBox(
              onTap: () {
                setState(() {
                  widget.task.priority = Priority.high;
                });
              },
              label: "High",
              color: highPriorityColor,
              isSelected: widget.task.priority == Priority.high,
            )),
        SizedBox(width: 8),
        Flexible(
            flex: 1,
            child: PeriorityCheckBox(
              onTap: () {
                setState(() {
                  widget.task.priority = Priority.normal;
                });
              },
              label: "Normal",
              color: normalPriorityColor,
              isSelected: widget.task.priority == Priority.normal,
            )),
        const SizedBox(width: 8),
        Flexible(
            flex: 1,
            child: PeriorityCheckBox(
              onTap: () {
                setState(() {
                  widget.task.priority = Priority.low;
                });
              },
              label: "Low",
              color: lowPriorityColor,
              isSelected: widget.task.priority == Priority.low,
            )),
      ],
    );
  }
}
