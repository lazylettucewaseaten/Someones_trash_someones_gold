import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizSelectionScreen extends StatefulWidget {
  @override
  _QuizSelectionScreenState createState() => _QuizSelectionScreenState();
}

class _QuizSelectionScreenState extends State<QuizSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mental Health Quizzes'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate to HomePage when the back arrow is clicked
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      HomePage()), // Ensure HomePage is correctly imported
            );
          },
        ),
      ),
      body: ListView.builder(
        itemCount: quizzes.length,
        itemBuilder: (context, index) {
          return QuizCard(
            quiz: quizzes[index],
            onStartQuiz: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(
                    quiz: quizzes[index],
                    allQuizzes: quizzes,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class StressLevelResult {
  double dassScore;
  double pssScore;
  double beckScore;
  double overallStressLevel;
  String stressInterpretation;

  StressLevelResult({
    required this.dassScore,
    required this.pssScore,
    required this.beckScore,
    required this.overallStressLevel,
    required this.stressInterpretation,
  });
}

class StressApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Health Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: QuizSelectionScreen(),
    );
  }
}

class Question {
  String question;
  List<String> options;
  int? selectedOption;
  int scoreValue;

  Question(this.question, this.options, {this.scoreValue = 0});
}

class Quiz {
  String title;
  List<Question> questions;
  String description;
  String imagePath;
  double Function(List<Question>) scoringMethod;

  Quiz(this.title, this.questions, this.description, this.imagePath,
      this.scoringMethod);
}

class QuizCard extends StatelessWidget {
  final Quiz quiz;
  final VoidCallback onStartQuiz;

  const QuizCard({
    Key? key,
    required this.quiz,
    required this.onStartQuiz,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quiz.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  quiz.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'How to Take the Quiz:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Complete all the quizes for Results\n1. Read each question carefully\n2. Select the option that best describes your experience\n3. Answer all questions honestly\n4. There are no right or wrong answers',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Disclaimer: This quiz is for informational purposes only and is not a substitute for professional medical advice. If you are experiencing significant mental health challenges, please consult a qualified healthcare professional.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onStartQuiz,
                  child: Text('Start Now'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Scoring Methods
double calculateDassScore(List<Question> questions) {
  return questions.fold(0.0, (sum, question) {
    // DASS scoring: 0, 1, 2, 3 for Never, Sometimes, Often, Always
    return sum + (question.selectedOption ?? 0);
  });
}

double calculatePssScore(List<Question> questions) {
  // PSS scoring is more nuanced
  List<int> positiveQuestionIndices = [
    2,
    4
  ]; // Reverse scoring for some questions
  return questions.asMap().entries.fold(0.0, (sum, entry) {
    int index = entry.key;
    Question question = entry.value;
    int selectedOption = question.selectedOption ?? 0;

    // For positive questions (index 2 and 4), reverse the scoring
    if (positiveQuestionIndices.contains(index)) {
      switch (selectedOption) {
        case 0:
          return sum + 3;
        case 1:
          return sum + 2;
        case 2:
          return sum + 1;
        case 3:
          return sum + 0;
        default:
          return sum;
      }
    } else {
      return sum + selectedOption;
    }
  });
}

double calculateBeckScore(List<Question> questions) {
  return questions.fold(0.0, (sum, question) {
    // Beck's Depression Inventory: 0, 1, 2, 3 for Not at all, A little, Moderately, Severely
    return sum + (question.selectedOption ?? 0);
  });
}

List<Quiz> quizzes = [
  Quiz(
    'DASS Quiz',
    [
      Question('How often do you feel tired?',
          ['Never', 'Sometimes', 'Often', 'Always']),
      Question('How often do you feel sad?',
          ['Never', 'Sometimes', 'Often', 'Always']),
      Question('How often do you find it hard to relax?',
          ['Never', 'Sometimes', 'Often', 'Always']),
      Question('How often do you feel stressed?',
          ['Never', 'Sometimes', 'Often', 'Always']),
      Question('How often do you feel anxious?',
          ['Never', 'Sometimes', 'Often', 'Always']),
      Question('How often do you feel overwhelmed?',
          ['Never', 'Sometimes', 'Often', 'Always']),
      Question('How often do you have trouble sleeping?',
          ['Never', 'Sometimes', 'Often', 'Always']),
    ],
    'Depression, Anxiety, and Stress Scale (DASS) Quiz helps assess your emotional state.',
    'assets/dass_quiz_image.jpg',
    calculateDassScore,
  ),
  Quiz(
    'PSS Quiz',
    [
      Question('How often have you felt nervous?',
          ['Never', 'Sometimes', 'Often', 'Very Often']),
      Question(
          'How often have you felt unable to control important things in your life?',
          ['Never', 'Sometimes', 'Often', 'Very Often']),
      Question('How often have you felt things were going your way?',
          ['Never', 'Sometimes', 'Often', 'Very Often']),
      Question('How often have you felt difficulties piling up?',
          ['Never', 'Sometimes', 'Often', 'Very Often']),
      Question(
          'How often have you felt confident about your ability to handle your personal problems?',
          ['Never', 'Sometimes', 'Often', 'Very Often']),
      Question('How often have you felt overwhelmed by all you had to do?',
          ['Never', 'Sometimes', 'Often', 'Very Often']),
      Question(
          'How often have you felt that you could not cope with all the things you had to do?',
          ['Never', 'Sometimes', 'Often', 'Very Often']),
    ],
    'Perceived Stress Scale (PSS) Quiz evaluates your perception of stress.',
    'assets/pss_quiz_image.jpeg',
    calculatePssScore,
  ),
  Quiz(
    'Beck\'s Depression Inventory',
    [
      Question(
          'I feel sad.', ['Not at all', 'A little', 'Moderately', 'Severely']),
      Question('I am unable to work.',
          ['Not at all', 'A little', 'Moderately', 'Severely']),
      Question('I am easily annoyed or irritated.',
          ['Not at all', 'A little', 'Moderately', 'Severely']),
      Question('I feel I am a failure.',
          ['Not at all', 'A little', 'Moderately', 'Severely']),
      Question('I feel I have lost interest in most things.',
          ['Not at all', 'A little', 'Moderately', 'Severely']),
      Question('I feel hopeless about the future.',
          ['Not at all', 'A little', 'Moderately', 'Severely']),
      Question('I feel I am not good at anything.',
          ['Not at all', 'A little', 'Moderately', 'Severely']),
    ],
    'Beck\'s Depression Inventory helps assess the severity of depression symptoms.',
    'assets/beck_quiz_image.jpeg',
    calculateBeckScore,
  ),
];

class ResultScreen extends StatelessWidget {
  final StressLevelResult result;

  const ResultScreen({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stress Level Result'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stress Assessment Results',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('DASS Score: ${result.dassScore.toStringAsFixed(2)}'),
            Text('PSS Score: ${result.pssScore.toStringAsFixed(2)}'),
            Text(
                'Beck Depression Score: ${result.beckScore.toStringAsFixed(2)}'),
            SizedBox(height: 16),
            Text(
              'Overall Stress Level: ${result.overallStressLevel.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              result.stressInterpretation,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 24), // Add some spacing
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (route) => false, // Clear the navigation stack
                  );
                },
                child: Text('Go to Homepage'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ... (previous QuizSelectionScreen and QuizCard code remains the same)

class QuizScreen extends StatefulWidget {
  final Quiz quiz;
  final List<Quiz> allQuizzes;

  const QuizScreen({
    Key? key,
    required this.quiz,
    required this.allQuizzes,
  }) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      // Quiz completed, check if all quizzes are done
      bool allQuizzesDone = widget.allQuizzes.every(
          (quiz) => quiz.questions.every((q) => q.selectedOption != null));

      if (allQuizzesDone) {
        // Calculate final stress level
        StressLevelResult result =
            calculateOverallStressLevel(widget.allQuizzes);

        // Navigate to result screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(result: result),
          ),
        );
      } else {
        // Return to quiz selection
        Navigator.pop(context);
      }
    }
  }

  StressLevelResult calculateOverallStressLevel(List<Quiz> quizzes) {
    // Calculate individual quiz scores
    double dassScore = quizzes[0].scoringMethod(quizzes[0].questions);
    double pssScore = quizzes[1].scoringMethod(quizzes[1].questions);
    double beckScore = quizzes[2].scoringMethod(quizzes[2].questions);

    // Normalize scores (assuming max score of 21 for each quiz)
    double normalizedDass = dassScore / 21;
    double normalizedPss = pssScore / 21;
    double normalizedBeck = beckScore / 21;

    // Weighted average with recommended weights
    // DASS: 0.4, PSS: 0.3, Beck: 0.3
    double overallStressLevel = ((normalizedDass * 0.4) +
            (normalizedPss * 0.3) +
            (normalizedBeck * 0.3)) *
        100;

    // Stress level interpretation
    String stressInterpretation = '';

    if (overallStressLevel < 20) {
      stressInterpretation =
          'Low Stress Level: You appear to be managing well.';
    } else if (overallStressLevel < 50) {
      stressInterpretation =
          'Moderate Stress Level: Some stress management techniques may be helpful.';
    } else if (overallStressLevel < 75) {
      stressInterpretation =
          'High Stress Level: Consider seeking professional support.';
    } else {
      stressInterpretation =
          'Severe Stress Level: Immediate professional help is recommended.';
    }

    return StressLevelResult(
      dassScore: dassScore,
      pssScore: pssScore,
      beckScore: beckScore,
      overallStressLevel: overallStressLevel,
      stressInterpretation: stressInterpretation,
    );
  }

  @override
  Widget build(BuildContext context) {
    Question currentQuestion = widget.quiz.questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1} of ${widget.quiz.questions.length}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              currentQuestion.question,
              style: TextStyle(fontSize: 20),
            ),
            ...currentQuestion.options.asMap().entries.map((entry) {
              int optionIndex = entry.key;
              String option = entry.value;
              return RadioListTile(
                title: Text(option),
                value: optionIndex,
                groupValue: currentQuestion.selectedOption,
                onChanged: (value) {
                  setState(() {
                    currentQuestion.selectedOption = value as int?;
                  });
                },
              );
            }).toList(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  currentQuestion.selectedOption != null ? _nextQuestion : null,
              child: Text(
                  _currentQuestionIndex == widget.quiz.questions.length - 1
                      ? 'Finish Quiz'
                      : 'Next Question'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
