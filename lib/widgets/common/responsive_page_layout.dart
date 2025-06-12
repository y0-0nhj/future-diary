// lib/widgets/common/responsive_page_layout.dart
import 'package:flutter/material.dart';

class ResponsivePageLayout extends StatelessWidget {
  final Widget child; // MaterialApp.builder로부터 전달받는 네비게이터 위젯
  final Color? outerBackgroundColor; // 여백 부분에 적용될 배경색
  final Color? contentCardBackgroundColor; // 중앙 콘텐츠 카드 영역의 배경색

  const ResponsivePageLayout({
    Key? key,
    required this.child,
    this.outerBackgroundColor,
    this.contentCardBackgroundColor,
  }) : super(key: key);

  // 넓은 화면으로 간주할 기준 너비 (dp)
  static const double wideScreenBreakpoint = 450.0;
  // 넓은 화면에서 콘텐츠 카드가 가질 최대 너비 (dp)
  static const double maxContentWidth = 360.0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > wideScreenBreakpoint) {
      // 넓은 화면: 전체 앱 화면을 중앙에 카드 형태로 배치
      return Container(
        color: outerBackgroundColor ?? Theme.of(context).colorScheme.surfaceVariant, // 바깥 여백 배경색
        alignment: Alignment.topCenter,
        child: Container(
          width: maxContentWidth,
          // ClipRRect를 사용하여 자식 위젯(네비게이터)의 모서리를 둥글게 할 수도 있습니다 (선택 사항).
          // clipBehavior: Clip.antiAlias,
          // decoration: BoxDecoration(
          //   color: contentCardBackgroundColor, // 카드 배경색
          //   borderRadius: BorderRadius.circular(12), // 카드 모서리 둥글기
          //   boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)], // 카드 그림자
          // ),
          color: contentCardBackgroundColor, // 카드의 배경색을 명시적으로 지정
          child: child, // 이 child가 MaterialApp의 네비게이터 전체입니다.
        ),
      );
    } else {
      // 일반 스마트폰 화면: 전체 너비 사용 (별도의 카드 UI 없음)
      return child; // 네비게이터를 그대로 반환
    }
  }
}