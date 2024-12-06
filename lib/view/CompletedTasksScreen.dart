import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/home_controller.dart';
import 'package:get/get.dart';

class CompletedTasksScreen extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Completed Tasks"),
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: controller.completedTasks.length,
          itemBuilder: (context, index) {
            final task = controller.completedTasks[index];
            return GestureDetector(
              onTap: () {
                _showTaskOptionsDialog(context, controller, task);
              },
              child: ListTile(
                title: Text(task.title),
                subtitle: Text(task.description),
                trailing: Text(
                  "${task.dateTime.day}-${task.dateTime.month}-${task.dateTime.year}",
                  style: TextStyle(fontSize: 12),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // Show dialog with options to delete or mark as complete
  void _showTaskOptionsDialog(
      BuildContext context, HomeController controller, Task task) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text("Task Options"),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              controller.deleteTask(task.id);
              Get.back(); // Close the action sheet
            },
            isDestructiveAction: true,
            child: Text("Delete Task"),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Get.back(), // Close the action sheet
          child: Text("Cancel"),
        ),
      ),
    );
  }
}
