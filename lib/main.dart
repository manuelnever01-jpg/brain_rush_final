import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const BrainRushApp());
}

class BrainRushApp extends StatelessWidget {
  const BrainRushApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BrainRush IUE',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E1E2E),
        primaryColor: Colors.indigo,
      ),
      home: const LoginScreen(),
    );
  }
}

// ==========================================
// 1. PANTALLA DE LOGIN
// ==========================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    if (_userController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor llena todos los campos')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulación de latencia de red/nube
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isLoading = false);

    if (_userController.text.trim() == "manolo" &&
        _passwordController.text == "1234") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen(username: _userController.text)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Credenciales incorrectas (Usa: manolo / 1234)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.psychology,
                  size: 80, color: Colors.indigoAccent),
              const SizedBox(height: 16),
              const Text('BRAINRUSH - IUE',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              TextField(
                controller: _userController,
                decoration: const InputDecoration(
                    labelText: 'Usuario de Prueba',
                    border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Contraseña', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50)),
                      onPressed: _handleLogin,
                      child: const Text('Iniciar Sesión'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 2. HOME: LISTADO Y CRUD COMPLETO DE PARTIDAS
// ==========================================
class HomeScreen extends StatefulWidget {
  final String username;
  const HomeScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _highScore = 0;
  List<String> _history = [];
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Carga datos emulando relación Local-Remota
  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _highScore = prefs.getInt('high_score') ?? 0; // Persistencia Local
    _history =
        prefs.getStringList('history') ?? []; // Historial remoto simulado

    await Future.delayed(
        const Duration(milliseconds: 800)); // Simula estado "Cargando"
    setState(() => _isLoadingData = false);
  }

  // C - CREATE: Guardar nueva partida en la lista
  void _saveNewScore(int newScore) async {
    final prefs = await SharedPreferences.getInstance();
    String formattedDate = DateTime.now().toString().substring(11, 16);
    setState(() {
      _history.insert(
          0, "Score: $newScore pts ($formattedDate) - Sin comentarios");
    });
    await prefs.setStringList('history', _history);

    if (newScore > _highScore) {
      setState(() => _highScore = newScore);
      await prefs.setInt('high_score', _highScore);
    }
  }

  // U - UPDATE: Editar comentario de una partida específica
  void _editMatchNote(int index) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Nota de la Partida'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
              hintText: "Ej: Estuvo difícil, me equivoqué en la última"),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              if (textController.text.isNotEmpty) {
                final prefs = await SharedPreferences.getInstance();
                // Extraer el puntaje original para conservar la estructura
                String originalPart = _history[index].split(' - ')[0];
                setState(() {
                  _history[index] =
                      "$originalPart - Nota: ${textController.text}";
                });
                await prefs.setStringList('history', _history);
              }
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          )
        ],
      ),
    );
  }

  // D - DELETE: Eliminar una partida del historial
  void _deleteScore(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _history.removeAt(index);
    });
    await prefs.setStringList('history', _history);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hola, ${widget.username}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginScreen())),
          )
        ],
      ),
      body: _isLoadingData
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: Colors.indigo.shade900,
                    child: ListTile(
                      leading: const Icon(Icons.emoji_events,
                          color: Colors.amber, size: 36),
                      title: const Text('Récord Personal (Local)'),
                      trailing: Text('$_highScore pts',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.green),
                    onPressed: () async {
                      final score = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GamePlayScreen()),
                      );
                      if (score != null && score is int) {
                        _saveNewScore(score);
                      }
                    },
                    icon: const Icon(Icons.sports_esports),
                    label: const Text('INICIAR RETO DE AGILIDAD'),
                  ),
                  const SizedBox(height: 24),
                  const Text('Historial de Partidas (Sincronizado)',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: _history.isEmpty
                        ? const Center(
                            child: Text(
                                'Historial vacío. ¡Juega tu primera partida!'))
                        : ListView.builder(
                            itemCount: _history.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  leading: const Icon(Icons.check_circle,
                                      color: Colors.cyanAccent),
                                  title: Text(_history[index]),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.white54),
                                        onPressed: () => _editMatchNote(index),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.redAccent),
                                        onPressed: () => _deleteScore(index),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  )
                ],
              ),
            ),
    );
  }
}

// ==========================================
// 3. MOTOR DEL JUEGO (LÓGICA MATEMÁTICA)
// ==========================================
class GamePlayScreen extends StatefulWidget {
  const GamePlayScreen({Key? key}) : super(key: key);

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> {
  int _score = 0;
  int _timeLeft = 10;
  Timer? _timer;
  late int _num1, _num2, _correctAnswer;
  List<int> _options = [];

  @override
  void initState() {
    super.initState();
    _generateChallenge();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _gameOver();
      }
    });
  }

  void _generateChallenge() {
    final rand = Random();
    _num1 = rand.nextInt(8) + 2;
    _num2 = rand.nextInt(8) + 2;
    _correctAnswer = _num1 * _num2;

    Set<int> opts = {_correctAnswer};
    while (opts.length < 4) {
      opts.add(_correctAnswer + rand.nextInt(10) - 5);
    }
    _options = opts.toList();
    _options.shuffle();
  }

  void _checkAnswer(int ans) {
    if (ans == _correctAnswer) {
      setState(() {
        _score += 10;
        _timeLeft += 2; // Bonus de tiempo
      });
      _generateChallenge();
    } else {
      setState(() {
        _timeLeft = max(0, _timeLeft - 3); // Penalización por error
      });
      _generateChallenge();
    }
  }

  void _gameOver() {
    _timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('¡Tiempo Agotado!'),
        content: Text('Lograste un puntaje de: $_score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, _score); // Retorna el dato al Home
            },
            child: const Text('Guardar en Historial'),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Puntos: $_score',
                      style: const TextStyle(
                          fontSize: 20, color: Colors.greenAccent)),
                  Text('Tiempo: $_timeLeft s',
                      style: TextStyle(
                          fontSize: 20,
                          color: _timeLeft > 3 ? Colors.cyan : Colors.red)),
                ],
              ),
              Column(
                children: [
                  const Text('Resuelve rápido:',
                      style: TextStyle(fontSize: 18, color: Colors.white54)),
                  const SizedBox(height: 12),
                  Text('$_num1 × $_num2',
                      style: const TextStyle(
                          fontSize: 56, fontWeight: FontWeight.bold)),
                ],
              ),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 2),
                itemCount: _options.length,
                itemBuilder: (context, idx) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade700),
                    onPressed: () => _checkAnswer(_options[idx]),
                    child: Text('${_options[idx]}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
