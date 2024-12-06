import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/controllers/home_controller.dart';
import 'package:flutter_application_1/routes/route_names.dart';
import 'package:flutter_application_1/view/CompletedTasksScreen.dart';
import 'package:get/get.dart';

class Homescreen extends GetWidget<HomeController> {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: const Text(
                  'Task Manager',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  controller.signOut();
                  Get.offNamed(RouteNames.login);
                },
              ),
              ListTile(
                leading: const Icon(Icons.check_circle),
                title: const Text('Completed Tasks'),
                onTap: () {
                  Get.to(() => CompletedTasksScreen());
                },
              ),
            ],
          ),
        ),
        appBar: CupertinoNavigationBar(
          leading: const DrawerButton(),
          middle: const Text("Task Track"),
          backgroundColor: Colors.white,
          border: Border.all(color: Colors.white),
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            // "Today" Section with Carousel View
            const Padding(
              padding:
                  EdgeInsets.only(left: 20.0, right: 20.0, top: 25, bottom: 10),
              child: Text(
                "Today",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Obx(() {
              if (controller.loading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (controller.todayTasks.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("No tasks scheduled for today."),
                  ),
                );
              }
              return ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 150),
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.9),
                  itemCount: controller.todayTasks.length,
                  itemBuilder: (context, index) {
                    final task = controller.todayTasks[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(169, 215, 237, 255),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and Checkbox
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  task.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Checkbox(
                                value: task.completed,
                                onChanged: (value) {
                                  if (value == true) {
                                    controller.markTaskAsComplete(task);
                                  }
                                },
                                activeColor: Colors.blue,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Task Description
                          Expanded(
                            child: Text(
                              task.description,
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 75, 75, 75),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Time and Date Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${task.dateTime.hour}:${task.dateTime.minute.toString().padLeft(2, '0')}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue,
                                ),
                              ),
                              Text(
                                "${task.dateTime.day}-${task.dateTime.month}-${task.dateTime.year}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),

            // "Upcoming Tasks" Section
            const Padding(
              padding:
                  EdgeInsets.only(left: 20.0, right: 20.0, top: 25, bottom: 10),
              child: Text(
                "Upcoming Tasks",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Obx(() {
              if (controller.loading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return controller.upcomingTasks.isEmpty
                  ? const Center(child: Text("No upcoming tasks"))
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.upcomingTasks.length,
                      itemBuilder: (context, index) {
                        final task = controller.upcomingTasks[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  offset: const Offset(2, 4),
                                ),
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  offset: const Offset(-2, 0),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    const Color.fromARGB(255, 0, 120, 219),
                                child: Text(
                                  task.title[0],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                task.title,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                "${task.description}\nDue: ${task.dateTime.day}-${task.dateTime.month}-${task.dateTime.year} at ${task.dateTime.hour}:${task.dateTime.minute.toString().padLeft(2, '0')}",
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.black54),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                    CupertinoIcons.ellipsis_vertical),
                                onPressed: () {
                                  _showTaskOptionsDialog(
                                      context, controller, task);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
            }),
          ],
        ),
        floatingActionButton: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: null,
              onPressed: () => Get.toNamed(
                  RouteNames.createTask), // Navigate to Task Creation page
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              heroTag: null,
              onPressed: () => Get.toNamed(RouteNames.createEmailTask),
              backgroundColor: Colors.blue,
              child: const Icon(Icons.email),
            ),
          ],
        ),
      );
    });
  }

  // Show dialog with options to delete or mark as complete
  void _showTaskOptionsDialog(
      BuildContext context, HomeController controller, Task task) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text("Task Options"),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              controller.deleteTask(task.id);
              Get.back(); // Close the action sheet
            },
            isDestructiveAction: true,
            child: const Text("Delete Task"),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              controller.markTaskAsComplete(task);
              Get.back(); // Close the action sheet
            },
            child: const Text("Mark as Complete"),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Get.back(), // Close the action sheet
          child: const Text("Cancel"),
        ),
      ),
    );
  }
}
