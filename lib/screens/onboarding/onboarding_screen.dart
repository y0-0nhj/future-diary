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
  String? budget;
  String? selectedBudget;
  final _budgetController = TextEditingController();
  final _projectTitleController = TextEditingController();
  final _projectDetailController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
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

  @override
  void dispose() {
    _budgetController.dispose();
    _projectTitleController.dispose();
    _projectDetailController.dispose();
    super.dispose();
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
    // ... (categories, detailQuestions 변수는 그대로) ...
    final categories = ['학생', '직장인', '취업 준비생', '프리랜서/사업가', '기타'];
    final detailQuestions = {
      '학생': '어떤 분야를 전공하고 계신가요?',
      '직장인': '어떤 직무를 맡고 계신가요? (예: 개발자, 기획자)',
      '취업 준비생': '어떤 분야로 취업을 준비 중이신가요?',
      '프리랜서/사업가': '어떤 업종/분야에서 활동 중이신가요?',
      '기타': '현재 상황을 간단히 적어주세요.',
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      // 1. 기존 Column 구조를 유지합니다.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 2. 스크롤이 필요한 모든 콘텐츠를 Expanded와 SingleChildScrollView로 감쌉니다.
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  const Text('Q1', style: TextStyle(fontSize: 60)),
                  const Text('현재 상황을 가장 잘 나타내는 것을 선택해주세요.', style: TextStyle(fontSize: 30)),
                  const SizedBox(height: 10),
                  // 2단계: 선택에 따라 주관식 입력
                  if (selectedCategory != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      detailQuestions[selectedCategory]!,
                      style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                    ),
                    TextField(
                      maxLength: 12,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: '입력',
                        counterText: '${detailInput.length}/12',
                      ),
                      style: const TextStyle(fontSize: 20),
                      onChanged: (v) => setState(() => detailInput = v),
                    ),
                    const SizedBox(height: 30),
                  ],
                  // 1단계: 객관식 라디오 버튼
                  ...categories.map((cat) => RadioListTile<String>(
                        value: cat,
                        groupValue: selectedCategory,
                        title: Text(cat, style: const TextStyle(fontSize: 22)),
                        activeColor: olive,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        onChanged: (v) => setState(() {
                          selectedCategory = v;
                          detailInput = '';
                        }),
                      )),
                ],
              ),
            ),
          ),
          // 3. Spacer를 제거하고, 버튼을 Column의 마지막 자식으로 배치합니다.
          // 이렇게 하면 버튼은 스크롤 영역 밖에 고정됩니다.
          const SizedBox(height: 16), // 버튼과 콘텐츠 사이의 간격
          Center(
            child: _buildButton(
              '확인',
              (selectedCategory != null && detailInput.trim().isNotEmpty)
                  ? () {
                      // Q1 답변 저장 로직 추가
                      occupation = '$selectedCategory - $detailInput';
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
    // 1. 화면 전체를 두 영역(콘텐츠, 버튼)으로 나눌 메인 Column
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 2. 스크롤이 필요한 모든 콘텐츠를 담을 부분
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBackArrow(),
                const SizedBox(height: 8),
                const Text('Q2', style: TextStyle(fontSize: 60)),
                const Text('하루동안 작업할 수 있는 시간은 얼마나 되나요?', style: TextStyle(fontSize: 30)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text('약', style: TextStyle(fontSize: 24, color: Colors.grey[700])),
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
                    Text('${workHours}시간', style: TextStyle(fontSize: 24, color: Colors.grey[700])),
                  ],
                ),
                const SizedBox(height: 10),
                _buildSummaryLine('직업', occupation),
              ],
            ),
          ),
        ),
        
        // 3. 스크롤 영역 밖에 버튼을 두어 하단에 고정
        const SizedBox(height: 16), // 콘텐츠와 버튼 사이 간격
        Center(
          child: _buildButton('확인', _nextPage),
        ),
      ],
    ),
  );
}
// Q3: 작업 가능 요일
Widget _buildQ3() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
    // 1. 메인 Column으로 스크롤 영역과 버튼 영역을 나눕니다.
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 2. 스크롤될 콘텐츠 전체를 Expanded > SingleChildScrollView로 감쌉니다.
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBackArrow(),
                const SizedBox(height: 8),
                const Text('Q3', style: TextStyle(fontSize: 60)),
                const SizedBox(height: 10),
                const Text('일주일동안 작업할 수 있는 요일을 모두 선택해주세요.', style: TextStyle(fontSize: 30)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬로 보기 좋게 수정
                  children: List.generate(7, (i) {
                    final selected = workDays[i];
                    return GestureDetector(
                      onTap: () => setState(() => workDays[i] = !workDays[i]),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2.5), // 간격 살짝 조정
                        width: 35, // 크기 살짝 키움
                        height: 35,
                        decoration: BoxDecoration(
                          color: selected ? olive : Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          weekDays[i],
                          style: TextStyle(
                            fontSize: 27,
                            color: selected ? Colors.white : Colors.grey[700],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 32), // 간격 조정
                _buildSummaryLine('작업가능시간', '약 $workHours시간'),
                _buildSummaryLine('직업', occupation),
              ],
            ),
          ),
        ),

        // 3. Spacer를 제거하고 버튼을 Column의 마지막 자식으로 두어 하단에 고정합니다.
        const SizedBox(height: 16),
        Center(
          // 버튼 활성화 조건을 추가 (하나 이상의 요일이 선택되었을 때)
          child: _buildButton(
            '확인',
            workDays.contains(true) ? _nextPage : null,
          ),
        ),
      ],
    ),
  );
}

