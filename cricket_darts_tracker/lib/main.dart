import 'package:flutter/material.dart';

void main() {
  runApp(const CricketDartApp());
}

class CricketDartApp extends StatelessWidget {
  const CricketDartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: ' Darts Tracker',
      theme: ThemeData(
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: Colors.grey[200],
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 18),
    ),
  ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();

}


class _HomeScreenState extends State<HomeScreen> {
  void _navigateToMode(BuildContext context, String mode){
    Widget screen;

    switch (mode) {
      case 'Cricket':
        screen = const CricketGameScreen(title: 'Cricket');
        break;
      case '501':
      case '401':
      case '301':
    screen = X01GameScreen(title: '$mode Game', startingScore: int.parse(mode));
        break;
      default:
        return;
    }
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => screen),
    );
  }
  @override
  Widget build(BuildContext context){
    final List<String> modes = ['Cricket', '501', '401', '301'];

        final screenWidth = MediaQuery.of(context).size.width;

    final buttonWidth = (screenWidth / 2) - 40;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Darts Tracker'),
        centerTitle: true,
        ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GridView.count(
          crossAxisCount: 1,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: buttonWidth / 70,
          children: modes.map((mode) {
            return ElevatedButton(
              onPressed: () => _navigateToMode(context, mode),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                backgroundColor: Colors.green[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                mode,
                style: const TextStyle(fontSize: 22, color: Colors.white),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}




class CricketGameScreen extends StatefulWidget {
  final String title;
  const CricketGameScreen({super.key, required this.title});

  @override
  _CricketGameScreenState createState() => _CricketGameScreenState();
}

class _CricketGameScreenState extends State<CricketGameScreen> {
  final TextEditingController player1Controller = TextEditingController();
  final TextEditingController player2Controller = TextEditingController();

  final List<String> targets = ['20', '19', '18', '17', '16', '15', 'Bull'];

  // Track hits for each target for each player
  Map<String, int> player1Hits = {};
  Map<String, int> player2Hits = {};

  @override
  void initState() {
    super.initState();
    for (var target in targets) {
      player1Hits[target] = 0;
      player2Hits[target] = 0;
    }
  }

  void incrementHits(Map<String, int> hitsMap, String target) {
    setState(() {
      hitsMap[target] = ((hitsMap[target] ?? 0) + 1) % 4;
    });
  }

  Widget buildTargetColumn(Map<String, int> hitsMap, bool isPlayer1) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: targets.map((target) {
        return GestureDetector(
          onTap: () => incrementHits(hitsMap, target),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: SizedBox(
              width: 70,
              height: 70,
              child: CustomPaint(
                painter: HitsPainter(hitsMap[target]!),
                child: Center(
                  child: Text(
                    target,
                    style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(widget.title),
      backgroundColor: Colors.green,
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
  
                  TextField(
                    controller: player1Controller,
                    decoration: const InputDecoration(
                      labelText: 'Player 1 Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildTargetColumn(player1Hits, true),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                children: [
                  TextField(
                    controller: player2Controller,
                    decoration: const InputDecoration(
                      labelText: 'Player 2 Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildTargetColumn(player2Hits, false),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

}

class HitsPainter extends CustomPainter {
  final int hits;
  HitsPainter(this.hits);

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = Colors.red
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final paintCircle = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    if (hits >= 1) {
      canvas.drawLine(
        Offset(size.width * 0.3, size.height * 0.2),
        Offset(size.width * 0.7, size.height * 0.8),
        paintLine,
      );
    }
    if (hits >= 2) {
      canvas.drawLine(
        Offset(size.width * 0.7, size.height * 0.2),
        Offset(size.width * 0.3, size.height * 0.8),
        paintLine,
      );
    }
    if (hits == 3) {
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        size.width / 2 - 10,
        paintCircle,
      );
    }
  }

  @override
  bool shouldRepaint(HitsPainter oldDelegate) => oldDelegate.hits != hits;
}

class X01GameScreen extends StatefulWidget {
  final String title;
  final int startingScore;

  const X01GameScreen({super.key, required this.title, required this.startingScore});

  @override
  _X01GameScreenState createState() => _X01GameScreenState();
}

class _X01GameScreenState extends State<X01GameScreen> {
  final TextEditingController player1Controller = TextEditingController();
  final TextEditingController player2Controller = TextEditingController();
  final TextEditingController scoreController = TextEditingController();

  late int player1Score;
  late int player2Score;
  bool isPlayer1Turn = true;

  @override
  void initState() {
    super.initState();
    player1Score = widget.startingScore;
    player2Score = widget.startingScore;
  }

  void submitScore() {
    final int? score = int.tryParse(scoreController.text);
    if (score == null || score < 0) return;

    setState(() {
      if (isPlayer1Turn) {
        if (player1Score - score >= 0) {
          player1Score -= score;
        }
      } else {
        if (player2Score - score >= 0) {
          player2Score -= score;
        }
      }

      // Check for winner
      if (player1Score == 0 || player2Score == 0) {
        final winner = isPlayer1Turn ? player1Controller.text : player2Controller.text;
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Game Over'),
            content: Text('$winner wins!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // go back to HomeScreen
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      // Switch turns
      isPlayer1Turn = !isPlayer1Turn;
      scoreController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: player1Controller,
              decoration: const InputDecoration(
                labelText: 'Player 1 Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: player2Controller,
              decoration: const InputDecoration(
                labelText: 'Player 2 Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildScoreBox(player1Controller.text, player1Score),
                _buildScoreBox(player2Controller.text, player2Score),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              '${isPlayer1Turn ? (player1Controller.text.isEmpty ? 'Player 1' : player1Controller.text) : (player2Controller.text.isEmpty ? 'Player 2' : player2Controller.text)}\'s Turn',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: scoreController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Score Hit',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: submitScore,
              child: const Text('Submit Score'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBox(String name, int score) {
    return Column(
      children: [
        Text(name.isEmpty ? 'Player' : name, style: const TextStyle(fontSize: 18)),
        Text(score.toString(), style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

