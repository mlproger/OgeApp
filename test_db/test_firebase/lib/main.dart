import 'dart:math';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_event.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_to_text_provider.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:test_firebase/screens/economy.dart';
import 'package:test_firebase/screens/politic.dart';
import 'package:test_firebase/screens/screen_login.dart';
import 'package:test_firebase/screens/socium.dart';
import 'package:test_firebase/screens/soul.dart';
import 'package:test_firebase/screens/sreen_recognize.dart';
import 'package:test_firebase/servicies/check.dart';
import 'package:test_firebase/servicies/crud.dart';

import 'models/speech_recognize_model.dart';
import 'models/termins_model.dart';

List<Termin> politicsData = [];
List<Termin> economyData = [];
List<Termin> sociumData = [];
List<Termin> soulData = [];

int politicIndex = 0;

int economyIndex = 0;

int sociumIndex = 0;

int soulIndex = 0;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _setUp();
    super.initState();
  }

  void _setUp() async {
    politicsData = await CrudMethods().getData('politics_termins');
    economyData = await CrudMethods().getData('economy_termins');
    sociumData = await CrudMethods().getData('socium_termins');
    soulData = await CrudMethods().getData('soul_termins');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ОГЕ.APP',
      theme: ThemeData(),
      home: AnimatedSplashScreen(
          splashIconSize: 1500,
          duration: 1000,
          splash: const Image(
            image: AssetImage('img/oge.png'),
            width: 2000,
            height: 2000,
          ),
          nextScreen: const MainCheck(),
          backgroundColor: const Color.fromRGBO(23, 28, 38, 1)),
      routes: {
        '/main': (BuildContext context) => const MainWidget(),
        '/login': (BuildContext context) => const LoginScreen(),
        '/politic_t': (BuildContext context) => DataItherited(
              child: PoliticScreen(),
              index: politicIndex,
            ),
        '/economy_t': (BuildContext context) => DataItherited(
              child: EconomyScreen(),
              index: economyIndex,
            ),
        '/soul_t': (BuildContext context) => DataItherited(
              child: SoulScreen(),
              index: soulIndex,
            ),
        '/socuim_t': (BuildContext context) => DataItherited(
              child: SociumScreen(),
              index: sociumIndex,
            ),
      },
    );
  }
}

class MainWidget extends StatefulWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  var user = FirebaseAuth.instance.currentUser!;
  final SpeechToText speech = SpeechToText();
  late SpeechToTextProvider speechProvider;

  Future<void> initSpeechState() async {
    await speechProvider.initialize();
  }

  @override
  void initState() {
    super.initState();
    speechProvider = SpeechToTextProvider(speech);
    initSpeechState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(23, 28, 38, 1),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  SizedBox(
                    height: 20,
                  ),
                  _ContainerImage(
                      imgSrc: 'img/politic.jpg', routeName: '/politic_t'),
                  SizedBox(
                    height: 10,
                  ),
                  _ContainerImage(
                      imgSrc: 'img/economy.jpg', routeName: '/economy_t'),
                  SizedBox(
                    height: 10,
                  ),
                  _ContainerImage(
                      imgSrc: 'img/socium.jpg', routeName: '/socuim_t'),
                  SizedBox(
                    height: 10,
                  ),
                  _ContainerImage(imgSrc: 'img/soul.png', routeName: '/soul_t'),
                  SizedBox(
                    height: 20,
                  ),
                ]),
          ),
        ));
  }
}

class PoliticScreen extends StatefulWidget {
  PoliticScreen({Key? key}) : super(key: key);

  @override
  State<PoliticScreen> createState() => _PoliticScreenState();
}

class _PoliticScreenState extends State<PoliticScreen> {
  final SpeechToText speech = SpeechToText();
  late SpeechToTextProvider speechProvider;
  @override
  void initState() {
    super.initState();
    speechProvider = SpeechToTextProvider(speech);
    initSpeechState();
  }