// Q4: 예산
Widget _buildQ4() {
  final budgetOptions = [
    '5만원 미만',
    '5만원 ~ 10만원',
    '10만원 ~ 20만원',
    '20만원 ~ 50만원',
    '50만원 이상',
    '직접 입력',
  ];

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
    // 1. 메인 Column으로 스크롤 영역과 버튼 영역을 나눕니다.
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 2. 스크롤될 콘텐츠를 Expanded > SingleChildScrollView 안에 배치합니다.
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBackArrow(),
                const SizedBox(height: 8),
                const Text('Q4', style: TextStyle(fontSize: 60)),
                const SizedBox(height: 10),
                const Text('월에 투자할 수 있는 예산은 얼마인가요?', style: TextStyle(fontSize: 30)),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey.shade400, width: 1),
                  ),
                  child: DropdownButton<String>(
                    value: selectedBudget,
                    hint: const Text('예산을 선택해주세요', style: TextStyle(fontSize: 20)),
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    style: const TextStyle(fontSize: 20, color: Colors.black87),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedBudget = newValue;
                        // 직접 입력이 아닌 다른 것을 선택했을 때, 입력창 내용 초기화
                        if (newValue != '직접 입력') {
                          _budgetController.clear();
                        }
                      });
                    },
                    items: budgetOptions.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                if (selectedBudget == '직접 입력')
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: _budgetController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        hintText: '금액을 직접 입력하세요',
                        prefixText: '약 ',
                        suffixText: ' 만원',
                        border: UnderlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                const SizedBox(height: 32), // 간격 조정
                _buildSummaryLine('작업가능요일', _selectedDaysText()),
                _buildSummaryLine('작업가능시간', '약 $workHours 시간'),
                _buildSummaryLine('직업', occupation),
              ],
            ),
          ),
        ),
        
        // 3. 버튼을 스크롤 영역 밖으로 빼서 하단에 고정합니다.
        const SizedBox(height: 16),
        Center(
          child: _buildButton('확인',
            (selectedBudget != null && selectedBudget != '직접 입력') ||
            (selectedBudget == '직접 입력' && _budgetController.text.trim().isNotEmpty)
              ? () {
                  if (selectedBudget == '직접 입력') {
                    budget = _budgetController.text + "만원"; // 단위 추가
                  } else {
                    budget = selectedBudget!;
                  }
                  _nextPage();
                }
              : null,
          ),
        ),
      ],
    ),
  );
}


  // Q5: 관심사 및 과업
  Widget _buildQ5() {
    String finalBudget = '';
    if (selectedBudget == '직접 입력') {
      finalBudget = '약 ${_budgetController.text}만원';
    } else {
      finalBudget = selectedBudget ?? '선택 안 함';
    }
return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
    child: Column(
      children: [
        // 스크롤 영역
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBackArrow(),
                Center(
                  child: Image.asset('assets/images/laptop.png', height: 100),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    '관심사 및 진행 중인 과업,\n앞으로 해야할 것들을 적어주세요.',
                    style: TextStyle(fontSize: 22, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                // 상세 UI를 별도 함수로 분리하여 호출
                _buildProjectInput(),
                _buildSummaryLine('가용 예산', finalBudget),
                _buildSummaryLine('작업가능요일', _selectedDaysText()),
                _buildSummaryLine('작업가능시간', '약 $workHours 시간'),
                _buildSummaryLine('직업', occupation),
              ],
              
            ),
          ),
          
        ),

        // 하단 고정 버튼
        const SizedBox(height: 16),
        Center(
          child: _buildButton('완료', 
            _projectTitleController.text.trim().isNotEmpty &&
            _projectDetailController.text.trim().isNotEmpty
            ? () {
              // 최종 온보딩 완료 처리
            } : null
          ),
        ),
      ],
    ),
  );
}



