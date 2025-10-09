import 'package:get/get.dart';

import '../../features/home/home_binding.dart';
import '../../features/home/views/home_view.dart';
import '../../features/submission/submission_binding.dart';
import '../../features/submission/views/submission_view.dart';
import 'app_routes.dart';

class AppPages {
  const AppPages._();

  static const initial = AppRoutes.home;

  static final routes = <GetPage<dynamic>>[
    GetPage<HomeView>(
      name: AppRoutes.home,
      page: HomeView.new,
      binding: HomeBinding(),
    ),
    GetPage<SubmissionView>(
      name: AppRoutes.submission,
      page: SubmissionView.new,
      binding: SubmissionBinding(),
      transition: Transition.cupertino,
    ),
  ];
}
