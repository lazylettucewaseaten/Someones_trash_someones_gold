import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: SnakeGame(),
  ));
}

class SnakeGame extends StatefulWidget {
  @override
  _SnakeGameState createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  static const int gridSize = 20; // 20x20 grid
  List<Offset> _snake = [Offset(5, 5)]; // Initial snake position
  Offset _food = Offset(10, 10); // Initial food position
  String _direction = 'right'; // Snake direction
  bool _gameOver = false;
  int _score = 0;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    _gameOver = false;
    _score = 0;
    _snake = [Offset(5, 5)];
    _food = _generateRandomFood();
    _direction = 'right';

    _timer = Timer.periodic(Duration(milliseconds: 150), (timer) {
      if (!_gameOver) {
        _moveSnake();
      } else {
        timer.cancel();
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Game Over'),
            content: Text('Score: $_score'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _startGame();
                },
                child: Text('Play Again'),
              ),
            ],
          ),
        );
      }
    });
  }

  void _moveSnake() {
    setState(() {
      Offset newHead;

      // Determine the new head based on the current direction
      switch (_direction) {
        case 'up':
          newHead = Offset(_snake.first.dx, _snake.first.dy - 1);
          break;
        case 'down':
          newHead = Offset(_snake.first.dx, _snake.first.dy + 1);
          break;
        case 'left':
          newHead = Offset(_snake.first.dx - 1, _snake.first.dy);
          break;
        case 'right':
          newHead = Offset(_snake.first.dx + 1, _snake.first.dy);
          break;
        default:
          newHead = _snake.first;
      }

      // Check for collisions with walls
      if (newHead.dx < 0 ||
          newHead.dy < 0 ||
          newHead.dx >= gridSize ||
          newHead.dy >= gridSize ||
          _snake.contains(newHead)) {
        _gameOver = true;
        return;
      }

      // Add the new head to the snake
      _snake.insert(0, newHead);

      // Check if the snake eats the food
      if (newHead == _food) {
        _score += 10;
        _food = _generateRandomFood();
      } else {
        // Remove the last segment of the snake
        _snake.removeLast();
      }
    });
  }

  // Generate random food within grid boundaries
  Offset _generateRandomFood() {
    Random rand = Random();
    return Offset(rand.nextInt(gridSize).toDouble(), rand.nextInt(gridSize).toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Snake Game'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Score: $_score', style: TextStyle(fontSize: 24)),
          ),
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.primaryDelta! > 0 && _direction != 'up') {
                  _direction = 'down';
                } else if (details.primaryDelta! < 0 && _direction != 'down') {
                  _direction = 'up';
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.primaryDelta! > 0 && _direction != 'left') {
                  _direction = 'right';
                } else if (details.primaryDelta! < 0 && _direction != 'right') {
                  _direction = 'left';
                }
              },
              child: Center(
                child: Container(
                  width: gridSize * 20.0,
                  height: gridSize * 20.0,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.green, width: 2),
                  ),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridSize,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                    ),
                    itemCount: gridSize * gridSize,
                    itemBuilder: (context, index) {
                      int x = index % gridSize;
                      int y = index ~/ gridSize;

                      // Draw snake body and food
                      if (_snake.contains(Offset(x.toDouble(), y.toDouble()))) {
                        return Container(
                          color: Colors.green,
                        );
                      } else if (_food == Offset(x.toDouble(), y.toDouble())) {
                        return Container(
                          color: Colors.red,
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
