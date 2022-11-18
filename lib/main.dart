import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hive_database/AddTask.dart';
import 'package:flutter_hive_database/widgets/EmptyState.dart';
import 'package:flutter_hive_database/widgets/MyCheckBox.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';

import 'Model/task.dart';

const taskBoxName = 'tasks';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<Task>(taskBoxName);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: primaryColor));
  runApp(const MyApp());
}

const Color primaryColor = Color(0xff794cff);
const Color primaryContainer = Color(0xff5c0aff);
const secondaryTextColor = Color(0xffafbed0);
const primaryTextColor = Color(0xff1d2830);

const highPriorityColor = primaryColor;
const normalPriorityColor = Color(0xfff09819);
const lowPriorityColor = Color(0xff3be1f1);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(const TextTheme(
              headline6: TextStyle(fontWeight: FontWeight.bold))),
          inputDecorationTheme: const InputDecorationTheme(
              labelStyle: TextStyle(color: secondaryTextColor),
              iconColor: secondaryTextColor,
              border: InputBorder.none),
          colorScheme: const ColorScheme.light(
              primary: primaryColor,
              primaryContainer: primaryContainer,
              background: Color(0xfff3f5f8),
              onSurface: primaryTextColor,
              onBackground: primaryTextColor,
              secondary: primaryColor,
              onSecondary: Colors.white)),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final TextEditingController txtSearch = TextEditingController();
  final ValueNotifier<String> searchKeywordNotifier = ValueNotifier("");

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Task>(taskBoxName);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(),
      ),
      body: Column(
        children: [
          header(context),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ValueListenableBuilder<String>(
                valueListenable: searchKeywordNotifier,
                builder: (context, value, child) {
                  return ValueListenableBuilder<Box<Task>>(
                    valueListenable: box.listenable(),
                    builder: (context, box, child) {
                      final List<Task> items;
                      if (txtSearch.text.isEmpty) {
                        items = box.values.toList();
                      } else {
                        items = box.values
                            .where((task) => task.name.contains(txtSearch.text))
                            .toList();
                      }
                      if (items.isNotEmpty) {
                        return ListView.builder(
                            itemCount: items.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: listViewHeader(context),
                                );
                              } else {
                                final Task task = items[index - 1];
                                return TaskItem(task: task);
                              }
                            });
                      } else {
                        return const EmptyState();
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTask(
                  task: Task(),
                ),
              ),
            );
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          label: Row(
            children: const [
              Text("New Task"),
              SizedBox(width: 10),
              Icon(CupertinoIcons.add_circled_solid)
            ],
          )),
    );
  }

  Widget header(BuildContext context) {
    final themeData = Theme.of(context);

    return Container(
      height: 110,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        themeData.colorScheme.primary,
        themeData.colorScheme.primaryContainer,
      ])),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "To Do List",
                  style: themeData.textTheme.headline6!
                      .apply(color: themeData.colorScheme.onPrimary),
                ),
                Icon(Icons.menu, color: themeData.colorScheme.onPrimary)
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 38,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: themeData.colorScheme.onPrimary,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1), blurRadius: 20)
                  ]),
              child: TextField(
                controller: txtSearch,
                onChanged: (value) {
                  searchKeywordNotifier.value = txtSearch.text;
                },
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    prefixIcon: Icon(CupertinoIcons.search),
                    hintText: 'Search tasks...'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget listViewHeader(BuildContext context) {
    final box = Hive.box<Task>(taskBoxName);
    final themeData = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today",
              style: themeData.textTheme.headline6!.apply(fontSizeFactor: 0.9),
            ),
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 60,
              height: 3,
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(1.5)),
            )
          ],
        ),
        MaterialButton(
          onPressed: () {
            box.clear();
          },
          color: const Color(0xffeaeff5),
          elevation: 0,
          textColor: secondaryTextColor,
          child: Row(
            children: const [
              Text("Delete All"),
              SizedBox(width: 4),
              Icon(
                CupertinoIcons.delete_solid,
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TaskItem extends StatefulWidget {
  const TaskItem({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    final Color priorityColor;
    switch (widget.task.priority) {
      case Priority.low:
        priorityColor = lowPriorityColor;
        break;
      case Priority.normal:
        priorityColor = normalPriorityColor;
        break;
      case Priority.high:
        priorityColor = highPriorityColor;
        break;
    }

    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddTask(task: widget.task),
        ));
      },
      onLongPress: () {
        widget.task.delete();
      },
      child: Container(
          margin: const EdgeInsets.all(4.0),
          padding: const EdgeInsets.only(left: 16),
          height: 75,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: themeData.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                    blurRadius: 20, color: Colors.black.withOpacity(0.06)),
              ]),
          child: Row(
            children: [
              MyCheckBox(
                value: widget.task.isCompleted,
                onTap: () {
                  setState(() {
                    widget.task.isCompleted = !widget.task.isCompleted;
                    widget.task.save();
                  });
                },
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.task.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 18,
                      decoration: widget.task.isCompleted
                          ? TextDecoration.lineThrough
                          : null),
                ),
              ),
              Container(
                width: 5,
                height: 80,
                decoration: BoxDecoration(
                    color: priorityColor,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8))),
              )
            ],
          )),
    );
  }
}
