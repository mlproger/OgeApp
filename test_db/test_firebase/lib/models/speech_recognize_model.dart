import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/widgets.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:test_firebase/models/termins_model.dart';

import '../screens/sreen_recognize.dart';
import '../servicies/crud.dart';

class RecogmizeTextDataModel extends ChangeNotifier {
  List<Termin>? data;
  int? index;

  void incrementIndex() {
    if (index! < data!.length - 1) {
      index = 1 + index!;
    }
    notifyListeners();
  }

  void decrementIndex() {
    if (index! > 0) {
      index = index! - 1;
    }
    notifyListeners();
  }

  void getRandom() {
    index = Random().nextInt(data!.length);
    notifyListeners();
  }

  void add(String word, String descriptions, String collectionsName) async {
    await CrudMethods().addTermin(
        word: word,
        descriptions: descriptions,
        collectionsName: collectionsName);
    data = await CrudMethods().getData(collectionsName);
    notifyListeners();
  }
}

class SpeechApi {
  static final _speech = SpeechToText();

  static Future<bool> toggleRecording(
      {required Function(String text) onResult,
      required ValueChanged<bool> onListening,
      required BuildContext context,
      }) async {
    if (_speech.isListening) {
      _speech.stop();
      return true;
    }

    final isAvailable = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done') {
          _speech.stop();
        }
        onListening(_speech.isListening);
      },
      onError: (e) {
        // AwesomeDialog(
        //         context: context,
        //         animType: AnimType.BOTTOMSLIDE,
        //         dialogType: DialogType.ERROR,
        //         btnCancelText: 'Хорошо',
        //         btnCancelOnPress: () {},
        //         title:
        //             "Провертье, разрешён ли доступ к микрофону, либо же не забудьте что-то сказать :)")
        //     .show();
      },
      finalTimeout: Duration(seconds: 10),
    );

    if (isAvailable) {
      _speech.listen(
          listenFor: Duration(seconds: 30),
          pauseFor: Duration(seconds: 5),
          onResult: (value) {
            onResult(value.recognizedWords);
          });
    }

    return isAvailable;
  }
}
