import 'package:flutter/material.dart';
import 'dart:math';
import 'utils.dart';

class PuzzlePage extends StatefulWidget {
  static List<String> puzzlePics = [
    "fruitBasket",
    "carrotPower",
    "fruitCollection",
    "muffin",
    "carrotSmoothie",
    "fruitWarrior"
  ];
  static String imagesPath = "assets/puzzlePics/";

  @override
  _PuzzlePageState createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  String caption = "";
  String baseImage = "";
  static String prevImage = "";
  List<Widget> unusedPictures;

  @override
  void initState() {
    super.initState();

    var rnd = new Random();
    do {
      var randomIndex = rnd.nextInt(PuzzlePage.puzzlePics.length);
      var path = PuzzlePage.imagesPath;
      var imageType = PuzzlePage.puzzlePics[randomIndex];
      baseImage = "$path$imageType";
    } while (baseImage == prevImage);

    prevImage = baseImage;
    caption = Utils.getPuzzleCaption(baseImage);

    unusedPictures = List.generate(9, (index) {
      return Container(
        decoration: BoxDecoration(border: Border.all()),
        child: Draggable<int>(
          data: index,
          child: Image.asset("$baseImage/$index.png"),
          feedback: SizedBox(
            height: 100,
            width: 100,
            child: Image.asset("$baseImage/$index.png"),
          ),
        ),
      );
    });

    List returnValue = shuffle2(unusedPictures, unusedPictureLocations);
    unusedPictures = returnValue[0];
    unusedPictureLocations = returnValue[1];
  }

  List<String> pictureTexts = List.generate(9, (index) => "");
  List<int> pictureIndexes = List.generate(9, (index) => -1);
  List<int> unusedPictureLocations = List.generate(9, (index) => index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Puzzle'),
        centerTitle: true,
        backgroundColor: Colors.red[800],
      ),
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/fullPics/appBg.png"),
            fit: BoxFit.cover,
          )),
          padding: EdgeInsets.fromLTRB(5, 30, 5, 30),
          child: Builder(
              builder: (context) => Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: AspectRatio(
                            aspectRatio: 3 / 3,
                            child: Center(
                              child: Container(
                                child: GridView.count(
                                  crossAxisCount: 3,
                                  children: List.generate(9, (index) {
                                    return Container(
                                      decoration:
                                          BoxDecoration(border: Border.all()),
                                      child: DragTarget<int>(
                                        onWillAccept: (value) {
                                          return onWillAcceptHandler(
                                              value, index);
                                        },
                                        onAccept: (value) =>
                                            {acceptHandler(value, index)},
                                        builder:
                                            (context, candidates, rejects) {
                                          if (pictureIndexes[index] == -1) {
                                            return Text(pictureTexts[index]);
                                          }

                                          return Draggable<int>(
                                            data: pictureIndexes[index],
                                            child: Image.asset(
                                                pictureTexts[index]),
                                            feedback: SizedBox(
                                              height: 100,
                                              width: 100,
                                              child: Image.asset(
                                                  pictureTexts[index]),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          )),
                      Flexible(
                        child: FractionallySizedBox(
                          heightFactor: 0.6,
                          child: Container(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: unusedPictures,
                                ),
                          )),
                        ),
                      ),
                      Utils.getCaptionWidget(caption),
                    ],
                  ))),
    );
  }

  bool onWillAcceptHandler(value, index) {
    var currentData = pictureIndexes[index];
    var rIndex = unusedPictureLocations.indexOf(value);

    if (currentData != -1 && rIndex != -1) {
      return false;
    }

    return true;
  }

  void acceptHandler(int value, int index) {
    // debugPrint("$value was placed here in $index");
    setState(() {
      var currentData = pictureIndexes[index];

      pictureTexts[index] = "$baseImage/$value.png";

      // Remove the data from the place this was in
      var prevIndex = pictureIndexes.indexOf(value);
      if (prevIndex != -1) {
        // debugPrint("removing $value from $prevIndex");

        // Place the data from the new to the old place
        if (currentData != -1) {
          pictureIndexes[prevIndex] = currentData;
          pictureTexts[prevIndex] = "$baseImage/$currentData.png";
        } else {
          pictureIndexes[prevIndex] = -1;
          pictureTexts[prevIndex] = "";
        }
      }
      pictureIndexes[index] = value;

      // Remove the data from the unused pics
      var rIndex = unusedPictureLocations.indexOf(value);
      if (rIndex != -1) {
        unusedPictureLocations.removeAt(rIndex);
        unusedPictures.removeAt(rIndex);
      }
    });
    // Check win condition
    if (checkWinCondition(pictureIndexes)) {
      winCondition(context);
    }
  }

  bool checkWinCondition(List<int> input) {
    for (var i = 0; i < input.length; i++) {
      if (input[i] != i) {
        return false;
      }
    }
    return true;
  }

  void winCondition(BuildContext context) {
    // set up the button
    Widget nextButton = FlatButton(
      child: Text("Következő"),
      onPressed: () {
        // Pop AlertDialog
        Navigator.pop(context);
        // Restart puzzle page
        Navigator.popAndPushNamed(context, "/randomGame");
      },
    );

    Widget homeButton = FlatButton(
      child: Text("Vissza"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Gratulálok!"),
      content: Text("Megoldottad a feladványt!"),
      actions: [
        homeButton,
        nextButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
