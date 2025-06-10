import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentPage = 0;

  // 기본 정보 입력 컨트롤러들
  final _fullNameController = TextEditingController();
  final _birthController = TextEditingController();
  String _selectedGender = '남성';
  final _countryController = TextEditingController();
  final _occupationController = TextEditingController();
  final _pursuitController = TextEditingController();
  int _workHoursPerDay = 8;
  int _workDaysPerWeek = 5;
  int _monthlyBudget = 1000000;

  Future<bool> _onWillPop() async {
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('앱 종료'),
        content: Text('온보딩을 완료하지 않고 앱을 종료하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('종료'),
          ),
        ],
      ),
    );
    
    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('온보딩'),
          automaticallyImplyLeading: false,
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          physics: NeverScrollableScrollPhysics(), // 스와이프로 페이지 전환 방지
          children: [
            _buildBasicInfoPage(),
            _buildWorkInfoPage(),
            _buildBudgetPage(),
          ],
        ),
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

  Widget _buildBasicInfoPage() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
    if (_formKey.currentState!.validate()) {
      // TODO: 온보딩 정보 저장 및 다음 화면으로 이동
      print('온보딩 정보 제출');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fullNameController.dispose();
    _birthController.dispose();
    _countryController.dispose();
    _occupationController.dispose();
    _pursuitController.dispose();
    super.dispose();
  }
} 