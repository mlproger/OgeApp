import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_event.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text_provider.dart';
import 'package:test_firebase/main.dart';
import 'package:test_firebase/models/termins_model.dart';
import 'package:test_firebase/screens/sreen_recognize.dart';
import 'package:test_firebase/servicies/crud.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:test_firebase/main.dart';

import '../models/speech_recognize_model.dart';

class Economy extends StatefulWidget {
  List<Termin> data;
  String name;
  int index;
  String collectionsName;
  Economy(
      {Key? key,
      required this.data,
      required this.name,
      required this.collectionsName, required this.index})
      : super(key: key);

  @override
  State<Economy> createState() => _EconomyScreenState();
}

class _EconomyScreenState extends State<Economy> {
  final wordController = TextEditingController();
  final desController = TextEditingController();
  String text = 'Нажмите на микрофон, чтобы дать определение';
  bool isListening = false;
  double procentOfCorrectAnswer = 0;

  @override
  Widget build(BuildContext context) {
    int index =
        context.dependOnInheritedWidgetOfExactType<DataItherited>()!.index;
    var speechProvider = Provider.of<SpeechToTextProvider>(context);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(23, 28, 38, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(23, 28, 38, 1),
        title: Text(widget.name),
        leading: GestureDetector(
          onTap: () async {
            {
              Navigator.pushNamed(context, '/main');
              // _speechProvider.stop();
              // _speechProvider.cancel();
              // _speechProvider.removeListener(() {});
              // await _speechProvider.stream.length.then(
              //   (value) => print(value),
              // );
              // print(_speechProvider.stream.length);
              // //speechProvider.dispose();
              super.deactivate();
            }
          },
          child: const Icon(Icons.navigate_before),
        ),
      ),
      endDrawer: Drawer(
          backgroundColor: const Color.fromRGBO(23, 28, 38, 1),
          child: ListView.builder(
              itemCount: economyData.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  title: GestureDetector(
                      onTap: () {
                        CoolAlert.show(
                            backgroundColor:
                                const Color.fromRGBO(23, 28, 38, 1),
                            context: context,
                            type: CoolAlertType.info,
                            title: economyData[index].word,
                            text: economyData[index].descriptions);
                      },
                      child: Text(
                        economyData[index].word,
                        style: TextStyle(color: Colors.white),
                      )),
                );
              }))),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                '${widget.data[context.dependOnInheritedWidgetOfExactType<DataItherited>()!.index].word} ЭТО... \n ',
                maxLines: 2,
                textAlign: TextAlign.center,
                style:
                    GoogleFonts.alumniSans(fontSize: 35, color: Colors.white),
                minFontSize: 35,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(speechProvider.lastResult?.recognizedWords ?? text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.alumniSans(
                      fontSize: 25, color: Colors.white)),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(255, 182, 71, 1),
        onPressed: () {
          if (speechProvider.isAvailable) {
            speechProvider.listen();
          } else {
            speechProvider.stop();
          }
        },
        tooltip: 'Listen',
        child: Icon(speechProvider.isListening ? Icons.mic : Icons.mic_off),
      ),
      persistentFooterButtons: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  minimumSize: const Size(50, 50),
                  primary: const Color.fromRGBO(0, 153, 204, 1)),
              onPressed: () {
                if (widget.index > 0) {
                  widget.index -= 1;
                  context
                      .dependOnInheritedWidgetOfExactType<DataItherited>()!
                      .index -= 1;
                  setState(() {});
                }
              },
              child: const Icon(Icons.navigate_before)),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  minimumSize: const Size(50, 50),
                  primary: const Color.fromRGBO(0, 153, 204, 1)),
              onPressed: () {
                widget.index = Random().nextInt(widget.data.length);
                context
                    .dependOnInheritedWidgetOfExactType<DataItherited>()!
                    .index = widget.index;
                setState(() {});
              },
              child: const Icon(Icons.loop)),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  minimumSize: const Size(50, 50),
                  primary: const Color.fromRGBO(0, 153, 204, 1)),
              onPressed: () {
                if (widget.index < widget.data.length - 1) {
                  widget.index += 1;
                  context
                      .dependOnInheritedWidgetOfExactType<DataItherited>()!
                      .index += 1;
                  setState(() {});
                }
              },
              child: const Icon(Icons.navigate_next))
        ])
      ],
    );
  }
}
