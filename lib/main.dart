import 'package:flutter/material.dart';

void main() {
  runApp(LogoQuizApp());
}

class LogoQuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Logo Quiz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LogoQuizScreen(),
    );
  }
}

class LogoQuizScreen extends StatefulWidget {
  @override
  _LogoQuizScreenState createState() => _LogoQuizScreenState();
}

class _LogoQuizScreenState extends State<LogoQuizScreen> {
  String enteredLetters = '';
  String e = '';
  List<String> brands = [
    "cat",
    "dog",
    "wolf",
    // Add more brands as needed
  ];

  int currentQuestionIndex = 0;
  TextEditingController answerController = TextEditingController();

  void addLetter(String letter) {
    setState(() {
      if (enteredLetters.length < brands.length) {
        answerController.text += letter;
      }
    });
  }

  void _updateTextField(String text) {
    setState(() {
      answerController.text += text;
    });
  }

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/${brands[currentQuestionIndex].toLowerCase()}.jpeg',
                    width: 250,
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Wrap(
                spacing: 1.0,
                children: <Widget>[
                  for (var i = 0; i < brands.length; i++)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: enteredLetters.length > i
                            ? TextField(
                                controller: answerController,

                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.red),
                                // child: Text(
                                //   enteredLetters[i],
                                //   style: TextStyle(fontSize: 20.0),
                                // ),
                              )
                            : null,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20.0),
              Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var letter in 'abcdefgh'.split(''))
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                e = answerController.text;
                              });
                              addLetter(letter);
                            },
                            child: Text(
                              letter,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape:
                                  CircleBorder(), // Makes the button circular
                              padding: EdgeInsets.all(
                                  10), // Adjust padding as needed
                              primary: Colors.blue, // Button color
                            ),
                          ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 33),
                      child: Row(
                        children: [
                          for (var letter in 'ijklmnop'.split(''))
                            ElevatedButton(
                              onPressed: () {
                                addLetter(letter);
                              },
                              child: Text(
                                letter,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                              style: ElevatedButton.styleFrom(
                                shape:
                                    CircleBorder(), // Makes the button circular
                                padding: EdgeInsets.all(
                                    10), // Adjust padding as needed
                                primary: Colors.blue, // Button color
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var letter in 'qrstuvwxyz'.split(''))
                          ElevatedButton(
                            onPressed: () {
                              addLetter(letter);
                            },
                            child: Text(
                              letter,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape:
                                  CircleBorder(), // Makes the button circular
                              padding: EdgeInsets.all(
                                  10), // Adjust padding as needed
                              primary: Colors.blue, // Button color
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                'Number of letters entered: ${enteredLetters.length} / ${brands.length}',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
