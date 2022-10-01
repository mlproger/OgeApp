// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cool_alert/cool_alert.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:provider/provider.dart';
// import 'package:speech_to_text/speech_recognition_event.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:speech_to_text/speech_to_text_provider.dart';
// import 'package:test_firebase/main.dart';
// import 'package:test_firebase/models/termins_model.dart';
// import 'package:test_firebase/servicies/crud.dart';
// import 'package:string_similarity/string_similarity.dart';
// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:test_firebase/main.dart';

// import '../models/speech_recognize_model.dart';

// class RecognizeScreen extends StatefulWidget {
//   int index;
//   List<Termin> data;
//   RecognizeScreen({Key? key, required this.index, required this.data})
//       : super(key: key);

//   @override
//   State<RecognizeScreen> createState() => _RecognizeScreenState();
// }

// class _RecognizeScreenState extends State<RecognizeScreen> {
//   final wordController = TextEditingController();
//   final desController = TextEditingController();
//   late String? name;
//   late String? collectionsName;
//   String text = 'Нажмите на микрофон, чтобы дать определение';
//   bool isListening = false;
//   double procentOfCorrectAnswer = 0;

//   @override
//   void initState() {
//     super.initState();
//     setUp();
//   }

//   Future setUp() async {
//     setState(() {});
//     recognize(widget.index, widget.data);
//   }

