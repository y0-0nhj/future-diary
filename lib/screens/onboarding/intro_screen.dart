import 'package:flutter/material.dart';
import 'package:future_diary/widgets/animation/animated_background.dart';
import 'package:flutter/services.dart';
import 'package:future_diary/widgets/common/common_modal.dart';
import 'package:future_diary/screens/onboarding/onboarding_screen.dart';
import 'package:go_router/go_router.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> with TickerProviderStateMixin {
  bool showCat = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.975, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  // 1. 첫 번째(소개) 화면의 콘텐츠 위젯
  Widget _buildIntroContent() {
    return LayoutBuilder(
      key: const ValueKey('introContent'),
      builder: (context, constraints) {
        return Stack(
          children: [
            const AnimatedBackground(),
            // 상단 텍스트
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 0, top: 0, bottom: 240),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '미래의 나에게 보내는,\n오늘의 약속.',
                  style: TextStyle(fontSize: 22, color: Colors.black87),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            // 타이틀
            Padding(
              padding: const EdgeInsets.only(left: 0, right: 40, top: 0, bottom: 300),
                child: Align(
                  alignment: Alignment.centerRight,
                child: Text(
                  '미래\n일기',
                  style: TextStyle(
                    fontSize: 65,
                    color: Colors.black87,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            // 램프+책 이미지
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 0, right: 0, top: 50, bottom: 0),
                child: Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/illustrations/intro/intro_lamp_book.png',
                    width: constraints.maxWidth * 0.9,
                    height: constraints.maxHeight * 0.9,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // 하단 설명
            Padding(
              padding: const EdgeInsets.only(left: 0, right: 0, top: 400, bottom: 0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                '가장 먼 미래는, 가장 소중한 지금으로 만들어집니다.\n마음 속 소망을 눈앞의 현실로 만들어드립니다.',
                style: TextStyle(fontSize: 20, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              ),
            ),
          ],
        );
      },
    );
  }

  // 2. 두 번째(고양이) 화면의 콘텐츠 위젯
  Widget _buildCatContent() {
    return LayoutBuilder(
      key: const ValueKey('catContent'),
      builder: (context, constraints) {
        // constraints.maxWidth, constraints.maxHeight를 활용해 비율 조정 가능
        return Stack(
          children: [
            // 말풍선
            Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 200),
                    child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/illustrations/intro/talk1.png',
                      width: constraints.maxWidth * 0.9, // 화면 너비의 90%
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                ),
                // 문구
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 220),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '방문이\n처음이신가요?',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                      fontSize: 33, // 필요시 constraints.maxWidth에 따라 동적으로 조정 가능
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                  ),),
                              // 고양이+책
            Padding(
              padding: const EdgeInsets.only(left: 0, right: 0, top: 120, bottom: 0),
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                      'assets/illustrations/intro/cat_on_book.png',
                      width: constraints.maxWidth * 0.8, // 화면 너비의 80%
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // 3. '시작하기' 버튼 위젯
  Widget _buildStartButton() {
    return Padding(
      key: const ValueKey('startButton'), // AnimatedSwitcher를 위한 Key
      padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 32.0),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () => setState(() => showCat = true),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF778557),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          child: const Text(
            '시작하기',
            style: TextStyle(
                fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // 4. '예/아니오' 버튼 위젯
  Widget _buildYesNoButtons() {
    return Padding(
      key: const ValueKey('yesNoButtons'), // AnimatedSwitcher를 위한 Key
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () { /* 아니오오 버튼 동작 */ },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBFC3C7),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                padding: const EdgeInsets.symmetric(vertical: 14)
              ),
              child: const Text('아니오', style: TextStyle(fontSize: 22, color: Colors.white)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () { context.push('/onboarding'); },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF778557),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                padding: const EdgeInsets.symmetric(vertical: 14)
              ),
              child: const Text('예', style: TextStyle(fontSize: 22, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        if (showCat) {
          // 고양이 화면이면 소개 화면으로 전환
          setState(() {
            showCat = false;
          });
        } else {
          // 소개 화면이면 앱 종료 다이얼로그 표시
          showCommonModal(
            context: context,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '앱을 종료하시겠습니까?',
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 108,
                      height: 40,
                      child: ElevatedButton(
                      onPressed: () => SystemNavigator.pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBFC3C7),
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      '예',
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                  ),),
                    const SizedBox(width: 15),
                    SizedBox(
                      width: 108,
                      height: 40,
                      child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  const Color(0xFF778557),
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      '아니오',
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                  ),
                ),],
                ),
              ],
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 450,
                    alignment: Alignment.center,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: showCat ? _buildCatContent() : _buildIntroContent(),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: showCat ? _buildYesNoButtons() : _buildStartButton(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}