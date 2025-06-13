import 'package:flutter/material.dart';
import 'package:future_diary/widgets/common/common_modal.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';


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

  final DateRangePickerController _datePickerController = DateRangePickerController();
  final TextEditingController _modalStartDateController = TextEditingController();
  final TextEditingController _modalEndDateController = TextEditingController();
  
  DateTime? startDate;
  DateTime? endDate;
  String projectTitle = '';
  String projectDetail = '';
  String diaryTitle = '';
  String diaryContent = '';
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  // 상태 변수 추가
  String? selectedCategory;
  String detailInput = '';

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _budgetController.dispose();
    _projectTitleController.dispose();
    _projectDetailController.dispose();
    _datePickerController.dispose();
    // 리스너를 사용하지 않으므로 removeListener 호출 제거
    _modalStartDateController.dispose();
    _modalEndDateController.dispose();
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
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBackArrow(),
                const SizedBox(height: 8),
                const Text('Q2', style: TextStyle(fontSize: 60)),
                const Text('하루동안 작업할 수 있는 시간은 얼마나 되나요?', style: TextStyle(fontSize: 30)),
                // NumberPicker 추가
                Center(
                  child: NumberPicker(
                    value: workHours,
                    minValue: 1,
                    maxValue: 18,
                    zeroPad: true,
                    infiniteLoop: true,
                    itemWidth: 2000,
                    textStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                    selectedTextStyle: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF778557),
                    ),
                    onChanged: (value) => setState(() => workHours = value),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    '$workHours시간',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(height: 33),
                _buildSummaryLine('직업', occupation),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
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
                const SizedBox(height: 182), // 간격 조정
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
                const SizedBox(height: 157), // 간격 조정
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
            child: Stack(
              children: [ 
                _buildBackArrow(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset('assets/illustrations/onboarding/laptop.png', height: 70, fit: BoxFit.fill),
                    ),
                    const Center(
                      child: Text(
                        '관심사 및 진행 중인 과업,\n앞으로 해야할 것들을 적어주세요.',
                        style: TextStyle(fontSize: 22, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // 상세 UI를 별도 함수로 분리하여 호출
                    _buildProjectInput(),
                    const SizedBox(height: 20),
                    _buildSummaryLine('가용 예산', finalBudget),
                    _buildSummaryLine('작업가능요일', _selectedDaysText()),
                    _buildSummaryLine('작업가능시간', '약 $workHours 시간'),
                    _buildSummaryLine('직업', occupation),
                  ],      
                ),
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
                  child: Image.asset('assets/illustrations/onboarding/summary_watch.png', height: 120),
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
  return Stack(
    clipBehavior: Clip.none,
    children: [
      Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 기간 표시 영역
            Row(
              children: [
                const Text('기간', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                Text(
                  (startDate == null || endDate == null)
                      ? '기간 없음'
                      : '${_formatDate(startDate!)} ~ ${_formatDate(endDate ?? startDate!)}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 17),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.calendar_today, color: Colors.grey[600]),
                  iconSize: 23,
                  onPressed: () async {
                    // 1. 모달을 열기 전, 현재 날짜로 모달용 컨트롤러들의 상태를 초기화
                    _datePickerController.selectedRange = PickerDateRange(startDate, endDate);
                    _modalStartDateController.text = (startDate != null) ? _formatDate(startDate!) : '';
                    _modalEndDateController.text = (endDate != null) ? _formatDate(endDate!) : '';

                    final PickerDateRange? result = await showCommonModal<PickerDateRange>(
                      context: context,
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                              height: 300,
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: olive,
                                    onPrimary: Colors.white,
                                    surface: Colors.white,
                                    onSurface: Colors.black,
                                  ),
                                ),
                                child: SfDateRangePicker(
                                  controller: _datePickerController,
                                  headerStyle: DateRangePickerHeaderStyle(
                                    backgroundColor: Colors.transparent,
                                    textStyle: TextStyle(
                                      fontSize: 27,
                                      color: olive,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  monthFormat: 'MM월',
                                  view: DateRangePickerView.month,
                                  backgroundColor: Colors.transparent,
                                  selectionMode: DateRangePickerSelectionMode.range,
                                  selectionColor: olive,
                                  startRangeSelectionColor: olive,
                                  endRangeSelectionColor: olive,
                                  rangeTextStyle: TextStyle(color: Colors.white),
                                  minDate: DateTime.now().subtract(const Duration(days: 365*1)),
                                  maxDate: DateTime.now().add(const Duration(days: 365*1)),
                                  onSelectionChanged: (args) {
                                    // 달력 선택 -> 입력창 텍스트 변경
                                    if (args.value is PickerDateRange) {
                                      final range = args.value as PickerDateRange;
                                      setState(() { // 모달의 setState만 호출
                                        _modalStartDateController.text = range.startDate != null ? _formatDate(range.startDate!) : '';
                                        _modalEndDateController.text = range.endDate != null ? _formatDate(range.endDate!) : '';
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                  Expanded(child: TextField(controller: _modalStartDateController, readOnly: true, decoration: const InputDecoration(labelText: '시작일',hintText: 'YYYY-MM-DD'),style: TextStyle(fontSize: 25))),
                                  const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Text('~')),
                                  Expanded(child: TextField(controller: _modalEndDateController, readOnly: true, decoration: const InputDecoration(labelText: '종료일',hintText: 'YYYY-MM-DD'),style: TextStyle(fontSize: 25))),
                              ],
                            ),
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: TextButton.styleFrom(
                                    fixedSize: const Size(100, 50),
                                    backgroundColor: Colors.grey[200],
                                  ),
                                  child: const Text(
                                    '취소',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                     Navigator.pop(context, _datePickerController.selectedRange);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(100, 50),
                                    backgroundColor: olive,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: const Text(
                                    '확인',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                      ),);
                      if (result != null) {
                        setState(() {
                          startDate = result.startDate;
                          endDate = result.endDate;
                        });
                      }
                  },
                )
              ],
            ),
            // 제목 입력 필드
            TextField(
              controller: _projectTitleController,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              maxLength: 20,
              decoration: const InputDecoration(
                hintText: '제목 (최대 20자)',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 22),
                border: InputBorder.none, // 기본 밑줄 제거
                contentPadding: EdgeInsets.symmetric(vertical: 0.0), 
              ),
              onChanged: (_) => setState(() {}),
            ),
            const Divider(height: 0), // 제목과 세부 내용 사이의 선
            // 세부 내용 입력 필드
            TextField(
              controller: _projectDetailController,
              maxLines: 5, // 여러 줄 입력 가능
              maxLength: 300,
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                hintText: '세부 내용(최대 300자)\n- 한줄 정리\n- 계기 및 목표\n- 기술 및 도구\n- 진행 상황\n- 가장 큰 어려움',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                border: InputBorder.none, // 기본 테두리 제거
              ),
              // 글자 수 카운터 UI 커스텀
              buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '$currentLength/$maxLength자',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                );
              },
              onChanged: (_) => setState(() {}),
            ),
          ],
        ),
      ),
      // 2. 우측 하단의 '+' 버튼
      Positioned(
        right: 0,
        bottom: -60,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[700],
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(1, 1),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              // TODO: 새 과업 카드 추가 로직
            },
          ),
        ),
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