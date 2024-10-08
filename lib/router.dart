import 'package:go_router/go_router.dart';
import 'package:todolist/model/task.dart';
import 'package:todolist/pages/home/home_page.dart';
import 'package:todolist/pages/task/task_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (final context, final state) => const HomePage(),
    ),
    GoRoute(
      path: '/taskpage',
      builder: (final context, final state) {
        final task = state.extra as Task?;
        return TaskPage(task: task);
      },
    ),
  ],
);
