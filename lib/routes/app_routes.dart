import 'package:flutter/material.dart';
import '../presentation/railway_exam_catalog/railway_exam_catalog.dart';
import '../presentation/dashboard/dashboard.dart';
import '../presentation/ssc_exam_catalog/ssc_exam_catalog.dart';
import '../presentation/revision_module/revision_module.dart';
import '../presentation/ai_doubt_solve/ai_doubt_solve.dart';
import '../presentation/test_interface/test_interface.dart';
import '../presentation/profile_management/profile_management.dart';
import '../presentation/test_results/test_results.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String railwayExamCatalog = '/railway-exam-catalog';
  static const String dashboard = '/dashboard';
  static const String sscExamCatalog = '/ssc-exam-catalog';
  static const String revisionModule = '/revision-module';
  static const String aiDoubtSolve = '/ai-doubt-solve';
  static const String testInterface = '/test-interface';
  static const String profileManagement = '/profile-management';
  static const String testResults = '/test-results';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const RailwayExamCatalog(),
    railwayExamCatalog: (context) => const RailwayExamCatalog(),
    dashboard: (context) => const Dashboard(),
    sscExamCatalog: (context) => const SscExamCatalog(),
    revisionModule: (context) => const RevisionModule(),
    aiDoubtSolve: (context) => const AiDoubtSolve(),
    testInterface: (context) => const TestInterface(),
    profileManagement: (context) => const ProfileManagement(),
    testResults: (context) => const TestResults(),
    // TODO: Add your other routes here
  };
}
