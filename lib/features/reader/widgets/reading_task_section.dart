import 'package:flutter/material.dart';

class ReadingTaskSection extends StatefulWidget {
  const ReadingTaskSection({super.key});

  @override
  State<ReadingTaskSection> createState() => _ReadingTaskSectionState();
}

class _ReadingTaskSectionState extends State<ReadingTaskSection> {
  final List<Map<String, dynamic>> tasks = [
    {
      "title": "Read 20 pages",
      "subtitle": "Complete 20 pages today",
      "completed": false,
      "points": 10,
    },
    {
      "title": "Read for 30 minutes",
      "subtitle": "Spend 30 minutes reading",
      "completed": true,
      "points": 15,
    },
    {
      "title": "Finish one chapter",
      "subtitle": "Complete at least 1 chapter",
      "completed": false,
      "points": 20,
    },
  ];

  int get completedTasks =>
      tasks.where((task) => task["completed"] == true).length;

  double get progress =>
      tasks.isEmpty ? 0 : completedTasks / tasks.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reading Tasks"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 📊 Progress Section
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      "Today's Progress",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "$completedTasks / ${tasks.length} tasks completed",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 📚 Task List
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: Icon(
                        task["completed"]
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: task["completed"]
                            ? Colors.green
                            : Colors.grey,
                      ),
                      title: Text(
                        task["title"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: task["completed"]
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      subtitle: Text(task["subtitle"]),
                      trailing: Text(
                        "+${task["points"]} pts",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          task["completed"] = !task["completed"];
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      /// ➕ Add Task Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            tasks.add({
              "title": "New Reading Task",
              "subtitle": "Custom task",
              "completed": false,
              "points": 5,
            });
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}