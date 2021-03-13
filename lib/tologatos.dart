import 'package:flutter/material.dart';
import 'dart:math';
import 'utils.dart';

class SliderPage extends StatefulWidget {
  static List<String> puzzlePics = [
    "fruitBasket",
    "carrotPower",
    "fruitCollection",
    "muffin",
    "carrotSmoothie",
    "fruitWarrior"
  ];
  static String imagesPath = "assets/puzzlePics/";

  static var connectedTiles = {
    0: [1, 3],
    1: [0, 2, 4],
    2: [1, 5],
    3: [0, 4, 6],
    4: [1, 3, 5, 7],
    5: [2, 4, 8],
    6: [3, 7],
    7: [4, 6, 8],
    8: [5, 7],
  };

  @override
  _SliderPageState createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  String caption = "";
  String baseImage = "";
  static String prevImage = "";

  List<Widget> pictures;
  List<int> pictureIndexes = List.generate(9, (index) {
    return index;
  });

  Widget emptyContainer = Container(
    decoration: BoxDecoration(border: Border.all()),
    child: SizedBox(
      height: 100,
      width: 100,
      child: Text(""),
    ),
  );

  @override
  void initState() {
    super.initState();

    var rnd = new Random();
    do {
      var randomIndex = rnd.nextInt(SliderPage.puzzlePics.length);
      var path = SliderPage.imagesPath;
      var imageType = SliderPage.puzzlePics[randomIndex];
      baseImage = "$path$imageType";
    } while (baseImage == prevImage);

    prevImage = baseImage;
    caption = Utils.getPuzzleCaption(baseImage);

    pictures = List.generate(9, (index) {
      if (index != 6) {
        return Container(
          decoration: BoxDecoration(border: Border.all()),
          child: SizedBox(
            height: 100,
            width: 100,
            child: Image.asset("$baseImage/$index.png"),
          ),
        );
      }

      return emptyContainer;
    });

    List returnValue = shuffle8puzzle(pictures, pictureIndexes);
    pictures = returnValue[0];
    pictureIndexes = returnValue[1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tili-toli'),
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
                      Flexible(
                        child: FractionallySizedBox(
                            heightFactor: 0.73,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Center(
                                child: Container(
                                  child: GridView.count(
                                    crossAxisCount: 3,
                                    children: List.generate(9, (index) {
                                      return Container(
                                          decoration: BoxDecoration(
                                              border: Border.all()),
                                          child: GestureDetector(
                                            onTap: () {
                                              if (pictureIndexes[index] == -1)
                                                return;
                                              var vI = pictureIndexes[index];
                                              pressHandler(index, vI, context);
                                            },
                                            child: pictures[index],
                                          ));
                                    }),
                                  ),
                                ),
                              ),
                            )),
                      ),
                      Utils.getCaptionWidget(caption),
                    ],
                  ))),
    );
  }

  void pressHandler(int pressedOn, int pressedValue, BuildContext context) {
    int noneLocation = pictureIndexes.indexOf(6);
    var connectedTiles = SliderPage.connectedTiles[pressedOn];
    if (connectedTiles.indexOf(noneLocation) == -1) return;

    int moveToIndex = noneLocation;

    setState(() {
      pictures[moveToIndex] = pictures[pressedOn];
      pictures[pressedOn] = emptyContainer;

      pictureIndexes[moveToIndex] = pictureIndexes[pressedOn];
      pictureIndexes[pressedOn] = 6;
    });

    if (checkWin()) {
      winCondition(context);
    }
  }

  bool checkWin() {
    var winList = [0, 1, 2, 3, 4, 5, 6, 7, 8];
    bool didWin = true;
    for (int i = 0; i < pictureIndexes.length; i++) {
      if (winList[i] != pictureIndexes[i]) {
        didWin = false;
        break;
      }
    }
    return didWin;
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

  List shuffle8puzzle(List pics, List picIndexes) {
    Random rnd = new Random();
    int numOfMoves = (rnd.nextInt(6) + 10) * 2;

    for (int i = 0; i < numOfMoves; i++) {
      int minusOneLoc = picIndexes.indexOf(6);
      int rndIndex = rnd.nextInt(SliderPage.connectedTiles[minusOneLoc].length);
      int toMove = SliderPage.connectedTiles[minusOneLoc][rndIndex];

      pics[minusOneLoc] = pics[toMove];
      pics[toMove] = emptyContainer;

      picIndexes[minusOneLoc] = picIndexes[toMove];
      picIndexes[toMove] = 6;
    }

    return [pics, picIndexes];
  }
}