  void result(int mar, double procentOfCorrectAnswer, BuildContext context) {
    if (mar <= 3) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.WARNING,
        animType: AnimType.SCALE,
        btnCancelText: 'Повторить термин',
        btnCancelColor: Colors.blue,
        btnOkText: 'Попробовать еще раз',
        btnCancelOnPress: () {
          CoolAlert.show(
              context: context,
              type: CoolAlertType.info,
              title:
                  "${politicsData[context.dependOnInheritedWidgetOfExactType<DataItherited>()!.index].word} ",
              text: politicsData[context
                      .dependOnInheritedWidgetOfExactType<DataItherited>()!
                      .index]
                  .descriptions);
        },
        btnOkOnPress: () {},
        title:
            "Вам следует повторить, что такое ${politicsData[context.dependOnInheritedWidgetOfExactType<DataItherited>()!.index].word}",
        desc:
            "Ваша оценка - 2\nПроцент знания термина - ${(procentOfCorrectAnswer * 100).ceil()}",
      ).show();
    }
    if (mar == 4) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.SCALE,
        btnOkText: 'Учиться дальше',
        btnCancelText: 'Повторить термин',
        btnOkOnPress: () {
          context.dependOnInheritedWidgetOfExactType<DataItherited>()!.index =
              Random().nextInt(politicsData.length);
        },
        btnCancelOnPress: () async {
          CoolAlert.show(
              context: context,
              type: CoolAlertType.info,
              title:
                  "${politicsData[context.dependOnInheritedWidgetOfExactType<DataItherited>()!.index].word} ",
              text: politicsData[context
                      .dependOnInheritedWidgetOfExactType<DataItherited>()!
                      .index]
                  .descriptions);
        },
        title: "Возиожно, стоит закрепить знания",
        desc:
            "Ваша оценка - $mar\nПроцент знания термина - ${(procentOfCorrectAnswer * 100).ceil()}",
      ).show();
    }
    if (mar == 5) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.SCALE,
        btnOkText: 'Учиться дальше',
        btnOkOnPress: () {
          context.dependOnInheritedWidgetOfExactType<DataItherited>()!.index =
              Random().nextInt(politicsData.length);
        },
        title: "Так держать, всё верно!",
        desc:
            "Ваша оценка - $mar\nПроцент знания термина - ${(procentOfCorrectAnswer * 100).ceil()}",
      ).show();
    }
  }

  Future<void> initSpeechState() async {
    await speechProvider.initialize();
    var subscription = speechProvider.stream.listen(
        (recognitionEvent) {
          print(recognitionEvent.eventType);
          if (recognitionEvent.eventType ==
              SpeechRecognitionEventType.partialRecognitionEvent) {
            // showDialog(
            //     context: context,
            //     builder: (BuildContext contex) {
            //       return Text('1');
            //     });
          }
          if (recognitionEvent.eventType ==
              SpeechRecognitionEventType.finalRecognitionEvent) {
            var procentOfCorrectAnswer = speechProvider
                .lastResult!.recognizedWords
                .toUpperCase()
                .similarityTo(politicsData[context
                        .dependOnInheritedWidgetOfExactType<DataItherited>()!
                        .index]
                    .descriptions
                    .toUpperCase());
            int mar = ((procentOfCorrectAnswer * 100).ceil() / 20).round();
            result(mar, procentOfCorrectAnswer, context);
          }
        },
        onDone: () {},
        onError: (val) {
          print("subscription: onError called val = $val");
        });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: speechProvider,
      child: Politic(
        index: politicIndex,
        data: politicsData,
        name: 'Политика',
        collectionsName: 'politics_termins',
      ),
    );
  }
}

class SoulScreen extends StatefulWidget {
  SoulScreen({Key? key}) : super(key: key);

  @override
  State<SoulScreen> createState() => _SoulScreenState();
}

class _SoulScreenState extends State<SoulScreen> {
  final SpeechToText speech = SpeechToText();
  late SpeechToTextProvider speechProvider;

  @override
  void initState() {
    super.initState();
    speechProvider = SpeechToTextProvider(speech);
    initSpeechState();
  }

