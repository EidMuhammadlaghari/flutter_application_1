import 'package:flutter_application_1/controllers/home_controller.dart';
import 'package:flutter_application_1/routes/route_names.dart';
import 'package:flutter_application_1/view/CompletedTasksScreen.dart';
import 'package:flutter_application_1/view/create_email_form.dart';
import 'package:flutter_application_1/view/create_task_form.dart';
import 'package:flutter_application_1/view/homescreen.dart';
import 'package:flutter_application_1/view/login_view.dart';
import 'package:flutter_application_1/view/reset_password_view.dart';
import 'package:flutter_application_1/view/signup_view.dart';
import 'package:get/get.dart';

class AppPages {
  AppPages._();

  static const initial = RouteNames.login;

  static final routes = [
    GetPage(
      name: RouteNames.home,
      page: () => const Homescreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => HomeController());
      }),
    ),
    GetPage(
      name: RouteNames.login,
      page: () => LoginView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteNames.signup,
      page: () => SignupView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteNames.resetPassword,
      page: () => const ResetPasswordView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteNames.createTask,
      page: () => CreateTaskView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteNames.createEmailTask,
      page: () => EmailTaskCreationView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteNames.completedTasks, // Register route for completed tasks
      page: () => CompletedTasksScreen(), // Completed tasks screen
      transition: Transition.cupertino,
    ),
  ];
}
