import 'package:flutter/material.dart';


class TicTac extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic-Tac-Toe Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TicTacToePage(),
    );
  }
}

class TicTacToePage extends StatefulWidget {
  @override
  _TicTacToePageState createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  List<String> _board = List.generate(9, (index) => ''); // Empty board
  String _currentPlayer = 'X'; // Player X starts
  String _winner = ''; // Track winner
  bool _gameOver = false;

  void _handleTap(int index) {
    if (_board[index] == '' && !_gameOver) {
      setState(() {
        _board[index] = _currentPlayer;
        _checkWinner();
        _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X'; // Switch player
      });
    }
  }

  void _checkWinner() {
    // Define the winning combinations
    List<List<int>> winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var combination in winningCombinations) {
      if (_board[combination[0]] != '' &&
          _board[combination[0]] == _board[combination[1]] &&
          _board[combination[1]] == _board[combination[2]]) {
        setState(() {
          _winner = _board[combination[0]];
          _gameOver = true;
        });
        return;
      }
    }

    if (!_board.contains('')) {
      setState(() {
        _winner = 'Draw';
        _gameOver = true;
      });
    }
  }

  void _resetGame() {
    setState(() {
      _board = List.generate(9, (index) => '');
      _currentPlayer = 'X';
      _winner = '';
      _gameOver = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic-Tac-Toe'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_winner != '')
            Text(
              _winner == 'Draw' ? 'It\'s a Draw!' : 'Player $_winner Wins!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _handleTap(index),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      _board[index],
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: _board[index] == 'X' ? Colors.blue : Colors.red,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _resetGame,
            child: Text('Restart Game'),
          ),
        ],
      ),
    );
  }
}
