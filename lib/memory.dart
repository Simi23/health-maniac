import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'utils.dart';

class MemoryPage extends StatefulWidget {
  static var pictureList = [
    "assets/fullPics/carrotPower.jpg",
    "assets/fullPics/carrotSmoothie.jpg",
    "assets/fullPics/fruitBasket.jpg",
    "assets/fullPics/fruitCollection.jpg",
    "assets/fullPics/fruitWarrior.jpg",
    "assets/fullPics/muffin.jpg",
  ];

  @override
  _MemoryPageState createState() => _MemoryPageState();
}

class _MemoryPageState extends State<MemoryPage> {
  static String coverPath = "assets/fullPics/cardCover.png";
  static String caption = "";

  int activatedOther = -1;
  bool actionEnabled = false;
  List<String> pictures = List.generate(12, (index) {
    if (index >= 6) {
      return MemoryPage.pictureList[index - 6];
    }

    return MemoryPage.pictureList[index];
  });
  List<int> pictureIndexes = List.generate(12, (index) {
    if (index >= 6) {
      return index - 6;
    }

    return index;
  });
  List<bool> showCard = List.generate(12, (index) => false);

  @override
  void initState() {
    var shuffleAnswer = shuffle2(pictures, pictureIndexes);
    pictures = shuffleAnswer[0];
    pictureIndexes = shuffleAnswer[1];

    caption = Utils.getRandomCaption();

    Timer(Duration(seconds: 5), () {
      setState(() {
        showCard = List.generate(12, (index) => true);
        pictures = List.generate(12, (index) => coverPath);
        actionEnabled = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memóriakártya'),
        centerTitle: true,
        backgroundColor: Colors.red[800],
      ),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/fullPics/appBg.png"),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.fromLTRB(5, 30, 5, 30),
          child: Builder(
              builder: (context) => Column(
                    children: [
                      Flexible(
                          child: FractionallySizedBox(
                              heightFactor: 0.75,
                              child: AspectRatio(
                                aspectRatio: 3 / 4,
                                child: Center(
                                  child: Container(
                                    child: GridView.count(
                                      crossAxisCount: 3,
                                      children: List.generate(12, (index) {
                                        return createCardWidget(index, context);
                                      }),
                                    ),
                                  ),
                                ),
                              ))),
                      Utils.getCaptionWidget(caption),
                    ],
                  ))),
    );
  }

  Widget createCardWidget(int index, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      child: GestureDetector(
        onTap: () {
          if (!actionEnabled) return;

          if (showCard[index]) {
            setState(() {
              if (activatedOther == -1)
                activatedOther = index;
              else {
                int thisType = pictureIndexes[index];
                int prevType = pictureIndexes[activatedOther];

                if (thisType == prevType) {
                  activatedOther = -1;
                } else {
                  actionEnabled = false;
                  Timer(Duration(seconds: 1), () {
                    setState(() {
                      showCard[index] = true;
                      pictures[index] = coverPath;

                      showCard[activatedOther] = true;
                      pictures[activatedOther] = coverPath;

                      actionEnabled = true;
                      activatedOther = -1;
                    });
                  });
                }
              }

              showCard[index] = false;
              var pic = MemoryPage.pictureList[pictureIndexes[index]];
              pictures[index] = pic;
            });

            if (checkWinCondition()) winCondition(context);
          }
        },
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 250),
          transitionBuilder: (child, animation) {
            return RotationTransition(turns: animation, child: child);
          },
          child: Image.asset(
            pictures[index],
            key: ValueKey(pictures[index]),
          ),
        ),
      ),
    );
  }

  bool checkWinCondition() {
    for (int i = 0; i < showCard.length; i++) {
      if (showCard[i] == true) return false;
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