  void result(int mar, double procentOfCorrectAnswer, BuildContext context) {
    if (mar <= 3) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.WARNING,
        animType: AnimType.SCALE,
        btnCancelText: 'Повторить термин',
        btnCancelColor: Colors.blue,
        btnOkText: 'Попробовать еще раз',
        btnCancelOnPress: () {
          CoolAlert.show(
              context: context,
              type: CoolAlertType.info,
              title:
                  "${soulData[context.dependOnInheritedWidgetOfExactType<DataItherited>()!.index].word} ",
              text: soulData[context
                      .dependOnInheritedWidgetOfExactType<DataItherited>()!
                      .index]
                  .descriptions);
        },
        btnOkOnPress: () {},
        title:
            "Вам следует повторить, что такое ${soulData[context.dependOnInheritedWidgetOfExactType<DataItherited>()!.index].word}",
        desc:
            "Ваша оценка - 2\nПроцент знания термина - ${(procentOfCorrectAnswer * 100).ceil()}",
      ).show();
    }
    if (mar == 4) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.SCALE,
        btnOkText: 'Учиться дальше',
        btnCancelText: 'Повторить термин',
        btnOkOnPress: () {
          context.dependOnInheritedWidgetOfExactType<DataItherited>()!.index =
              Random().nextInt(soulData.length);
        },
        btnCancelOnPress: () async {
          CoolAlert.show(
              context: context,
              type: CoolAlertType.info,
              title:
                  "${soulData[context.dependOnInheritedWidgetOfExactType<DataItherited>()!.index].word} ",
              text: soulData[context
                      .dependOnInheritedWidgetOfExactType<DataItherited>()!
                      .index]
                  .descriptions);
        },
        title: "Возиожно, стоит закрепить знания",
        desc:
            "Ваша оценка - $mar\nПроцент знания термина - ${(procentOfCorrectAnswer * 100).ceil()}",
      ).show();
    }
    if (mar == 5) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.SCALE,
        btnOkText: 'Учиться дальше',
        btnOkOnPress: () {
          context.dependOnInheritedWidgetOfExactType<DataItherited>()!.index =
              Random().nextInt(soulData.length);
        },
        title: "Так держать, всё верно!",
        desc:
            "Ваша оценка - $mar\nПроцент знания термина - ${(procentOfCorrectAnswer * 100).ceil()}",
      ).show();
    }
  }

  Future<void> initSpeechState() async {
    await speechProvider.initialize();
    var subscription = speechProvider.stream.listen(
        (recognitionEvent) {
          if (recognitionEvent.eventType ==
              SpeechRecognitionEventType.finalRecognitionEvent) {
            var procentOfCorrectAnswer = speechProvider
                .lastResult!.recognizedWords
                .toUpperCase()
                .similarityTo(soulData[context
                        .dependOnInheritedWidgetOfExactType<DataItherited>()!
                        .index]
                    .descriptions
                    .toUpperCase());
            int mar = ((procentOfCorrectAnswer * 100).ceil() / 20).round();
            result(mar, procentOfCorrectAnswer, context);
          }
        },
        onDone: () {},
        onError: (val) {
          print("subscription: onError called val = $val");
        });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: speechProvider,
      child: Soul(
        index: soulIndex,
        data: soulData,
        name: 'Духовная сфера',
        collectionsName: 'soul_termins',
      ),
    );
  }
}

class EconomyScreen extends StatefulWidget {
  EconomyScreen({Key? key}) : super(key: key);

  @override
  State<EconomyScreen> createState() => _EconomyScreenState();
}

class _EconomyScreenState extends State<EconomyScreen> {
  final SpeechToText speech = SpeechToText();
  late SpeechToTextProvider speechProvider;
  @override
  void initState() {
    super.initState();
    speechProvider = SpeechToTextProvider(speech);
    initSpeechState();
  }

