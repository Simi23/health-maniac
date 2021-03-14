import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';

import 'puzzle.dart';
import 'tologatos.dart';
import 'memory.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static var gamePaths = [
    PuzzlePage(),
    SliderPage(),
    MemoryPage(),
  ];

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Music audio;
  Random rnd = new Random();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    audio = new Music._privateConstructor();
    audio.playLoop("music.mp3");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Health Maniac",
      initialRoute: "/",
      routes: {
        "/": (context) => HomePage(),
        "/puzzle": (context) => PuzzlePage(),
        "/8puzzle": (context) => SliderPage(),
        "/memoryGame": (context) => MemoryPage(),
        "/randomGame": (context) {
          return MyApp.gamePaths[rnd.nextInt(MyApp.gamePaths.length)];
        },
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if ((state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive)) {
      audio.stopLoop();
    } else if (state == AppLifecycleState.resumed) {
      audio.playLoop("music.mp3");
    }
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/fullPics/appBg.png"),
              fit: BoxFit.cover,
            )),
            alignment: Alignment.center,
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/fullPics/logo.png"),
                    ButtonTheme(
                      height: 200,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.red[800])),
                          onPressed: () {
                            Navigator.pushNamed(context, "/randomGame");
                          },
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(40, 15, 40, 15),
                              child: Text(
                                "Indítás",
                                style: TextStyle(fontSize: 40),
                              ))),
                    ),
                    ButtonTheme(
                      height: 200,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.red[800])),
                          onPressed: () {
                            makeInfoDialog(context);
                          },
                          child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Információ",
                                style: TextStyle(fontSize: 18),
                              ))),
                    ),
                    ButtonTheme(
                      height: 200,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.red[800])),
                          onPressed: () {
                            makeAlertDialog(context);
                          },
                          child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Rólunk",
                                style: TextStyle(fontSize: 18),
                              ))),
                    ),
                  ],
            ))));
  }

  void makeAlertDialog(BuildContext context) {
    Widget homeButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Ezt az applikációt a Carrot Power csapata készítette."),
      actions: [
        homeButton
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void makeInfoDialog(BuildContext context) {
    Widget homeButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Az indítás gomb megnyomásával véletlenszerűen a következő három játék egyike indul el:\n - Memóriakártya\n - Puzzle\n - Tili-toli"),
      actions: [
        homeButton
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class Music {
  AudioPlayer player = AudioPlayer();
  AudioCache cache = AudioCache();

  Music._privateConstructor() {
    this.player.setVolume(0.5);
  }

  static final Music instance = Music._privateConstructor();

  Future playLoop(String filePath) async {
    player.stop();
    player = await cache.loop(filePath);
  }

  void stopLoop() {
    player?.stop();
  }
}
