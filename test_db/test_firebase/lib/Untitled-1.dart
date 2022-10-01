    //     _speechProvider.stream.listen((recognitionEvent) {
    //   if (recognitionEvent.eventType == SpeechRecognitionEventType.doneEvent) {
    //     print(text);
    //     print(widget.data[widget.index].word);
    //     procentOfCorrectAnswer = text
    //         .toUpperCase()
    //         .similarityTo(widget.data[widget.index].descriptions.toUpperCase());
    //     int mar = ((procentOfCorrectAnswer * 100).ceil() / 20).round();
    //     if (mar <= 3) {
    //       AwesomeDialog(
    //         context: context,
    //         dialogType: DialogType.WARNING,
    //         animType: AnimType.SCALE,
    //         btnCancelText: 'Повторить термин',
    //         btnCancelColor: Colors.blue,
    //         btnOkText: 'Попробовать еще раз',
    //         btnCancelOnPress: () {
    //           CoolAlert.show(
    //               context: context,
    //               type: CoolAlertType.info,
    //               title: "${widget.data[widget.index].word} ",
    //               text: widget.data[widget.index].descriptions);
    //         },
    //         btnOkOnPress: () {},
    //         title:
    //             "Вам следует повторить, что такое ${widget.data[widget.index].word}",
    //         desc:
    //             "Ваша оценка - 2\nПроцент знания термина - ${(procentOfCorrectAnswer * 100).ceil()}",
    //       ).show();
    //     }
    //     if (mar == 4) {
    //       AwesomeDialog(
    //         context: context,
    //         dialogType: DialogType.SUCCES,
    //         animType: AnimType.SCALE,
    //         btnOkText: 'Учиться дальше',
    //         btnCancelText: 'Повторить термин',
    //         btnOkOnPress: () {
    //           widget.index = Random().nextInt(widget.data.length);
    //           setState(() {});
    //         },
    //         btnCancelOnPress: () async {
    //           CoolAlert.show(
    //               context: context,
    //               type: CoolAlertType.info,
    //               title: "${widget.data[widget.index].word} ",
    //               text: widget.data[widget.index].descriptions);
    //           setState(() {});
    //         },
    //         title: "Возиожно, стоит закрепить знания",
    //         desc:
    //             "Ваша оценка - $mar\nПроцент знания термина - ${(procentOfCorrectAnswer * 100).ceil()}",
    //       ).show();
    //     }
    //     if (mar == 5) {
    //       AwesomeDialog(
    //         context: context,
    //         dialogType: DialogType.SUCCES,
    //         animType: AnimType.SCALE,
    //         btnOkText: 'Учиться дальше',
    //         btnOkOnPress: () {
    //           widget.index = Random().nextInt(widget.data.length);
    //           setState(() {});
    //         },
    //         title: "Так держать, всё верно!",
    //         desc:
    //             "Ваша оценка - $mar\nПроцент знания термина - ${(procentOfCorrectAnswer * 100).ceil()}",
    //       ).show();
    //     }
    //     // speechProvider.cancel();
    //     // speechProvider.stop();
    //     // speechProvider.removeListener(() {});
    //   }
    //   if (recognitionEvent.eventType ==
    //       SpeechRecognitionEventType.partialRecognitionEvent) {
    //     setState(() {
    //       text = _speechProvider.lastResult!.recognizedWords.toString();
    //     });
    //   }
    // });