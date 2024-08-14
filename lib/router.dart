import 'package:go_router/go_router.dart';
import 'package:todolist/model/task.dart';
import 'package:todolist/pages/home_page.dart';
import 'package:todolist/pages/task_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/taskpage',
      builder: (context, state) {
        final task = state.extra as Task?;
        return TaskPage(task: task);
      },
    ),
  ],
);
