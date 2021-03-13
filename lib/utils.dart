import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

List shuffle(List items) {
  var random = new Random();

  // Go through all elements.
  for (var i = items.length - 1; i > 0; i--) {
    // Pick a pseudorandom number according to the list length
    var n = random.nextInt(i + 1);

    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }

  return items;
}

List shuffle2(List items, List items2) {
  var random = new Random();

  // Go through all elements.
  for (var i = items.length - 1; i > 0; i--) {
    // Pick a pseudorandom number according to the list length
    var n = random.nextInt(i + 1);

    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;

    var temp2 = items2[i];
    items2[i] = items2[n];
    items2[n] = temp2;
  }

  return [items, items2];
}

class Utils {
  static Random rnd = new Random();
  static var captionCollection = {
    "assets/puzzlePics/fruitBasket":
        "A gyümölcsök köztudottan számos pozitív hatással vannak a szervezetre, és fontos, hogy minden nap minimum 400-500 gramm zöldséget vagy gyümölcsöt fogyasszunk.",
    "assets/puzzlePics/carrotPower":
        "A répának magas a béta-karotin tartalma, amit a szervezetünk A-vitaminná alakít át, ami elengedhetetlen a tökéletes látáshoz.",
    "assets/puzzlePics/fruitCollection":
        "A gyümölcsök köztudottan számos pozitív hatással vannak a szervezetre, és fontos, hogy minden nap minimum 400-500 gramm zöldséget vagy gyümölcsöt fogyasszunk.",
    "assets/puzzlePics/muffin":
        "Az édességek fogyasztása nem ellenjavallt, de fontos, hogy ezt megfelelően és mértékletesen tegyük.",
    "assets/puzzlePics/carrotSmoothie":
        "A gyümölcs- és zöldségalapú italok, keverékek tele vannak értékes növényi anyagokkal, vitaminokkal, ráadásul koncentráltan tartalmazzák ezeket.",
    "assets/puzzlePics/fruitWarrior":
        "Tudtad, hogy az alma, a barack és a málna a rózsafélék családjába tartoznak?",
  };

  static String getPuzzleCaption(String image) {
    return captionCollection[image];
  }

  static String getRandomCaption() {
    var intKey = rnd.nextInt(captionCollection.keys.length);
    var randomKey = captionCollection.keys.toList()[intKey];
    return captionCollection[randomKey];
  }

  static Widget getCaptionWidget(String caption) {
    return Padding(
        padding: EdgeInsets.fromLTRB(5, 40, 5, 0),
        child: Text(
          caption,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(blurRadius: 15, color: Colors.white)]),
          textAlign: TextAlign.center,
        ));
  }
}
