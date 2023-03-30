import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' as mat;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../dataModals/feedbackmmodal.dart';

class FeedBack extends StatefulWidget {
  FeedBack({Key? key, this.field}) : super(key: key);
  String? field;

  @override
  State<FeedBack> createState() => _FeedbackState();
}

class _FeedbackState extends State<FeedBack> {
  List _tdsub = ["Python", "Java", "C++", "Computer Management"];
  double _value = 1;
  String sliderValue = "0";
  String selected_subejct = "Select Subject";
  List<FeedbackModal> feedbacks = [
    FeedbackModal(
        question:
            "How clearly did your instructor explain the course material??",
        value: 1),
    FeedbackModal(
        question: "How well did your instructor answer students questions?",
        value: 1),
    FeedbackModal(
        question:
            "Was the speed with which your instructor presented the course material too fast, too slow or about right?",
        value: 1),
    FeedbackModal(
        question: "How would you rate this lesson out of 5?", value: 1),
  ];

  Future<String> getfield() async {
    String field = "";
    final firebase = await FirebaseFirestore.instance
        .collection('students')
        .where('email', isEqualTo: widget.field)
        .get();
    print(widget.field);
    firebase.docs.forEach((element) {
      field = element['field'];

    });
    debugPrint(firebase.docs.length.toString());
    return field;
  }

  @override
  Widget build(BuildContext context) {
    return mat.Scaffold(
      backgroundColor: Colors.white,
      appBar: mat.AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Feedback",
          style: TextStyle(
              color: Color(0xff474747),
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              child: TextButton(
                child: Text(selected_subejct),
                onPressed: () {
                  showBottomSheet(
                      backgroundColor: Colors.white,
                      context: context,
                      builder: (context) {
                        return BottomSheet(
                          header: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: const Text(
                              "Select Subject",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          children: _tdsub
                              .map((e) => ListTile(
                                    title: Text(e),
                                    onPressed: () {
                                      setState(() {
                                        selected_subejct = "$e";
                                      });
                                      Navigator.pop(context);
                                    },
                                  ))
                              .toList(),
                        );
                      });
                },
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: feedbacks
                  .map((e) => Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                              colors: [Color(0xff35A4C8), Color(0xff4F62A2)])),
                      child: Expander(
                          headerBackgroundColor: ButtonState.resolveWith<Color>(
                              (states) => Colors.transparent),
                          contentBackgroundColor: Colors.transparent,
                          headerHeight: 100,
                          initiallyExpanded: true,
                          header: Text(
                            "${e.question}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          content: SfSliderTheme(
                            data: SfSliderThemeData(
                              activeLabelStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              inactiveLabelStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              tooltipBackgroundColor: Colors.white,
                              tooltipTextStyle:
                                  const TextStyle(color: Color(0xff265778)),
                            ),
                            child: Container(
                              padding: const mat.EdgeInsets.all(10),
                              margin: const EdgeInsets.only(top: 20),
                              child: SfSlider(
                                  activeColor: const Color(0xff265778),
                                  min: 1,
                                  max: 5.0,
                                  interval: 1,
                                  stepSize: 1,
                                  enableTooltip: true,
                                  tooltipTextFormatterCallback:
                                      (acutalValue, formatText) {
                                    switch (acutalValue) {
                                      case 1:
                                        return 'Worst';
                                      case 2:
                                        return 'Unsatisfied';
                                      case 3:
                                        return 'Can be better';
                                      case 4:
                                        return 'Satisfied';
                                      case 5:
                                        return 'Very Saisfied';
                                    }
                                    return acutalValue.toString();
                                  },
                                  showTicks: true,
                                  inactiveColor: Colors.white,
                                  value: e.value?.toDouble(),
                                  labelFormatterCallback:
                                      (acutalValue, formatText) {
                                    switch (acutalValue) {
                                      case 1:
                                        return 'Worst';
                                      case 2:
                                        return 'Unsatisfied';
                                      case 3:
                                        return 'Can be better';
                                      case 4:
                                        return 'Satisfied';
                                      case 5:
                                        return 'Very Saisfied';
                                    }
                                    return acutalValue.toString();
                                  },
                                  labelPlacement: LabelPlacement.onTicks,
                                  onChanged: (value) {
                                    setState(() {
                                      e.value = value;
                                    });
                                  }),
                            ),
                          ))))
                  .toList(),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 50),
              child: SizedBox(
                  height: 40,
                  width: 150,
                  child: FilledButton(
                    child: const Center(child: Text("Send Feedback")),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return ContentDialog(
                              title: const Text("Send Feedback ?"),
                              content: const Text(
                                  "Make sure you have filled feedback correctly"),
                              actions: [
                                TextButton(
                                  child: const Text("Cancel"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                FilledButton(
                                  child: const Text("Send"),
                                  onPressed: () async {
                                    if(selected_subejct == "Select Subject"){
                                      mat.ScaffoldMessenger.of(context).showSnackBar(
                                        const mat.SnackBar(content: Text("Select Subject"))
                                      );
                                    }else{
                                      final firebase = FirebaseFirestore.instance
                                          .collection('feedbacks');
                                      await getfield().then((value) {
                                        firebase.doc().set({
                                          "date": DateTime.now(),
                                          "field": value,
                                          "subject": selected_subejct,
                                          "feedback": feedbacks.map((e) => e.toJson()).toList(),
                                        }).then((value) => Navigator.pop(context));
                                      });
                                    }
                                  },
                                )
                              ],
                            );
                          });
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }
}
