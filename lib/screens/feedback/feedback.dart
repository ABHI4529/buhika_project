import 'package:flutter/material.dart' as mat;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class FeedBack extends StatefulWidget {
  FeedBack({Key? key}) : super(key: key);

  @override
  State<FeedBack> createState() => _FeedbackState();
}

class _FeedbackState extends State<FeedBack> {
  List _tdsub = ["Python", "Java", "C++", "Computer Management"];
  double _value = 1;
  String sliderValue = "0";
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
                child: Text("Select Subject"),
                onPressed: () {},
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                        colors: [Color(0xff35A4C8), Color(0xff4F62A2)])),
                child: Expander(
                    headerBackgroundColor: ButtonState.resolveWith<Color>(
                        (states) => Colors.transparent),
                    contentBackgroundColor: Colors.transparent,
                    header: const Text(
                      "How was the teaching experience ?",
                      style: TextStyle(
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
                            showLabels: true,
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
                            value: _value,
                            labelFormatterCallback: (acutalValue, formatText) {
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
                                _value = value;
                              });
                            }),
                      ),
                    )))
          ],
        ),
      ),
    );
  }
}
