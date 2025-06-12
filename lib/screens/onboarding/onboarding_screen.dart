import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  
  int _currentPage = 0;

  // 입력값 상태
  String occupation = '';
  int workHours = 5;
  List<bool> workDays = List.filled(7, false); // 월~일
  String budget = '';
  String projectTitle = '';
  String projectDetail = '';
  String diaryTitle = '';
  String diaryContent = '';

  // 상태 변수 추가
  String? selectedCategory;
  String detailInput = '';

  // 폰트, 색상, 스타일
  final Color olive = const Color(0xFF778557);
  // 요일 텍스트
  final List<String> weekDays = ['월', '화', '수', '목', '금', '토', '일'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/backgrounds/background1.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: child,
              ),
              child: _buildPage(_currentPage),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int idx) {
    switch (idx) {
      case 0: return _buildQ1();
      case 1: return _buildQ2();
      case 2: return _buildQ3();
      case 3: return _buildQ4();
      case 4: return _buildQ5();
      case 5: return _buildQ6();
      default: return Container();
    }
  }

  // Q1: 직업
  Widget _buildQ1() {
    // 1단계 카테고리 목록
    final categories = [
      '학생',
      '직장인',
      '취업 준비생',
      '프리랜서 / 사업가',
      '기타',
    ];

    // 2단계 질문 맵
    final detailQuestions = {
      '학생': '어떤 분야를 전공하고 계신가요?',
      '직장인': '어떤 직무를 맡고 계신가요? (예: 개발자, 기획자)',
      '취업 준비생': '어떤 분야로 취업을 준비 중이신가요?',
      '프리랜서 / 사업가': '어떤 업종/분야에서 활동 중이신가요?',
      '기타': '현재 상황을 간단히 적어주세요.',
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Text('Q1', style: TextStyle(fontSize: 60)),
          Text('현재 상황을 가장 잘 나타내는 것을 선택해주세요.', style: TextStyle(fontSize: 30)),
          const SizedBox(height: 10),
          // 2단계: 선택에 따라 주관식 입력
          if (selectedCategory != null) ...[
            const SizedBox(height: 10),
            Text(
              detailQuestions[selectedCategory]!,
              style: TextStyle(fontSize: 20, color: Colors.grey[700]),
            ),
            TextField(
              maxLength: 20,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: '입력',
                counterText: '',
              ),
              style: TextStyle(fontSize: 20),
              onChanged: (v) => setState(() => detailInput = v),
            ),
            const SizedBox(height: 30),
          ],
          // 1단계: 객관식 라디오 버튼
          ...categories.map((cat) => RadioListTile<String>(
                value: cat,
                groupValue: selectedCategory,
                title: Text(cat, style: TextStyle(fontSize: 22)),
                activeColor: olive,
                contentPadding: EdgeInsets.zero,
                dense: true,
                visualDensity: VisualDensity.compact,
                onChanged: (v) => setState(() {
                  selectedCategory = v;
                  detailInput = '';
                }),
              )),
          const Spacer(),
          Center(
            child: _buildButton(
              '확인',
              (selectedCategory != null && detailInput.trim().isNotEmpty)
                  ? () {
                      _nextPage();
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  // Q2: 하루 작업 시간
  Widget _buildQ2() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBackArrow(),
          const SizedBox(height: 8),
          Text('Q2', style: TextStyle(fontSize: 60)),
          Text('하루동안 작업할 수 있는 시간은 얼마나 되나요?', style: TextStyle(fontSize: 30)),
          const SizedBox(height: 10),
          Row(
            children: [
              Text('약', style: TextStyle(fontSize: 24,color: Colors.grey[700])),
              const SizedBox(width: 8),
              Expanded(
                child: Slider(
                  value: workHours.toDouble(),
                  min: 1,
                  max: 24,
                  divisions: 23,
                  label: '$workHours',
                  onChanged: (v) => setState(() => workHours = v.round()),
                  activeColor: olive,
                  inactiveColor: olive.withOpacity(0.3),
                ),
              ),
              const SizedBox(width: 8),
              Text('${workHours}시간', style: TextStyle(fontSize: 24,  color: Colors.grey[700])),
            ],
          ),
          const SizedBox(height: 10),
          _buildSummaryLine('직업', occupation),
          const Spacer(),
          Center(
            child: _buildButton('확인', _nextPage),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // Q3: 작업 가능 요일
  Widget _buildQ3() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBackArrow(),
          const SizedBox(height: 8),
          Text('Q3', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 10),
          Text('일주일동안 작업할 수 있는 요일을 모두 선택해주세요.', style: TextStyle(fontSize: 22)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(7, (i) {
              final selected = workDays[i];
              return GestureDetector(
                onTap: () => setState(() => workDays[i] = !workDays[i]),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: selected ? olive : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    weekDays[i],
                    style: TextStyle(
                      fontSize: 20,
                      color: selected ? Colors.white : Colors.grey[700],
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          _buildSummaryLine('작업가능시간', '약 $workHours 시간'),
          _buildSummaryLine('직업', occupation),
          const Spacer(),
          Center(
            child: _buildButton('확인', _nextPage),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // Q4: 예산
  Widget _buildQ4() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBackArrow(),
          const SizedBox(height: 8),
          Text('Q4', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 10),
          Text('월에 투자할 수 있는 예산은 얼마인가요?', style: TextStyle(fontSize: 30)),
          const SizedBox(height: 10),
          TextField(
            style: TextStyle(fontSize: 24),
            decoration: const InputDecoration(
              hintText: '선택',
              border: UnderlineInputBorder(),
            ),
            onChanged: (v) => setState(() => budget = v),
          ),
          const SizedBox(height: 10),
          _buildSummaryLine('작업가능요일', _selectedDaysText()),
          _buildSummaryLine('작업가능시간', '약 $workHours 시간'),
          _buildSummaryLine('직업', occupation),
          const Spacer(),
          Center(
            child: _buildButton('완료', _nextPage),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // Q5: 가용 예산 + 요약
  Widget _buildQ5() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBackArrow(),
          const SizedBox(height: 8),
          Center(
            child: Image.asset('assets/images/teapot.png', height: 120),
          ),
          const SizedBox(height: 16),
          _buildSummaryLine('가용 예산', budget),
          _buildSummaryLine('작업가능요일', _selectedDaysText()),
          _buildSummaryLine('작업가능시간', '약 $workHours 시간'),
          _buildSummaryLine('직업', occupation),
          const Spacer(),
          Center(
            child: _buildButton('완료', _nextPage),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // Q6: 관심사 및 과업
  Widget _buildQ6() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBackArrow(),
          const SizedBox(height: 8),
          Center(
            child: Image.asset('assets/images/laptop.png', height: 100),
          ),
          const SizedBox(height: 16),
          Text(
            '관심사 및 진행 중인 과업,\n앞으로 해야할 것들을 적어주세요.',
            style: TextStyle(fontSize: 22, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildProjectInput(),
          const Spacer(),
          Center(
            child: _buildButton('완료', () {
              // TODO: 제출 처리
            }),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // --- 공통 위젯들 ---

  Widget _buildBackArrow() {
    return IconButton(
      icon: Image.asset('assets/icons/arrow_left1.png', width: 50, height: 50),
      onPressed: _prevPage,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }

  Widget _buildButton(String text, VoidCallback? onTap) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: olive,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSummaryLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          const SizedBox(width: 12),
          Text(value, style: TextStyle(fontSize: 30, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildProjectInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('제목', style: TextStyle(fontSize: 16)),
        TextField(
          style: TextStyle(fontSize: 20),
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
          ),
          onChanged: (v) => setState(() => projectTitle = v),
        ),
        const SizedBox(height: 16),
        Text('세부 내용', style: TextStyle(fontSize: 16)),
        TextField(
          style: TextStyle(fontSize: 18),
          maxLines: 5,
          maxLength: 1000,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            counterText: '',
          ),
          onChanged: (v) => setState(() => projectDetail = v),
        ),
      ],
    );
  }

  // --- 페이지 이동 ---
  void _nextPage() {
    if (_currentPage < 5) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
  }

  String _selectedDaysText() {
    final selected = <String>[];
    for (int i = 0; i < 7; i++) {
      if (workDays[i]) selected.add(weekDays[i]);
    }
    return selected.join(', ');
  }
}