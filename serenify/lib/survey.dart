import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StressApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AICompanionScreen(),
    );
  }
}

class AICompanionScreen extends StatefulWidget {
  @override
  _AICompanionScreenState createState() => _AICompanionScreenState();
}

class _AICompanionScreenState extends State<AICompanionScreen>
    with TickerProviderStateMixin {
  final List<Map<String, dynamic>> questions = [
    {
      "question":
          "How often do you feel overwhelmed by daily responsibilities?",
      "options": ["Almost always", "Frequently", "Sometimes", "Rarely"]
    },
    {
      "question": "How well do you sleep at night?",
      "options": [
        "I rarely sleep well",
        "I struggle with sleep most nights",
        "I have occasional sleepless nights",
        "I usually sleep well"
      ]
    },
    {
      "question":
          "How do you feel about the amount of control you have over your life?",
      "options": [
        "Very little control",
        "Limited control",
        "Moderate control",
        "A lot of control"
      ]
    },
    {
      "question":
          "How often do you feel physically tense or experience muscle tightness?",
      "options": [
        "Almost every day",
        "A few times a week",
        "Occasionally",
        "Rarely"
      ]
    },
    {
      "question": "How would you describe your work-life balance?",
      "options": [
        "Extremely unbalanced",
        "Mostly unbalanced",
        "Somewhat balanced",
        "Well-balanced"
      ]
    },
    {
      "question":
          "How often do you take time to relax or do something you enjoy?",
      "options": ["Almost never", "Rarely", "Sometimes", "Frequently"]
    },
    {
      "question":
          "When faced with unexpected changes, how do you typically react?",
      "options": [
        "I panic and feel stressed",
        "I feel anxious but manage it",
        "I try to stay calm but worry",
        "I adapt calmly and confidently"
      ]
    },
    {
      "question": "How often do you feel rushed in your daily activities?",
      "options": ["Almost always", "Frequently", "Sometimes", "Rarely"]
    },
    {
      "question":
          "Do you feel supported by family, friends, or a network when you're stressed?",
      "options": ["Rarely or never", "Occasionally", "Often", "Almost always"]
    },
    {
      "question": "How would you describe your general mood most days?",
      "options": [
        "Stressed and irritable",
        "Worried but managing",
        "Mostly calm but with some stress",
        "Calm and positive"
      ]
    },
  ];

  int currentQuestionIndex = 0;
  String selectedOption = '';
  int _score = 0;

  late AnimationController _bubbleController;
  late Animation<double> _bubbleScale;
  late Animation<double> _bubbleOpacity;

  @override
  void initState() {
    super.initState();

    _bubbleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );

    _bubbleScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _bubbleController,
        curve: Curves.easeOutBack,
      ),
    );

    _bubbleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _bubbleController,
        curve: Curves.easeInOut,
      ),
    );

    _bubbleController.forward();
  }

  int _getOptionValue(String option) {
    switch (questions[currentQuestionIndex]['options'].indexOf(option)) {
      case 0:
        return 4;
      case 1:
        return 3;
      case 2:
        return 2;
      case 3:
        return 1;
      default:
        return 0;
    }
  }

  void _sendResponse() async {
    if (selectedOption.isNotEmpty) {
      _score += _getOptionValue(selectedOption);
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedOption = '';
      });
      _bubbleController.reset();
      _bubbleController.forward();
    } else {
      int stressLevel = ((_score / 40) * 100).round();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('stressLevel', stressLevel);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CompletionScreen(score: _score),
        ),
      );
    }
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stress Survey"),
        backgroundColor: Colors.blue[700],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ),
      backgroundColor: Color(0xFFE3F2FD),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Talk to Your Buddy',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Let your AI buddy help you relieve stress',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    AnimatedBuilder(
                      animation: _bubbleController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _bubbleScale.value,
                          child: Opacity(
                            opacity: _bubbleOpacity.value,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 30),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${currentQuestionIndex + 1}/${questions.length}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    questions[currentQuestionIndex]['question'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  ...questions[currentQuestionIndex]['options']
                                      .map<Widget>((option) => RadioListTile(
                                            title: Text(option),
                                            value: option,
                                            groupValue: selectedOption,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedOption = value!;
                                              });
                                            },
                                          ))
                                      .toList(),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed:
                          selectedOption.isNotEmpty ? _sendResponse : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(
                        currentQuestionIndex == questions.length - 1
                            ? 'Finish'
                            : 'Next',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CompletionScreen extends StatelessWidget {
  final int score;

  CompletionScreen({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3F2FD),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Thank you for your responses!',
              style: TextStyle(
                fontSize: 24,
                color: Colors.blue[800],
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
                minimumSize: Size(150, 50),
              ),
              child: Text(
                'Back to Home',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}