//   void recognize(int index, List<Termin> data) {
//     //speechProvider.addListener(() {});
//     speechProvider.stream.listen((recognitionEvent) {
//       if (recognitionEvent.eventType == SpeechRecognitionEventType.doneEvent) {
//         print(text);
//         print(widget.data[widget.index].word);
//         procentOfCorrectAnswer = text
//             .toUpperCase()
//             .similarityTo(widget.data[widget.index].descriptions.toUpperCase());
//         int mar = ((procentOfCorrectAnswer * 100).ceil() / 20).round();
//         if (mar <= 3) {
//           AwesomeDialog(
//             context: context,
//             dialogType: DialogType.WARNING,
//             animType: AnimType.SCALE,
//             btnCancelText: 'Повторить термин',
//             btnCancelColor: Colors.blue,
//             btnOkText: 'Попробовать еще раз',
//             btnCancelOnPress: () {
//               CoolAlert.show(
//                   context: context,
//                   type: CoolAlertType.info,
//                   title: "${widget.data[widget.index].word} ",
//                   text: widget.data[widget.index].descriptions);
//             },
//             btnOkOnPress: () {},
//             title:
//                 "Вам следует повторить, что такое ${widget.data[widget.index].word}",
//             desc:
//                 "Ваша оценка - 2\nПроцент знания термина - ${(procentOfCorrectAnswer * 100).ceil()}",
//           ).show();
//         }
//         if (mar == 4) {
//           AwesomeDialog(
//             context: context,
//             dialogType: DialogType.SUCCES,
//             animType: AnimType.SCALE,
//             btnOkText: 'Учиться дальше',
//             btnCancelText: 'Повторить термин',
//             btnOkOnPress: () {
//               widget.index = Random().nextInt(widget.data.length);
//               setState(() {});
//             },
//             btnCancelOnPress: () async {
//               CoolAlert.show(
//                   context: context,
//                   type: CoolAlertType.info,
//                   title: "${widget.data[widget.index].word} ",
//                   text: widget.data[widget.index].descriptions);
//               setState(() {});
//             },
//             title: "Возиожно, стоит закрепить знания",
//             desc:
//                 "Ваша оценка - $mar\nПроцент знания термина - ${(procentOfCorrectAnswer * 100).ceil()}",
//           ).show();
//         }
//         if (mar == 5) {
//           AwesomeDialog(
//             context: context,
//             dialogType: DialogType.SUCCES,
//             animType: AnimType.SCALE,
//             btnOkText: 'Учиться дальше',
//             btnOkOnPress: () {
//               widget.index = Random().nextInt(widget.data.length);
//               setState(() {});
//             },
//             title: "Так держать, всё верно!",
//             desc:
//                 "Ваша оценка - $mar\nПроцент знания термина - ${(procentOfCorrectAnswer * 100).ceil()}",
//           ).show();
//         }
//         speechProvider.cancel();
//         speechProvider.stop();
//         speechProvider.removeListener(() {});
//       }
//       if (recognitionEvent.eventType ==
//           SpeechRecognitionEventType.partialRecognitionEvent) {
//         setState(() {
//           text = speechProvider.lastResult!.recognizedWords.toString();
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // List<Termin> data =
//     //     context.findAncestorWidgetOfExactType<DataItherited>()!.data;
//     // if (data != context.findAncestorWidgetOfExactType<DataItherited>()!.data) {
//     //   context.findAncestorWidgetOfExactType<DataItherited>()!.data = data;
//     // }
//     name = context.findAncestorWidgetOfExactType<DataItherited>()!.name;
//     collectionsName =
//         context.findAncestorWidgetOfExactType<DataItherited>()!.collectionsName;
//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(23, 28, 38, 1),
//       appBar: AppBar(
//         backgroundColor: const Color.fromRGBO(23, 28, 38, 1),
//         title: Text(name!),
//         leading: GestureDetector(
//           onTap: () async {
//             {
//               Navigator.pushNamed(context, '/main');
//               speechProvider.stop();
//               speechProvider.cancel();
//               speechProvider.removeListener(() {});
//               await speechProvider.stream.length.then(
//                 (value) => print(value),
//               );
//               print(speechProvider.stream.length);
//               //speechProvider.dispose();
//               super.deactivate();
//             }
//           },
//           child: const Icon(Icons.navigate_before),
//         ),
//       ),
//       endDrawer: Drawer(
//           backgroundColor: const Color.fromRGBO(23, 28, 38, 1),
//           child: StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance
//                 .collection(collectionsName!)
//                 .orderBy("word")
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 var dataSnap = snapshot.data;
//                 return ListView.builder(
//                     itemBuilder: (context, index) {
//                       return Slidable(
//                         key: const ValueKey(0),
//                         endActionPane: ActionPane(
//                           extentRatio: 0.4,
//                           motion: ScrollMotion(),
//                           children: [
//                             SlidableAction(
//                               onPressed: ((context) async {
//                                 CrudMethods().delete(
//                                     dataSnap!.docs[index].id, collectionsName!);
//                                 widget.data = await CrudMethods()
//                                     .getData(collectionsName!);
//                                 setState(() {});
//                               }),
//                               backgroundColor: Color(0xFFFE4A49),
//                               foregroundColor: Colors.white,
//                               icon: Icons.delete,
//                             ),
//                             SlidableAction(
//                               onPressed: ((context) => {}),
//                               backgroundColor: Color(0xFF21B7CA),
//                               foregroundColor: Colors.white,
//                               icon: Icons.edit,
//                             ),
//                           ],
//                         ),
//                         child: GestureDetector(
//                           onTap: () {
//                             CoolAlert.show(
//                                 backgroundColor:
//                                     const Color.fromRGBO(23, 28, 38, 1),
//                                 context: context,
//                                 type: CoolAlertType.info,
//                                 title: "${dataSnap!.docs[index]['word']} ",
//                                 text: dataSnap.docs[index]['descriptions']);
//                           },
//                           child: ListTile(
//                             title: Text(
//                               widget.data[index].word,
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                     itemCount: dataSnap!.docs.length);
//               }
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             },
//           )),
//       body: Center(
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 30,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: AutoSizeText(
//                 '${widget.data[widget.index].word} ЭТО... \n ',
//                 maxLines: 2,
//                 textAlign: TextAlign.center,
//                 style:
//                     GoogleFonts.alumniSans(fontSize: 35, color: Colors.white),
//                 minFontSize: 35,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Text(text,
//                   textAlign: TextAlign.center,
//                   style: GoogleFonts.alumniSans(
//                       fontSize: 25, color: Colors.white)),
//             )
//           ],
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: const Color.fromRGBO(255, 182, 71, 1),
//         onPressed: () {
//           if (available) {
//             speechProvider.listen();
//           } else {
//             speechProvider.stop();
//           }
//         },
//         tooltip: 'Listen',
//         child: Icon(speechProvider.isListening ? Icons.mic : Icons.mic_off),
//       ),
//       persistentFooterButtons: [
//         Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
//           ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   shape: const CircleBorder(),
//                   minimumSize: const Size(50, 50),
//                   primary: const Color.fromRGBO(0, 153, 204, 1)),
//               onPressed: () {
//                 if (widget.index > 0) {
//                   widget.index -= 1;
//                   setState(() {});
//                 }
//               },
//               child: const Icon(Icons.navigate_before)),
//           ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   shape: const CircleBorder(),
//                   minimumSize: const Size(50, 50),
//                   primary: const Color.fromRGBO(0, 153, 204, 1)),
//               onPressed: () {
//                 widget.index = Random().nextInt(widget.data.length);
//                 setState(() {});
//               },
//               child: const Icon(Icons.loop)),
//           ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   shape: const CircleBorder(),
//                   minimumSize: const Size(50, 50),
//                   primary: const Color.fromRGBO(0, 153, 204, 1)),
//               onPressed: () {
//                 showDialog(
//                     context: context,
//                     builder: (context) {
//                       return AlertDialog(
//                         content: Column(children: [
//                           TextField(
//                             controller: wordController,
//                           ),
//                           TextField(
//                             controller: desController,
//                           ),
//                           ElevatedButton(
//                             onPressed: () async {
//                               CrudMethods().addTermin(
//                                   word: wordController.text,
//                                   descriptions: desController.text,
//                                   collectionsName: collectionsName!);
//                               widget.data =
//                                   await CrudMethods().getData(collectionsName!);
//                               // context
//                               //     .findAncestorWidgetOfExactType<
//                               //         DataItherited>()
//                               //     ?.data = widget.data;
//                               // print(context
//                               //     .findAncestorWidgetOfExactType<
//                               //         DataItherited>()
//                               //     ?.data
//                               //     .length);
//                               //data = widget.data;
//                               //setState(() {});
//                               wordController.clear();
//                               desController.clear();
//                               Navigator.of(context).pop();
//                             },
//                             child: const Icon(Icons.add),
//                           )
//                         ]),
//                       );
//                     });
//               },
//               child: const Icon(Icons.add)),
//           ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   shape: const CircleBorder(),
//                   minimumSize: const Size(50, 50),
//                   primary: const Color.fromRGBO(0, 153, 204, 1)),
//               onPressed: () {
//                 if (widget.index < widget.data.length - 1) {
//                   widget.index += 1;
//                   setState(() {});
//                 }
//               },
//               child: const Icon(Icons.navigate_next))
//         ])
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:test_firebase/models/termins_model.dart';

// class DataItherited extends InheritedWidget {
//   List<Termin> data;
//   final String name;
//   final String collectionsName;
//   DataItherited(
//       {Key? key,
//       required child,
//       required this.data,
//       required this.name,
//       required this.collectionsName})
//       : super(key: key, child: child);

//   static DataItherited? of(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<DataItherited>();
//   }

//   @override
//   bool updateShouldNotify(DataItherited oldWidget) {
//     return data != oldWidget.data;
//   }
// }