  void result(int mar, double procentOfCorrectAnswer, BuildContext context) {
    if (mar <= 3) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.WARNING,
        animType: AnimType.SCALE,
        btnCancelText: 'Повторить термин',
        btnCancelColor: Colors.blue,
        btnOkText: 'Попробовать еще раз',
        btnCancelOnPress: () {
          CoolAlert.show(
              context: context,
              type: CoolAlertType.info,
              title:
                  "${economyData[context.dependOnInheritedWidgetOfExactType<DataItherited>()!.index].word} ",
              text: economyData[context
                      .dependOnInheritedWidgetOfExactType<DataItherited>()!
                      .index]
                  .descriptions);
        },
        btnOkOnPress: () {},
        title:
            "Вам следует повторить, что такое ${economyData[context.dependOnInheritedWidgetOfExactType<DataItherited>()!.index].word}",
        desc:
            "Ваша оценка - 2\nПроцент знания термина - ${(procentOfCorrectAnswer * 100).ceil()}",
      ).show();
    }
    if (mar == 4) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.SCALE,
        btnOkText: 'Учиться дальше',
        btnCancelText: 'Повторить термин',
        btnOkOnPress: () {
          context.dependOnInheritedWidgetOfExactType<DataItherited>()!.index =
              Random().nextInt(economyData.length);
        },
        btnCancelOnPress: () async {
          CoolAlert.show(
              context: context,
              type: CoolAlertType.info,
              title:
                  "${economyData[context.dependOnInheritedWidgetOfExactType<DataItherited>()!.index].word} ",
              text: economyData[context
                      .dependOnInheritedWidgetOfExactType<DataItherited>()!
                      .index]
                  .descriptions);
        },
        title: "Возиожно, стоит закрепить знания",
        desc:
            "Ваша оценка - $mar\nПроцент знания термина - ${(procentOfCorrectAnswer * 100).ceil()}",
      ).show();
    }
    if (mar == 5) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.SCALE,
        btnOkText: 'Учиться дальше',
        btnOkOnPress: () {
          context.dependOnInheritedWidgetOfExactType<DataItherited>()!.index =
              Random().nextInt(economyData.length);
        },
        title: "Так держать, всё верно!",
        desc:
            "Ваша оценка - $mar\nПроцент знания термина - ${(procentOfCorrectAnswer * 100).ceil()}",
      ).show();
    }
  }

  Future<void> initSpeechState() async {
    await speechProvider.initialize();
    var subscription = speechProvider.stream.listen(
        (recognitionEvent) {
          print(recognitionEvent.eventType);
          if (recognitionEvent.eventType ==
              SpeechRecognitionEventType.partialRecognitionEvent) {
            // showDialog(
            //     context: context,
            //     builder: (BuildContext contex) {
            //       return Text('1');
            //     });
          }
          if (recognitionEvent.eventType ==
              SpeechRecognitionEventType.finalRecognitionEvent) {
            var procentOfCorrectAnswer = speechProvider
                .lastResult!.recognizedWords
                .toUpperCase()
                .similarityTo(economyData[context
                        .dependOnInheritedWidgetOfExactType<DataItherited>()!
                        .index]
                    .descriptions
                    .toUpperCase());
            int mar = ((procentOfCorrectAnswer * 100).ceil() / 20).round();
            result(mar, procentOfCorrectAnswer, context);
          }
        },
        onDone: () {},
        onError: (val) {
          print("subscription: onError called val = $val");
        });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: speechProvider,
      child: Economy(
        data: economyData,
        name: 'Экономика',
        collectionsName: 'economy_termins',
        index: economyIndex,
      ),
    );
  }
}

class SociumScreen extends StatefulWidget {
  SociumScreen({Key? key}) : super(key: key);

  @override
  State<SociumScreen> createState() => _SociumScreenState();
}

class _SociumScreenState extends State<SociumScreen> {
  final SpeechToText speech = SpeechToText();
  late SpeechToTextProvider speechProvider;
  @override
  void initState() {
    super.initState();
    speechProvider = SpeechToTextProvider(speech);
    initSpeechState();
  }

