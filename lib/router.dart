import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:future_diary/screens/onboarding/intro_screen.dart';
import 'package:future_diary/screens/onboarding/onboarding_screen.dart';

// TODO: 나중에 추가할 메인 화면을 import 하세요.
// import 'package:future_diary/screens/home_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  // 1. 시작 경로는 루트('/')로 통일해서 명확하게 만듭니다.
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      // 2. 루트 경로에 진입했을 때 어떤 화면을 보여줄지 여기서 결정합니다.
      // 지금은 온보딩 화면을 보여주지만, 나중에는 로그인 여부에 따라 다른 화면을 보여줄 수도 있겠죠.
      builder: (context, state) => IntroScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) => buildFadeTransitionPage(
        key: state.pageKey,
        child: OnboardingScreen(),
      ),
    ),
    
    // 3. 온보딩 이후에 넘어갈 메인 화면 경로를 미리 추가해 둡니다.
    // GoRoute(
    //   path: '/home',
    //   builder: (context, state) => HomeScreen(),
    // ),
  ],
);


// 페이지 전환 애니메이션 추가
CustomTransitionPage<T> buildFadeTransitionPage<T>({
  required Widget child,
  required LocalKey key,
  Duration duration = const Duration(milliseconds: 500),
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
