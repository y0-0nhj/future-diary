import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentPage = 0;

  // ... (다른 컨트롤러 변수들은 그대로) ...
  final _fullNameController = TextEditingController();
  final _birthController = TextEditingController();
  String _selectedGender = '남성';
  final _countryController = TextEditingController();
  final _occupationController = TextEditingController();
  final _pursuitController = TextEditingController();
  int _workHoursPerDay = 8;
  int _workDaysPerWeek = 5;
  int _monthlyBudget = 1000000;

  @override
  Widget build(BuildContext context) {
    // 1. Scaffold를 PopScope로 감싸줍니다.
    return PopScope(
      canPop: false, // 이 화면 자체는 뒤로가기로 바로 닫히지 않습니다.
      onPopInvoked: (didPop) {
        if (didPop) return;

        // 2. 현재 페이지가 첫 페이지(0)보다 뒤에 있다면,
        if ((_pageController.page?.round() ?? 0) > 0) {
          // PageView의 이전 페이지로 이동시킵니다.
          _pageController.previousPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else {
          // 3. 현재 페이지가 첫 페이지라면, 아무것도 하지 않습니다.
          // 이 경우, 이벤트가 상위(main.dart)의 PopScope로 전달되어
          // "앱 종료" 다이얼로그가 뜨게 됩니다.
        }
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          // 원인이었던 physics는 그대로 둡니다. 이제 PopScope가 제어하니까요.
          physics: NeverScrollableScrollPhysics(),
          children: [
            _buildBasicInfoPage(),
            _buildWorkInfoPage(),
            _buildBudgetPage(),
          ],
        ),
        // ... (bottomNavigationBar는 수정할 필요 없음) ...
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentPage > 0)
                ElevatedButton(
                  onPressed: () {
                    _pageController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Text('이전'),
                ),
              Spacer(), // 버튼을 양 끝으로 보내기 위해 추가하면 좋습니다.
              ElevatedButton(
                onPressed: () {
                  if (_currentPage < 2) {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    _submitForm();
                  }
                },
                child: Text(_currentPage == 2 ? '완료' : '다음'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // _buildBasicInfoPage, _buildWorkInfoPage, _buildBudgetPage, _submitForm, dispose 메서드는
  // 수정할 필요 없이 그대로 두시면 됩니다.
  Widget _buildBasicInfoPage() {
    // ... 기존 코드 ...
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(),
            Text(
              '기본 정보',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 24),
            TextFormField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: '이름',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '이름을 입력해주세요';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _birthController,
              decoration: InputDecoration(
                labelText: '생년월일',
                border: OutlineInputBorder(),
                hintText: 'YYYY-MM-DD',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '생년월일을 입력해주세요';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: InputDecoration(
                labelText: '성별',
                border: OutlineInputBorder(),
              ),
              items: ['남성', '여성', '기타'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue!;
                });
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _countryController,
              decoration: InputDecoration(
                labelText: '국가',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '국가를 입력해주세요';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkInfoPage() {
    // ... 기존 코드 ...
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '직업 정보',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 24),
          TextFormField(
            controller: _occupationController,
            decoration: InputDecoration(
              labelText: '직업',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '직업을 입력해주세요';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _pursuitController,
            decoration: InputDecoration(
              labelText: '추구하는 목표',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '목표를 입력해주세요';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          Text('일일 근무 시간'),
          Slider(
            value: _workHoursPerDay.toDouble(),
            min: 1,
            max: 24,
            divisions: 23,
            label: '$_workHoursPerDay시간',
            onChanged: (double value) {
              setState(() {
                _workHoursPerDay = value.round();
              });
            },
          ),
          SizedBox(height: 16),
          Text('주간 근무 일수'),
          Slider(
            value: _workDaysPerWeek.toDouble(),
            min: 1,
            max: 7,
            divisions: 6,
            label: '$_workDaysPerWeek일',
            onChanged: (double value) {
              setState(() {
                _workDaysPerWeek = value.round();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetPage() {
    // ... 기존 코드 ...
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '예산 정보',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 24),
          Text('월 예산'),
          Slider(
            value: _monthlyBudget.toDouble(),
            min: 0,
            max: 10000000,
            divisions: 100,
            label: '${_monthlyBudget.toStringAsFixed(0)}원',
            onChanged: (double value) {
              setState(() {
                _monthlyBudget = value.round();
              });
            },
          ),
          Text(
            '${_monthlyBudget.toStringAsFixed(0)}원',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    // ... 기존 코드 ...
    if (_formKey.currentState!.validate()) {
      // TODO: 온보딩 정보 저장 및 다음 화면으로 이동
      print('온보딩 정보 제출');
    }
  }

  @override
  void dispose() {
    // ... 기존 코드 ...
    _pageController.dispose();
    _fullNameController.dispose();
    _birthController.dispose();
    _countryController.dispose();
    _occupationController.dispose();
    _pursuitController.dispose();
    super.dispose();
  }
}