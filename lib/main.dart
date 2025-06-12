import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:future_diary/router.dart'; // router와 rootNavigatorKey를 가져옵니다.
import 'package:future_diary/widgets/common/responsive_page_layout.dart';
import 'package:go_router/go_router.dart';
import 'package:future_diary/screens/onboarding/intro_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. MaterialApp.router가 가장 바깥에 오도록 합니다.
    return MaterialApp.router(
      routerConfig: router,
      title: 'Future Diary',
      theme: ThemeData(
        fontFamily: 'OnePrettyNight',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF778557)),
        scaffoldBackgroundColor: Colors.transparent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      // 2. builder 안에서 모든 것을 감싸줍니다.
      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/backgrounds/background1.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: PopScope(
            canPop: false,
            onPopInvoked: (bool didPop) {
              if (didPop) return;
              if (router.canPop()) {
                router.pop();
              } else {
                print("======== 뒤로가기 감지! 팝업을 띄워야 함! ========");
              }
            },
            child: ResponsivePageLayout(
              outerBackgroundColor: Colors.grey[200],
              contentCardBackgroundColor: Colors.transparent,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/backgrounds/background1.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  top: true,
                  bottom: true,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                    layoutBuilder: (currentChild, previousChildren) {
                      return currentChild ?? const SizedBox.shrink();
                    },
                    child: child ?? const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}