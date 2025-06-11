import 'package:flutter/material.dart';
import 'package:future_diary/widgets/animation/animated_background.dart';
import 'package:flutter/services.dart';

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

    _scaleAnimation = Tween<double>(begin: 0.98, end: 1.0).animate(
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
    return Stack(
      key: const ValueKey('introContent'), // AnimatedSwitcher를 위한 Key
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
          child: Image.asset(
            'assets/illustrations/intro/intro_lamp_book.png',
            width: 380,
            fit: BoxFit.contain,
          ),
        ),
        const Positioned(
          top: 25,
          left: 30,
          right: 0,
          child: Text(
            '미래의 나에게 보내는,\n오늘의 약속.',
            style: TextStyle(fontSize: 22, color: Colors.black87),
            textAlign: TextAlign.left,
          ),
        ),
        const Positioned(
          top: -5,
          left: 220,
          right: 0,
          child: Text(
            '미래\n일기',
            style: TextStyle(
              fontSize: 65,
              color: Colors.black87,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const Positioned(
          top: 333,
          left: 0,
          right: 0,
          child: Text(
            '가장 먼 미래는, 가장 소중한 지금으로 만들어집니다.\n마음 속 소망을 눈앞의 현실로 만들어드립니다.',
            style: TextStyle(fontSize: 21, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  // 2. 두 번째(고양이) 화면의 콘텐츠 위젯
  Widget _buildCatContent() {
    return SizedBox(
      width: 320, // 말풍선+고양이 전체가 들어갈 만큼 넉넉하게
      height: 450,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 말풍선
          Positioned(
            bottom: 210,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/illustrations/intro/talk1.png',
              width: 300,
              height: 280,
              fit: BoxFit.contain,
            ),
          ),
          // 고양이+책
          Positioned(
            top: 70,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/illustrations/intro/cat_on_book.png',
              width: 400,
              height: 400,
              fit: BoxFit.contain,
            ),
          ),
          // 말풍선 위 텍스트
          Positioned(
            top: 50, // 말풍선 내부에 적절히 위치
            left: 0,
            right: 0,
            child: Text(
              '방문이\n처음이신가요?',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
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
              onPressed: () { /* 예 버튼 동작 */ },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF778557),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                padding: const EdgeInsets.symmetric(vertical: 14)
              ),
              child: const Text('예', style: TextStyle(fontSize: 22, color: Colors.white)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () { /* 아니오 버튼 동작 */ },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBFC3C7),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                padding: const EdgeInsets.symmetric(vertical: 14)
              ),
              child: const Text('아니오', style: TextStyle(fontSize: 22, color: Colors.white)),
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
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('👋 앱 종료'),
              content: const Text('정말로 미래일기를 종료하시겠어요?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('아니요'),
                ),
                TextButton(
                  onPressed: () => SystemNavigator.pop(),
                  child: const Text('예'),
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
            const AnimatedBackground(),
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