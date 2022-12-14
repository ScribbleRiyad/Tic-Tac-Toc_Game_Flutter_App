import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:game/ui/theme/color.dart';
import 'package:game/util/game_logic.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late ConfettiController _controllerCenter;

  //adding the necessary variables
  String lastValue = "X";

  bool gameOver = false;

  int turn = 0;
  // to check the draw
  String result = "";

  List<int> scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];
  //the score are for the different combination of the game [Row1,2,3, Col1,2,3, Diagonal1,2];
  Game game = Game();

  //let's initi the GameBoard
  @override
  void initState() {
    super.initState();
    game.board = Game.initGameBoard();
    _controllerCenter = ConfettiController();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double boardWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
              backgroundColor: MainColor.primaryColor,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: ConfettiWidget(
                      confettiController: _controllerCenter,
                      blastDirectionality: BlastDirectionality.explosive,
                      blastDirection: pi / 2,

                      emissionFrequency: 0.1,
                      numberOfParticles: 10, // a lot of particles at once
                      gravity: 0.1, // don't specify a direction, blast randomly
                      shouldLoop: true,
                      // start again as soon as the animation is finished
                    ),
                  ),
                  const SizedBox(
                    height: 40.00,
                  ),
                  Text(
                    "It's $lastValue turn".toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  //now we will make the game board
                  //but first we will create a Game class that will contains all the data and method that we will need
                  SizedBox(
                    width: boardWidth,
                    height: boardWidth,
                    child: GridView.count(
                      crossAxisCount: Game.boardlenth ~/
                          3, // the ~/ operator allows you to evide to integer and return an Int as a result
                      padding: const EdgeInsets.all(16.0),
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      children: List.generate(Game.boardlenth, (index) {
                        return InkWell(
                          onTap: gameOver
                              ? null
                              : () {
                                  //when we click we need to add the new value to the board and refrech the screen
                                  //we need also to toggle the player
                                  //now we need to apply the click only if the field is empty
                                  //now let's create a button to repeat the game

                                  if (game.board![index] == "") {
                                    setState(() {
                                      game.board![index] = lastValue;
                                      turn++;
                                      gameOver = game.winnerCheck(
                                          lastValue, index, scoreboard, 3);

                                      if (gameOver) {
                                        result = "$lastValue is the Winner";
                                        _controllerCenter.play();
                                      } else if (!gameOver && turn == 9) {
                                        result = "It's a Draw!";
                                        gameOver = true;
                                      }
                                      if (lastValue == "X") {
                                        lastValue = "O";
                                      } else {
                                        lastValue = "X";
                                      }
                                    });
                                  }
                                },
                          child: Container(
                            width: Game.blocSize,
                            height: Game.blocSize,
                            decoration: BoxDecoration(
                              color: MainColor.secondaryColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Text(
                                game.board![index],
                                style: TextStyle(
                                  color: game.board![index] == "X"
                                      ? Colors.blue
                                      : Colors.pink,
                                  fontSize: 54.0,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Text(
                    result,
                    style: const TextStyle(
                        color: Colors.cyanAccent, fontSize: 40.0),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        //erase the board
                        game.board = Game.initGameBoard();
                        lastValue = "X";
                        gameOver = false;
                        turn = 0;
                        result = "";
                        scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];
                        _controllerCenter.stop();
                      });
                    },
                    icon: const Icon(Icons.replay),
                    label: const Text("Play New Game"),
                  ),
                ],
              )),
        ],
      ),
    );
    //the first step is organise our project folder structure
  }
}