// Q6: 요약
Widget _buildQ6() {
  // `budget`이 null일 경우를 대비하여 `selectedBudget`으로 표시,
  // 혹은 최종 저장된 budget 변수를 사용합니다.
  String finalBudget = '';
  if (selectedBudget == '직접 입력') {
    finalBudget = '약 ${_budgetController.text}만원';
  } else {
    finalBudget = selectedBudget ?? '선택 안 함';
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 스크롤 영역
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBackArrow(),
                const SizedBox(height: 8),
                Center(
                  child: Image.asset('assets/images/teapot.png', height: 120),
                ),
                const SizedBox(height: 32), // 간격 조정
                _buildSummaryLine('가용 예산', finalBudget),
                _buildSummaryLine('작업가능요일', _selectedDaysText()),
                _buildSummaryLine('작업가능시간', '약 $workHours 시간'),
                _buildSummaryLine('직업', occupation),
              ],
            ),
          ),
        ),
        
        // 하단 고정 버튼
        const SizedBox(height: 16),
        Center(
          child: _buildButton('완료', _nextPage),
        ),
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
          Text(label, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          const SizedBox(width: 13),
          Text(value, style: TextStyle(fontSize: 18, color: Colors.grey[600])),
        ],
      ),
    );
  }

// _buildProjectInput이 컨트롤러를 직접 사용하도록 수정
Widget _buildProjectInput() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('제목', style: TextStyle(fontSize: 16)),
      TextField(
        controller: _projectTitleController, // 컨트롤러 연결
        style: const TextStyle(fontSize: 20),
        decoration: const InputDecoration(
          hintText: '예: 주식 트레이딩 공부',
          border: UnderlineInputBorder(),
        ),
        onChanged: (v) => setState(() {}), // 버튼 상태 갱신
      ),
      const SizedBox(height: 10),
      const Text('세부 내용', style: TextStyle(fontSize: 16)),
      TextField(
        controller: _projectDetailController, // 컨트롤러 연결
        style: const TextStyle(fontSize: 18),
        maxLines: 5,
        maxLength: 1000,
        decoration: const InputDecoration(
          hintText: '관심 종목 현황 파악, 관련 뉴스 보기 등',
          border: OutlineInputBorder(),
          counterText: '',
        ),
        onChanged: (v) => setState(() {}), // 버튼 상태 갱신
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