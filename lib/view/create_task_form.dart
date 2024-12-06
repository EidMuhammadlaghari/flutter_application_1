import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/home_controller.dart';
import 'package:flutter_application_1/routes/route_names.dart';
import 'package:get/get.dart';

class CreateTaskView extends StatelessWidget {
  CreateTaskView({super.key});

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  Future<void> _selectTime(
      BuildContext context, HomeController controller) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: controller.selectedTime.value,
    );
    if (pickedTime != null) {
      controller.updateTime(pickedTime);
    }
  }

  Future<void> _selectDate(
      BuildContext context, HomeController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      controller.updateDate(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          color: Colors.blue,
          onPressed: () => Get.back(),
        ),
        middle: const Text("Create Task"),
        backgroundColor: Colors.white,
        border: Border.all(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            _buildTextField("Title", titleController),
            const SizedBox(height: 10),
            _buildTextField("Description", descriptionController),
            const SizedBox(height: 20),
            _buildDateAndTimeWidgets(context, controller),
            const SizedBox(height: 20),
            _buildPrioritySlider(controller),
            _buildPriorityLabels(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () {
          // Validate and create task
          if (controller.validateFields(
              titleController.text, descriptionController.text)) {
            controller.createTask(
                titleController.text, descriptionController.text);
            // Show snackbar for task creation success
            Get.snackbar(
              "Success",
              "Task for ${titleController.text} is created successfully at ${controller.selectedTime.value.format(context)}",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            // Navigate back to the home screen without reinitializing
            Get.offNamed(RouteNames.home);
          }
        },
        child: const Icon(CupertinoIcons.check_mark),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Center(
      child: SizedBox(
        width: Get.mediaQuery.size.width * 0.9,
        child: TextFormField(
          controller: controller,
          style: const TextStyle(color: Colors.black87, fontSize: 30),
          cursorColor: Colors.blue,
          cursorHeight: 30,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            labelText: label,
            labelStyle: const TextStyle(color: Colors.black87),
            border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            focusColor: Colors.blue,
          ),
        ),
      ),
    );
  }

  Widget _buildDateAndTimeWidgets(
      BuildContext context, HomeController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => _selectTime(context, controller),
            child: Obx(() => _buildDateOrTimeWidget(
                  controller.selectedTime.value.format(context),
                  Colors.blue,
                )),
          ),
          GestureDetector(
            onTap: () => _selectDate(context, controller),
            child: Obx(() => _buildDateOrTimeWidget(
                  "${controller.selectedDate.value.day}-${controller.selectedDate.value.month}-${controller.selectedDate.value.year}",
                  Colors.black87,
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildDateOrTimeWidget(String text, Color color) {
    return Container(
      width: 160,
      height: 100,
      decoration: const BoxDecoration(
        color: Color.fromARGB(113, 212, 212, 212),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildPrioritySlider(HomeController controller) {
    return Obx(() => Slider(
          min: 1,
          max: 3,
          divisions: 2,
          label: controller.priority.value == 1
              ? "Low Priority"
              : controller.priority.value == 2
                  ? "Normal Priority"
                  : "Very Important",
          value: controller.priority.value,
          onChanged: (value) => controller.updatePriority(value),
          thumbColor: Colors.blue,
          activeColor: const Color.fromARGB(255, 125, 196, 255),
        ));
  }

  Widget _buildPriorityLabels() {
    return SizedBox(
      width: Get.mediaQuery.size.width * 0.9,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Low Priority"),
          Text("Normal Priority"),
          Text("Very Important"),
        ],
      ),
    );
  }
}
