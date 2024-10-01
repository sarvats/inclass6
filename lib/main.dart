import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

class Counter with ChangeNotifier {
  int value = 0;

  void increment() {
    value += 1;
    notifyListeners();
  }

  void decrement() {
    if (value > 0) { 
      value -= 1;
      notifyListeners();
    }
  }

  String get milestoneMessage {
    if (value >= 0 && value <= 12) return "You're a child!";
    if (value >= 13 && value <= 19) return "Teenager time!";
    if (value >= 20 && value <= 30) return "You're a young adult!";
    if (value >= 31 && value <= 50) return "You're an adult now!";
    return "Golden years!";
  }

  Color get backgroundColor {
    if (value >= 0 && value <= 12) return Colors.lightBlue;
    if (value >= 13 && value <= 19) return Colors.lightGreen;
    if (value >= 20 && value <= 30) return Colors.yellow;
    if (value >= 31 && value <= 50) return Colors.orange;
    return Colors.grey;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = context.watch<Counter>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Container(
        color: counter.backgroundColor, 
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('You have pushed the button this many times:'),
              Text(
                '${counter.value}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              Text(
                counter.milestoneMessage, 
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 40), 
              Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  
                  ElevatedButton(
                    onPressed: () {
                      counter.decrement();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: const Text('Reduce Age'),
                  ),
                  const SizedBox(width: 10), 
                  
                  ElevatedButton(
                    onPressed: () {
                      counter.increment();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: const Text('Increase Age'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
