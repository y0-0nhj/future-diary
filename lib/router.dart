import 'package:go_router/go_router.dart';
import 'package:future_diary/screens/onboarding_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => OnboardingScreen()),
  ],
);
