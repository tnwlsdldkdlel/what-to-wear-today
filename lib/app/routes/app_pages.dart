import 'package:get/get.dart';

import '../../features/home/home_binding.dart';
import '../../features/home/views/home_view.dart';
import '../../features/submission/submission_binding.dart';
import '../../features/submission/views/submission_steps.dart';
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
    GetPage<SubmissionTopStepView>(
      name: AppRoutes.submissionTop,
      page: SubmissionTopStepView.new,
      binding: SubmissionBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<SubmissionBottomStepView>(
      name: AppRoutes.submissionBottom,
      page: SubmissionBottomStepView.new,
      binding: SubmissionBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<SubmissionOuterStepView>(
      name: AppRoutes.submissionOuter,
      page: SubmissionOuterStepView.new,
      binding: SubmissionBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<SubmissionShoesStepView>(
      name: AppRoutes.submissionShoes,
      page: SubmissionShoesStepView.new,
      binding: SubmissionBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<SubmissionAccessoriesStepView>(
      name: AppRoutes.submissionAccessories,
      page: SubmissionAccessoriesStepView.new,
      binding: SubmissionBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<SubmissionReviewStepView>(
      name: AppRoutes.submissionReview,
      page: SubmissionReviewStepView.new,
      binding: SubmissionBinding(),
      transition: Transition.cupertino,
    ),
  ];
}