  void result(int mar, double procentOfCorrectAnswer, BuildContext context) {
    if (mar <= 3) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.WARNING,
        animType: AnimType.SCALE,
        btnCancelText: 'Повторить термин',
        btnCancelColor: Colors.blue,
        btnOkText: 'Попробовать еще раз',
        btnCancelOnPress: () {
          CoolAlert.show(
              context: context,
              type: CoolAlertType.info,
              title:
                  "${sociumData[context.dependOnInheritedWidgetOfExactType<DataItherited>()!.index].word} ",
              text: sociumData[context
                      .dependOnInheritedWidgetOfExactType<DataItherited>()!
                      .index]
                  .descriptions);
        },
        btnOkOnPress: () {},
        title:
            "Вам следует повторить, что такое ${sociumData[context.dependOnInheritedWidgetOfExactType<DataItherited>()!.index].word}",
        desc:
            "Ваша оценка - 2\nПроцент знания термина - ${(procentOfCorrectAnswer * 100).ceil()}",
      ).show();
    }
    if (mar == 4) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.SCALE,
        btnOkText: 'Учиться дальше',
        btnCancelText: 'Повторить термин',
        btnOkOnPress: () {
          context.dependOnInheritedWidgetOfExactType<DataItherited>()!.index =
              Random().nextInt(sociumData.length);
        },
        btnCancelOnPress: () async {
          CoolAlert.show(
              context: context,
              type: CoolAlertType.info,
              title:
                  "${sociumData[context.dependOnInheritedWidgetOfExactType<DataItherited>()!.index].word} ",
              text: sociumData[context
                      .dependOnInheritedWidgetOfExactType<DataItherited>()!
                      .index]
                  .descriptions);
        },
        title: "Возиожно, стоит закрепить знания",
        desc:
            "Ваша оценка - $mar\nПроцент знания термина - ${(procentOfCorrectAnswer * 100).ceil()}",
      ).show();
    }
    if (mar == 5) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.SCALE,
        btnOkText: 'Учиться дальше',
        btnOkOnPress: () {
          context.dependOnInheritedWidgetOfExactType<DataItherited>()!.index =
              Random().nextInt(sociumData.length);
        },
        title: "Так держать, всё верно!",
        desc:
            "Ваша оценка - $mar\nПроцент знания термина - ${(procentOfCorrectAnswer * 100).ceil()}",
      ).show();
    }
  }

  Future<void> initSpeechState() async {
    await speechProvider.initialize();
    var subscription = speechProvider.stream.listen(
        (recognitionEvent) {
          if (recognitionEvent.eventType ==
              SpeechRecognitionEventType.finalRecognitionEvent) {
            if (speechProvider.lastResult?.recognizedWords == null) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.ERROR,
                animType: AnimType.SCALE,
                btnOkText: 'Хорошо',
                title: "Что-то пошло не так(",
                desc:
                    "Проверьте, разрешён ли доступ к микрофну, либо скажите чётче",
              ).show();
            } else {
              var procentOfCorrectAnswer = speechProvider
                  .lastResult!.recognizedWords
                  .toUpperCase()
                  .similarityTo(sociumData[context
                          .dependOnInheritedWidgetOfExactType<DataItherited>()!
                          .index]
                      .descriptions
                      .toUpperCase());
              int mar = ((procentOfCorrectAnswer * 100).ceil() / 20).round();
              result(mar, procentOfCorrectAnswer, context);
            }
          }
        },
        onDone: () {},
        onError: (val) {
          print("subscription: onError called val = $val");
        });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: speechProvider,
      child: Socium(
        index: sociumIndex,
        data: sociumData,
        name: 'Социальная сфера',
        collectionsName: 'socium_termins',
      ),
    );
  }
}

class _ContainerImage extends StatelessWidget {
  final String imgSrc;
  final String routeName;
  const _ContainerImage(
      {Key? key, required this.imgSrc, required this.routeName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, routeName);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image:
                DecorationImage(image: AssetImage(imgSrc), fit: BoxFit.cover)),
        width: MediaQuery.of(context).size.width - 50,
        height: MediaQuery.of(context).size.height / 4 - 30,
      ),
    );
  }
}

class DataItherited extends InheritedWidget {
  int index;
  DataItherited({Key? key, required child, required this.index})
      : super(key: key, child: child);

  static DataItherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DataItherited>();
  }

  @override
  bool updateShouldNotify(DataItherited oldWidget) {
    return index != oldWidget.index;
  }
}
